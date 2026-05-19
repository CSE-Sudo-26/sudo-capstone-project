import { useState } from 'react';
import { MapPin, Star, MessageCircle, CheckCircle } from 'lucide-react';

export function Place() {
  const [selectedGym, setSelectedGym] = useState<number | null>(null);

  const gyms = [
    {
      name: '강남 피트니스 센터',
      distance: '0.8km',
      rating: 4.7,
      trainer: '김트레이너',
      specialties: ['다이어트', '재활운동'],
    },
    {
      name: '헬스메이트 역삼점',
      distance: '1.2km',
      rating: 4.5,
      trainer: '이트레이너',
      specialties: ['근력운동', '만성질환 관리'],
    },
    {
      name: '바디앤소울 피트니스',
      distance: '1.5km',
      rating: 4.8,
      trainer: '박트레이너',
      specialties: ['PT', '식단 상담'],
    },
  ];

  return (
    <div className="pb-20 bg-background min-h-screen">
      <div className="h-48 bg-gradient-to-br from-blue-400 to-blue-600 relative">
        <div className="absolute inset-0 flex items-center justify-center text-white">
          <div className="text-center">
            <MapPin size={48} className="mx-auto mb-2" />
            <p>지도 영역</p>
            <p className="text-sm opacity-80">주변 헬스장 3곳</p>
          </div>
        </div>
      </div>

      <div className="px-4 pt-4 space-y-3 max-w-2xl mx-auto">
        {gyms.map((gym, index) => (
          <div
            key={index}
            className="bg-card rounded-2xl shadow-sm border border-border p-5"
          >
            <div className="flex justify-between items-start mb-3">
              <div>
                <h3 className="font-medium mb-1">{gym.name}</h3>
                <div className="flex items-center gap-3 text-sm text-muted-foreground">
                  <span>{gym.distance}</span>
                  <div className="flex items-center gap-1">
                    <Star size={14} className="fill-yellow-400 text-yellow-400" />
                    <span>{gym.rating}</span>
                  </div>
                </div>
              </div>
              <button className="px-4 py-2 bg-primary/10 text-primary rounded-lg text-sm">
                예약
              </button>
            </div>

            <div className="flex gap-2 mb-3">
              {gym.specialties.map((specialty, i) => (
                <span
                  key={i}
                  className="px-3 py-1 bg-accent text-sm rounded-full"
                >
                  {specialty}
                </span>
              ))}
            </div>

            <button
              onClick={() => setSelectedGym(selectedGym === index ? null : index)}
              className="w-full py-3 bg-primary text-white rounded-xl flex items-center justify-center gap-2"
            >
              <MessageCircle size={18} />
              {gym.trainer}와 1:1 상담
            </button>

            {selectedGym === index && (
              <div className="mt-4 p-4 bg-accent rounded-xl">
                <div className="flex items-center gap-2 mb-3 text-green-600">
                  <CheckCircle size={18} />
                  <p className="text-sm">건강 데이터 요약본 전송 완료</p>
                </div>

                <div className="space-y-2 mb-3 text-sm">
                  <p className="text-muted-foreground">전송된 정보:</p>
                  <p>• 최근 7일 식단 기록</p>
                  <p>• 운동 이력</p>
                  <p>• 고혈압 위험군 프로필</p>
                </div>

                <div className="bg-white rounded-xl p-3 space-y-2">
                  <div className="flex items-center gap-2">
                    <div className="w-8 h-8 bg-primary rounded-full flex items-center justify-center text-white text-sm">
                      김
                    </div>
                    <p className="text-sm">안녕하세요! 자료 잘 받았습니다.</p>
                  </div>
                  <div className="flex items-center gap-2 justify-end">
                    <p className="text-sm bg-primary text-white px-3 py-2 rounded-xl">
                      상담 가능한가요?
                    </p>
                    <div className="w-8 h-8 bg-muted rounded-full" />
                  </div>
                </div>

                <div className="mt-3 flex gap-2">
                  <input
                    type="text"
                    placeholder="메시지 입력..."
                    className="flex-1 px-3 py-2 bg-white rounded-lg text-sm outline-none"
                  />
                  <button className="px-4 py-2 bg-primary text-white rounded-lg text-sm">
                    전송
                  </button>
                </div>
              </div>
            )}
          </div>
        ))}
      </div>
    </div>
  );
}
