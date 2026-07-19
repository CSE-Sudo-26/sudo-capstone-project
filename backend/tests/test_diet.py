"""식단 사진분석(/diet/analyze) — DB 필요(로컬 skip, CI 실행).

CI 엔 GEMINI_API_KEY 가 없으므로 오프라인 스텁 인식기 경로를 검증한다
(이미지 내용과 무관하게 결정론적 식단 → 공공 영양 DB 매핑 → 저장).
"""
from __future__ import annotations

from uuid import uuid4

_JPEG = b"\xff\xd8\xff\xe0\x00\x10JFIF fake-image-bytes"


def test_analyze_offline_saves_and_reflects_in_today(client):
    r = client.post(
        "/v1/diet/analyze",
        files={"image": ("food.jpg", _JPEG, "image/jpeg")},
        data={"meal_type": "lunch"},
    )
    assert r.status_code == 200, r.text
    body = r.json()
    assert body["entry_id"]
    foods = body["analysis"]["foods"]
    assert foods  # 인식된 음식이 있어야
    # 공공 영양 DB 매핑으로 신뢰 수치가 채워짐(비빔밥/김치는 시드에 존재)
    assert body["analysis"]["total_calories"] > 0
    assert any(f["source"] == "db" for f in foods)

    today = client.get("/v1/diet/days/today")
    assert today.status_code == 200
    assert today.json()["total_calories"] > 0


def test_analyze_idempotency_key_dedupes_retry(client):
    key = f"idem-{uuid4().hex}"
    first = client.post(
        "/v1/diet/analyze",
        files={"image": ("food.jpg", _JPEG, "image/jpeg")},
        data={"meal_type": "lunch", "idempotency_key": key},
    )
    assert first.status_code == 200, first.text
    eid = first.json()["entry_id"]

    # 응답 유실 후 재시도를 흉내 — 같은 키로 재요청하면 새 저장 없이 기존 entry 반환.
    second = client.post(
        "/v1/diet/analyze",
        files={"image": ("food.jpg", _JPEG, "image/jpeg")},
        data={"meal_type": "lunch", "idempotency_key": key},
    )
    assert second.status_code == 200, second.text
    assert second.json()["entry_id"] == eid

    today = client.get("/v1/diet/days/today").json()["entries"]
    assert sum(1 for e in today if e["id"] == eid) == 1


def test_analyze_rejects_overlong_idempotency_key(client):
    # DB 컬럼(String(64))을 넘는 키는 DB 도달 전 API 경계(max_length=64)에서
    # 422 로 거부되어야 한다(초과 시 PostgreSQL DataError→500 방지).
    overlong = "x" * 65
    r = client.post(
        "/v1/diet/analyze",
        files={"image": ("food.jpg", _JPEG, "image/jpeg")},
        data={"meal_type": "lunch", "idempotency_key": overlong},
    )
    assert r.status_code == 422, r.text

    # 경계값(정확히 64자)은 정상 처리되어야 한다.
    ok = client.post(
        "/v1/diet/analyze",
        files={"image": ("food.jpg", _JPEG, "image/jpeg")},
        data={"meal_type": "lunch", "idempotency_key": "y" * 64},
    )
    assert ok.status_code == 200, ok.text


def test_analyze_without_key_creates_distinct_entries(client):
    a = client.post(
        "/v1/diet/analyze",
        files={"image": ("food.jpg", _JPEG, "image/jpeg")},
        data={"meal_type": "lunch"},
    ).json()["entry_id"]
    b = client.post(
        "/v1/diet/analyze",
        files={"image": ("food.jpg", _JPEG, "image/jpeg")},
        data={"meal_type": "lunch"},
    ).json()["entry_id"]
    assert a != b


def test_analyze_rejects_unsupported_mime(client):
    r = client.post(
        "/v1/diet/analyze",
        files={"image": ("note.txt", b"hello", "text/plain")},
        data={"meal_type": "lunch"},
    )
    assert r.status_code == 415


def test_analyze_rejects_empty_file(client):
    r = client.post(
        "/v1/diet/analyze",
        files={"image": ("food.jpg", b"", "image/jpeg")},
        data={"meal_type": "lunch"},
    )
    assert r.status_code == 400


def test_delete_entry_removes_from_today(client):
    # diet 테스트는 데모 사용자를 공유하므로(무인증) 전역 합계 대신
    # 이 엔트리 id 의 유무로 검증한다.
    entry_id = client.post(
        "/v1/diet/analyze",
        files={"image": ("food.jpg", _JPEG, "image/jpeg")},
        data={"meal_type": "lunch"},
    ).json()["entry_id"]

    before = client.get("/v1/diet/days/today").json()["entries"]
    assert any(e["id"] == entry_id for e in before)

    d = client.delete(f"/v1/diet/entries/{entry_id}")
    assert d.status_code == 200, d.text
    assert d.json()["status"] == "deleted"

    after = client.get("/v1/diet/days/today").json()["entries"]
    assert all(e["id"] != entry_id for e in after)


def test_delete_entry_404_when_missing(client):
    r = client.delete("/v1/diet/entries/diet-nope")
    assert r.status_code == 404


def test_update_entry_changes_meal_type(client):
    entry_id = client.post(
        "/v1/diet/analyze",
        files={"image": ("food.jpg", _JPEG, "image/jpeg")},
        data={"meal_type": "lunch"},
    ).json()["entry_id"]

    r = client.put(
        f"/v1/diet/entries/{entry_id}",
        json={"meal_type": "dinner", "time_label": "19:30"},
    )
    assert r.status_code == 200, r.text
    assert r.json()["meal_type"] == "dinner"
    assert r.json()["time_label"] == "19:30"

    # 공유 데모 사용자라 전역 합계 대신 id 로 확인.
    today = client.get("/v1/diet/days/today").json()["entries"]
    mine = next(e for e in today if e["id"] == entry_id)
    assert mine["meal_type"] == "dinner"


def test_update_entry_404_when_missing(client):
    r = client.put("/v1/diet/entries/diet-nope", json={"meal_type": "dinner"})
    assert r.status_code == 404
