"""식단 사진분석(/diet/analyze) — DB 필요(로컬 skip, CI 실행).

CI 엔 GEMINI_API_KEY 가 없으므로 오프라인 스텁 인식기 경로를 검증한다
(이미지 내용과 무관하게 결정론적 식단 → 공공 영양 DB 매핑 → 저장).
"""
from __future__ import annotations

import uuid

import pytest
from sqlalchemy import delete, select

_JPEG = b"\xff\xd8\xff\xe0\x00\x10JFIF fake-image-bytes"


def test_macro_percentage_uses_449_energy_and_handles_zero():
    from app.schemas.diet_api import calculate_macros

    assert calculate_macros(45.0, 22.5, 10.0).model_dump() == {
        "carbs_g": 45.0,
        "protein_g": 22.5,
        "fat_g": 10.0,
        "carbs_pct": 50,
        "protein_pct": 25,
        "fat_pct": 25,
    }
    assert calculate_macros(0.0, 0.0, 0.0).model_dump() == {
        "carbs_g": 0.0,
        "protein_g": 0.0,
        "fat_g": 0.0,
        "carbs_pct": 0,
        "protein_pct": 0,
        "fat_pct": 0,
    }


def test_analyze_offline_saves_and_reflects_macros_in_today(client, db_session):
    from app.api.v1.diet import _today_str
    from app.db.init_db import DEMO_USER_ID
    from app.models.models import DietEntry, FoodNutrient

    # Isolate exact daily totals, then give the two stub-recognized foods DB macros.
    db_session.execute(
        delete(DietEntry).where(
            DietEntry.user_id == DEMO_USER_ID,
            DietEntry.date == _today_str(),
        )
    )
    bibimbap = db_session.scalar(select(FoodNutrient).where(FoodNutrient.name == "비빔밥"))
    kimchi = db_session.scalar(select(FoodNutrient).where(FoodNutrient.name == "김치"))
    assert bibimbap is not None and kimchi is not None
    bibimbap.carbs_g, bibimbap.protein_g, bibimbap.fat_g = 40.0, 20.0, 8.0
    kimchi.carbs_g, kimchi.protein_g, kimchi.fat_g = 5.0, 2.5, 2.0
    db_session.commit()

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
    assert body["analysis"]["total_carbs_g"] == 45.0
    assert body["analysis"]["total_protein_g"] == 22.5
    assert body["analysis"]["total_fat_g"] == 10.0
    assert all({"carbs_g", "protein_g", "fat_g"} <= f.keys() for f in foods)

    stored = db_session.get(DietEntry, body["entry_id"])
    assert stored is not None
    assert (stored.carbs_g, stored.protein_g, stored.fat_g) == (45.0, 22.5, 10.0)

    second = client.post(
        "/v1/diet/analyze",
        files={"image": ("food.jpg", _JPEG, "image/jpeg")},
        data={"meal_type": "dinner"},
    )
    assert second.status_code == 200, second.text

    today = client.get("/v1/diet/days/today")
    assert today.status_code == 200
    today_body = today.json()
    assert today_body["total_calories"] > 0
    assert len(today_body["entries"]) == 2
    assert all(entry["carbs_g"] == 45.0 for entry in today_body["entries"])
    assert all(entry["protein_g"] == 22.5 for entry in today_body["entries"])
    assert all(entry["fat_g"] == 10.0 for entry in today_body["entries"])
    assert today_body["macros"] == {
        "carbs_g": 90.0,
        "protein_g": 45.0,
        "fat_g": 20.0,
        "carbs_pct": 50,
        "protein_pct": 25,
        "fat_pct": 25,
    }


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


def test_update_entry_changes_nutrition_and_today_totals(client, db_session):
    from app.api.v1.diet import _today_str
    from app.db.init_db import DEMO_USER_ID
    from app.models.models import DietEntry

    db_session.execute(
        delete(DietEntry).where(
            DietEntry.user_id == DEMO_USER_ID,
            DietEntry.date == _today_str(),
        )
    )
    db_session.commit()
    entry_id = client.post(
        "/v1/diet/analyze",
        files={"image": ("food.jpg", _JPEG, "image/jpeg")},
        data={"meal_type": "lunch"},
    ).json()["entry_id"]

    r = client.put(
        f"/v1/diet/entries/{entry_id}",
        json={
            "total_calories": 333,
            "carbs_g": 25.0,
            "protein_g": 12.5,
            "fat_g": 5.0,
            "sodium_mg": 444,
            "sugar_g": 7,
        },
    )
    assert r.status_code == 200, r.text
    assert r.json()["total_calories"] == 333
    assert r.json()["sodium_mg"] == 444
    assert r.json()["sugar_g"] == 7
    assert (r.json()["carbs_g"], r.json()["protein_g"], r.json()["fat_g"]) == (
        25.0, 12.5, 5.0,
    )

    today = client.get("/v1/diet/days/today").json()
    assert today["total_calories"] == 333
    assert today["total_sodium_mg"] == 444
    assert today["total_sugar_g"] == 7
    assert today["macros"] == {
        "carbs_g": 25.0,
        "protein_g": 12.5,
        "fat_g": 5.0,
        "carbs_pct": 51,
        "protein_pct": 26,
        "fat_pct": 23,
    }

    zeroed = client.put(
        f"/v1/diet/entries/{entry_id}",
        json={"carbs_g": 0, "protein_g": 0, "fat_g": 0},
    )
    assert zeroed.status_code == 200
    assert client.get("/v1/diet/days/today").json()["macros"] == {
        "carbs_g": 0.0,
        "protein_g": 0.0,
        "fat_g": 0.0,
        "carbs_pct": 0,
        "protein_pct": 0,
        "fat_pct": 0,
    }


@pytest.mark.parametrize(
    "field",
    ["total_calories", "carbs_g", "protein_g", "fat_g", "sodium_mg", "sugar_g"],
)
def test_update_entry_rejects_negative_nutrition(client, field):
    entry_id = client.post(
        "/v1/diet/analyze",
        files={"image": ("food.jpg", _JPEG, "image/jpeg")},
        data={"meal_type": "lunch"},
    ).json()["entry_id"]

    r = client.put(f"/v1/diet/entries/{entry_id}", json={field: -0.1})
    assert r.status_code == 422


def test_update_entry_hides_other_users_record(client, db_session):
    from app.api.v1.diet import _today_str
    from app.models.models import DietEntry, User

    suffix = uuid.uuid4().hex[:12]
    other_user_id = f"diet-owner-{suffix}"
    other_entry_id = f"diet-other-{suffix}"
    db_session.add(User(
        id=other_user_id,
        email=f"{other_user_id}@example.com",
        name="Other User",
        hashed_password="",
    ))
    db_session.add(DietEntry(
        id=other_entry_id,
        user_id=other_user_id,
        date=_today_str(),
        meal_type="lunch",
    ))
    db_session.commit()

    r = client.put(f"/v1/diet/entries/{other_entry_id}", json={"carbs_g": 10})
    assert r.status_code == 404


def test_update_entry_404_when_missing(client):
    r = client.put("/v1/diet/entries/diet-nope", json={"meal_type": "dinner"})
    assert r.status_code == 404
