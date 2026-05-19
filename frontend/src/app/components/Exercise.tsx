import { useState } from 'react';
import { Plus, Clock, Flame, MapPin, Star, MessageCircle, CheckCircle, ChevronDown, ChevronUp, Calendar } from 'lucide-react';
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer } from 'recharts';
import { motion, AnimatePresence } from 'motion/react';
import { Header } from './Header';
import { NotificationPanel } from './NotificationPanel';

export function Exercise() {
  const [selectedGym, setSelectedGym] = useState<number | null>(null);
  const [showAddWorkout, setShowAddWorkout] = useState(false);
  const [showAICoach, setShowAICoach] = useState(false);
  const [activeView, setActiveView] = useState<'history' | 'gyms'>('history');
  const [chatMessage, setChatMessage] = useState('');
  const [showGymSearch, setShowGymSearch] = useState(false);
  const [hasMyGym, setHasMyGym] = useState(true); // 사용자가 등록한 헬스장이 있는지
  const [showNotifications, setShowNotifications] = useState(false);
  const [showGymDetail, setShowGymDetail] = useState<number | null>(null);
  const [showCalendar, setShowCalendar] = useState(false);

  const workoutHistory = [
    {
      date: '오늘',
      time: '14:30',
      type: '유산소',
      duration: 45,
      calories: 320,
      exercises: ['러닝머신 30분', '사이클 15분']
    },
    {
      date: '어제',
      time: '18:00',
      type: '근력',
      duration: 60,
      calories: 280,
      exercises: ['스쿼트 3세트', '벤치프레스 3세트', '데드리프트 3세트']
    },
    {
      date: '5월 12일',
      time: '15:00',
      type: '유산소',
      duration: 30,
      calories: 250,
      exercises: ['러닝머신 30분']
    }
  ];

  const weeklyChartData = [
    { day: '월', cardio: 30, strength: 0, stretch: 10 },
    { day: '화', cardio: 0, strength: 45, stretch: 15 },
    { day: '수', cardio: 40, strength: 0, stretch: 10 },
    { day: '목', cardio: 0, strength: 50, stretch: 15 },
    { day: '금', cardio: 45, strength: 0, stretch: 10 },
    { day: '토', cardio: 30, strength: 30, stretch: 20 },
    { day: '일', cardio: 0, strength: 0, stretch: 0 },
  ];

  const exerciseColors = {
    cardio: '#3EAFDF',
    strength: '#277DA1',
    stretch: '#90E0EF'
  };

  const weeklyStats = {
    totalWorkouts: 5,
    totalDuration: 240,
    totalCalories: 1450,
    streak: 3
  };

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

  const quickReplies = [
    '운동 루틴 추천해줘',
    '오늘 운동 괜찮았어?',
    '내일 뭐 할까?',
  ];

  const handleSendMessage = (message?: string) => {
    const text = message || chatMessage;
    if (!text.trim()) return;
    setChatMessage('');
  };

  const handleRegisterGym = (gymIndex: number) => {
    setHasMyGym(true);
    setShowGymSearch(false);
    // In a real app, this would save the gym data
  };

  return (
    <div className="pb-20 bg-background min-h-screen">
      <Header
        title="운동"
        onNotificationClick={() => setShowNotifications(true)}
        onCalendarClick={() => setShowCalendar(true)}
      />

      <NotificationPanel
        isOpen={showNotifications}
        onClose={() => setShowNotifications(false)}
        onNavigate={(path) => {
          console.log('Navigate to:', path);
        }}
      />

      <div className="sticky top-[73px] bg-background z-10 border-b border-border">
        <div className="px-4 py-4">
          <div className="flex gap-2 bg-accent rounded-xl p-1">
            <button
              onClick={() => setActiveView('history')}
              className={`flex-1 py-2 rounded-lg transition-colors ${
                activeView === 'history'
                  ? 'bg-white shadow-sm'
                  : 'hover:bg-white/50'
              }`}
            >
              <Calendar className="w-4 h-4 mx-auto mb-1" />
              <span className="text-sm">운동 기록</span>
            </button>
            <button
              onClick={() => setActiveView('gyms')}
              className={`flex-1 py-2 rounded-lg transition-colors ${
                activeView === 'gyms'
                  ? 'bg-white shadow-sm'
                  : 'hover:bg-white/50'
              }`}
            >
              <MapPin className="w-4 h-4 mx-auto mb-1" />
              <span className="text-sm">헬스장</span>
            </button>
          </div>
        </div>
      </div>

      {activeView === 'history' && (
        <div className="px-4 pt-4">
          <div className="grid grid-cols-4 gap-3 mb-6">
            <div className="bg-card border border-border rounded-xl p-3 text-center">
              <p className="text-sm text-muted-foreground mb-1">이번 주</p>
              <p className="text-xl font-medium text-primary">{weeklyStats.totalWorkouts}</p>
              <p className="text-xs text-muted-foreground">회</p>
            </div>
            <div className="bg-card border border-border rounded-xl p-3 text-center">
              <p className="text-sm text-muted-foreground mb-1">시간</p>
              <p className="text-xl font-medium">{weeklyStats.totalDuration}</p>
              <p className="text-xs text-muted-foreground">분</p>
            </div>
            <div className="bg-card border border-border rounded-xl p-3 text-center">
              <p className="text-sm text-muted-foreground mb-1">칼로리</p>
              <p className="text-xl font-medium">{weeklyStats.totalCalories}</p>
              <p className="text-xs text-muted-foreground">kcal</p>
            </div>
            <div className="bg-gradient-to-br from-orange-500 to-red-500 rounded-xl p-3 text-center text-white">
              <Flame className="w-4 h-4 mx-auto mb-1" />
              <p className="text-xl font-medium">{weeklyStats.streak}</p>
              <p className="text-xs opacity-90">일 연속</p>
            </div>
          </div>

          <div className="bg-card rounded-2xl shadow-sm border border-border p-6 mb-6">
            <h3 className="mb-4">이번 주 운동 현황</h3>
            <ResponsiveContainer width="100%" height={200}>
              <BarChart data={weeklyChartData}>
                <CartesianGrid strokeDasharray="3 3" stroke="#e5e7eb" />
                <XAxis dataKey="day" stroke="#6b7280" />
                <YAxis stroke="#6b7280" />
                <Tooltip />
                <Bar dataKey="cardio" name="유산소" stackId="a" fill={exerciseColors.cardio} radius={[0, 0, 0, 0]} />
                <Bar dataKey="strength" name="근력" stackId="a" fill={exerciseColors.strength} radius={[0, 0, 0, 0]} />
                <Bar dataKey="stretch" name="스트레칭" stackId="a" fill={exerciseColors.stretch} radius={[4, 4, 0, 0]} />
              </BarChart>
            </ResponsiveContainer>
            <div className="flex justify-center gap-4 mt-4">
              <div className="flex items-center gap-2">
                <div className="w-3 h-3 rounded-full" style={{ backgroundColor: exerciseColors.cardio }} />
                <span className="text-xs text-muted-foreground">유산소</span>
              </div>
              <div className="flex items-center gap-2">
                <div className="w-3 h-3 rounded-full" style={{ backgroundColor: exerciseColors.strength }} />
                <span className="text-xs text-muted-foreground">근력</span>
              </div>
              <div className="flex items-center gap-2">
                <div className="w-3 h-3 rounded-full" style={{ backgroundColor: exerciseColors.stretch }} />
                <span className="text-xs text-muted-foreground">스트레칭</span>
              </div>
            </div>
          </div>

          <div className="bg-card rounded-2xl shadow-sm border border-border mb-6">
            <button
              onClick={() => setShowAICoach(!showAICoach)}
              className="w-full px-6 py-4 flex items-center justify-between hover:bg-accent/50 transition-colors rounded-2xl"
            >
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 bg-primary/10 rounded-full flex items-center justify-center">
                  <span className="text-xl">🤖</span>
                </div>
                <div className="text-left">
                  <p className="font-medium">온이의 피드백</p>
                  <p className="text-sm text-muted-foreground">AI 운동 코치와 대화하기</p>
                </div>
              </div>
              {showAICoach ? (
                <ChevronUp size={20} className="text-muted-foreground" />
              ) : (
                <ChevronDown size={20} className="text-muted-foreground" />
              )}
            </button>

            <AnimatePresence>
              {showAICoach && (
                <motion.div
                  initial={{ height: 0, opacity: 0 }}
                  animate={{ height: 'auto', opacity: 1 }}
                  exit={{ height: 0, opacity: 0 }}
                  transition={{ duration: 0.3 }}
                  className="overflow-hidden"
                >
                  <div className="px-6 pb-6 space-y-4 border-t border-border pt-4">
                    <div className="flex gap-3 mb-4">
                      <div className="w-8 h-8 bg-primary/10 rounded-full flex items-center justify-center flex-shrink-0">
                        🤖
                      </div>
                      <div className="flex-1 bg-accent rounded-2xl p-4">
                        <p className="text-sm">이번 주 5회 운동으로 목표를 달성했어요! 유산소와 근력 운동의 균형이 좋습니다. 다음 주는 유산소를 조금 더 늘려보는 건 어떨까요? 고혈압 관리에 효과적이에요! 💪</p>
                      </div>
                    </div>

                    <div className="flex gap-2 flex-wrap mb-4">
                      {quickReplies.map((reply, idx) => (
                        <button
                          key={idx}
                          onClick={() => handleSendMessage(reply)}
                          className="px-4 py-2 bg-accent rounded-full text-sm hover:bg-accent/80 transition-colors border border-border"
                        >
                          {reply}
                        </button>
                      ))}
                    </div>

                    <div className="flex gap-2">
                      <input
                        type="text"
                        value={chatMessage}
                        onChange={(e) => setChatMessage(e.target.value)}
                        onKeyDown={(e) => e.key === 'Enter' && handleSendMessage()}
                        placeholder="메시지를 입력하세요..."
                        className="flex-1 px-4 py-3 bg-input-background rounded-xl border border-border outline-none focus:ring-2 focus:ring-primary"
                      />
                      <button
                        onClick={() => handleSendMessage()}
                        className="w-12 h-12 bg-primary text-white rounded-xl flex items-center justify-center hover:bg-primary/90 transition-colors"
                      >
                        ↑
                      </button>
                    </div>
                  </div>
                </motion.div>
              )}
            </AnimatePresence>
          </div>

          <div className="space-y-3 mb-24">
            {workoutHistory.map((workout, index) => (
              <div
                key={index}
                className="bg-card rounded-2xl shadow-sm border border-border p-5"
              >
                <div className="flex items-start justify-between mb-3">
                  <div>
                    <p className="text-sm text-muted-foreground mb-1">{workout.date}</p>
                    <div className="flex items-center gap-2">
                      <Clock size={16} className="text-muted-foreground" />
                      <span className="text-sm text-muted-foreground">{workout.time}</span>
                      <span className="px-2 py-1 bg-primary/10 text-primary text-xs rounded-full">
                        {workout.type}
                      </span>
                    </div>
                  </div>
                  <div className="text-right">
                    <p className="text-sm text-muted-foreground">소모 칼로리</p>
                    <p className="text-lg font-medium text-primary">{workout.calories} kcal</p>
                  </div>
                </div>

                <div className="space-y-1 mb-3">
                  {workout.exercises.map((exercise, i) => (
                    <p key={i} className="text-sm">• {exercise}</p>
                  ))}
                </div>

                <div className="flex items-center gap-2 pt-3 border-t border-border">
                  <Clock size={16} className="text-muted-foreground" />
                  <span className="text-sm text-muted-foreground">{workout.duration}분 운동</span>
                </div>
              </div>
            ))}
          </div>

        </div>
      )}

      {activeView === 'gyms' && (
        <div className="px-4 pt-4 pb-6 space-y-4">
          <button
            onClick={() => setShowGymSearch(true)}
            className="w-full py-3 bg-primary text-white rounded-xl flex items-center justify-center gap-2 hover:bg-primary/90 transition-colors"
          >
            <MapPin size={20} />
            헬스장 찾기
          </button>

          {hasMyGym && (
            <div className="bg-card rounded-2xl shadow-sm border border-border overflow-hidden">
              <div className="bg-gradient-to-br from-primary/10 to-secondary/10 p-4 border-b border-border">
                <div className="flex items-center gap-2 mb-2">
                  <div className="w-8 h-8 bg-primary rounded-full flex items-center justify-center">
                    <MapPin size={16} className="text-white" />
                  </div>
                  <span className="text-sm text-muted-foreground">내 헬스장</span>
                </div>
                <h3 className="text-lg font-medium mb-1">강남 피트니스 센터</h3>
                <div className="flex items-center gap-2 text-sm text-muted-foreground">
                  <MapPin size={14} />
                  <span>서울시 강남구 역삼동 • 0.8km</span>
                </div>
              </div>

              <div className="p-4">
                <div className="flex items-center gap-2 mb-4">
                  <div className="w-10 h-10 bg-accent rounded-full flex items-center justify-center">
                    <span className="text-xl">👤</span>
                  </div>
                  <div>
                    <p className="text-sm font-medium">김트레이너</p>
                    <p className="text-xs text-muted-foreground">전담 트레이너</p>
                  </div>
                </div>

                <div className="flex gap-2 mb-4">
                  <span className="px-3 py-1 bg-accent text-sm rounded-full">다이어트</span>
                  <span className="px-3 py-1 bg-accent text-sm rounded-full">재활운동</span>
                </div>

                <div className="grid grid-cols-2 gap-3">
                  <button
                    onClick={() => setShowGymDetail(0)}
                    className="py-3 bg-accent rounded-xl hover:bg-accent/80 transition-colors text-sm"
                  >
                    헬스장 정보
                  </button>
                  <button
                    onClick={() => setSelectedGym(0)}
                    className="py-3 bg-primary text-white rounded-xl hover:bg-primary/90 transition-colors text-sm flex items-center justify-center gap-2"
                  >
                    <MessageCircle size={16} />
                    1:1 상담
                  </button>
                </div>

                {selectedGym === 0 && (
                  <div className="mt-4 p-4 bg-accent rounded-xl">
                    <div className="flex items-center gap-2 mb-3 text-green-600">
                      <CheckCircle size={18} />
                      <p className="text-sm">건강 데이터 요약본 전송 완료</p>
                    </div>

                    <div className="space-y-2 mb-3 text-sm">
                      <p className="text-muted-foreground">전송된 정보:</p>
                      <p>• 최근 운동 기록 (이번 주 5회)</p>
                      <p>• 선호 운동 유형: 유산소, 근력</p>
                      <p>• 고혈압 위험군 프로필</p>
                    </div>

                    <div className="bg-white rounded-xl p-3 space-y-2 mb-3">
                      <div className="flex items-center gap-2">
                        <div className="w-8 h-8 bg-primary rounded-full flex items-center justify-center text-white text-sm">
                          김
                        </div>
                        <div className="flex-1 bg-accent/50 rounded-xl p-2">
                          <p className="text-sm">자료 잘 받았습니다. 고혈압 관리를 위한 맞춤 운동 프로그램 준비했어요!</p>
                        </div>
                      </div>
                    </div>

                    <div className="flex gap-2">
                      <input
                        type="text"
                        placeholder="메시지 입력..."
                        className="flex-1 px-3 py-2 bg-white rounded-lg text-sm outline-none border border-border focus:ring-2 focus:ring-primary"
                      />
                      <button className="px-4 py-2 bg-primary text-white rounded-lg text-sm hover:bg-primary/90 transition-colors">
                        전송
                      </button>
                    </div>
                  </div>
                )}
              </div>
            </div>
          )}

          {!hasMyGym && (
            <div className="text-center py-12">
              <div className="w-20 h-20 bg-accent rounded-full flex items-center justify-center mx-auto mb-4">
                <MapPin size={40} className="text-muted-foreground" />
              </div>
              <p className="text-lg mb-2">등록된 헬스장이 없어요</p>
              <p className="text-sm text-muted-foreground mb-4">
                근처 헬스장을 찾아보세요
              </p>
              <button
                onClick={() => setShowGymSearch(true)}
                className="px-6 py-3 bg-primary text-white rounded-xl hover:bg-primary/90 transition-colors"
              >
                헬스장 찾기
              </button>
            </div>
          )}
        </div>
      )}

      {activeView === 'history' && !showAddWorkout && !showAICoach && (
        <button
          onClick={() => setShowAddWorkout(true)}
          className="fixed bottom-24 right-6 w-16 h-16 bg-primary rounded-full shadow-lg flex items-center justify-center hover:scale-105 transition-transform z-30"
        >
          <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" className="text-white">
            <line x1="12" y1="5" x2="12" y2="19"></line>
            <line x1="5" y1="12" x2="19" y2="12"></line>
          </svg>
        </button>
      )}

      <AnimatePresence>
        {showGymSearch && (
          <motion.div
            initial={{ y: '100%' }}
            animate={{ y: 0 }}
            exit={{ y: '100%' }}
            transition={{ type: 'spring', damping: 25 }}
            className="fixed inset-0 bg-background z-50 flex flex-col"
          >
            <div className="p-4 border-b border-border flex items-center justify-between">
              <h2>헬스장 찾기</h2>
              <button
                onClick={() => setShowGymSearch(false)}
                className="w-8 h-8 bg-accent rounded-full flex items-center justify-center"
              >
                ✕
              </button>
            </div>

            <div className="h-48 bg-gradient-to-br from-primary to-secondary relative">
              <div className="absolute inset-0 flex items-center justify-center text-white">
                <div className="text-center">
                  <MapPin size={48} className="mx-auto mb-2" />
                  <p>지도 영역</p>
                  <p className="text-sm opacity-80">주변 헬스장 3곳</p>
                </div>
              </div>
            </div>

            <div className="flex-1 overflow-y-auto px-4 pt-4 space-y-3 pb-6">
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

                  <div className="grid grid-cols-2 gap-2">
                    <button
                      onClick={() => setShowGymDetail(index)}
                      className="py-3 bg-accent rounded-xl hover:bg-accent/80 transition-colors text-sm"
                    >
                      상세보기
                    </button>
                    <button
                      onClick={() => handleRegisterGym(index)}
                      className="py-3 bg-primary text-white rounded-xl hover:bg-primary/90 transition-colors text-sm"
                    >
                      등록하기
                    </button>
                  </div>
                </div>
              ))}
            </div>
          </motion.div>
        )}

        {showAddWorkout && (
          <motion.div
            initial={{ y: '100%' }}
            animate={{ y: 0 }}
            exit={{ y: '100%' }}
            transition={{ type: 'spring', damping: 25 }}
            className="fixed inset-0 bg-background z-50 flex flex-col"
          >
            <div className="p-4 border-b border-border flex items-center justify-between">
              <h2>운동 기록 추가</h2>
              <button
                onClick={() => setShowAddWorkout(false)}
                className="w-8 h-8 bg-accent rounded-full flex items-center justify-center"
              >
                ✕
              </button>
            </div>

            <div className="flex-1 overflow-y-auto p-4 space-y-4">
              <div>
                <label className="block text-sm mb-2">운동 유형</label>
                <div className="grid grid-cols-2 gap-2">
                  {['유산소', '근력', '스트레칭', '기타'].map((type) => (
                    <button
                      key={type}
                      className="py-3 bg-accent rounded-xl hover:bg-accent/80 transition-colors"
                    >
                      {type}
                    </button>
                  ))}
                </div>
              </div>

              <div>
                <label className="block text-sm mb-2">운동 시간</label>
                <input
                  type="number"
                  placeholder="분"
                  className="w-full px-4 py-3 bg-input-background rounded-xl border border-border outline-none focus:ring-2 focus:ring-primary"
                />
              </div>

              <div>
                <label className="block text-sm mb-2">운동 내용</label>
                <textarea
                  placeholder="예: 러닝머신 30분, 스쿼트 3세트"
                  rows={4}
                  className="w-full px-4 py-3 bg-input-background rounded-xl border border-border outline-none focus:ring-2 focus:ring-primary resize-none"
                />
              </div>

              <button className="w-full py-4 bg-primary text-white rounded-xl hover:bg-primary/90 transition-colors">
                저장하기
              </button>
            </div>
          </motion.div>
        )}

        {showGymDetail !== null && (
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            className="fixed inset-0 bg-black/50 z-50 flex items-center justify-center"
            onClick={() => setShowGymDetail(null)}
          >
            <motion.div
              initial={{ scale: 0.9, opacity: 0 }}
              animate={{ scale: 1, opacity: 1 }}
              exit={{ scale: 0.9, opacity: 0 }}
              className="bg-background rounded-2xl p-6 w-full max-w-md mx-4"
              onClick={(e) => e.stopPropagation()}
            >
              <div className="flex items-center justify-between mb-4">
                <h3 className="text-lg">{gyms[showGymDetail]?.name || '강남 피트니스 센터'}</h3>
                <button
                  onClick={() => setShowGymDetail(null)}
                  className="w-8 h-8 bg-accent rounded-full flex items-center justify-center"
                >
                  ✕
                </button>
              </div>

              <div className="space-y-4">
                <div className="flex items-center gap-2 text-sm">
                  <MapPin size={16} className="text-muted-foreground" />
                  <span>서울시 강남구 역삼동 123-45</span>
                </div>

                <div className="flex items-center gap-2">
                  <Star size={16} className="fill-yellow-400 text-yellow-400" />
                  <span className="text-sm">평점: {gyms[showGymDetail]?.rating || '4.7'}</span>
                </div>

                <div>
                  <p className="text-sm mb-2">운영 시간</p>
                  <p className="text-sm text-muted-foreground">평일: 06:00 - 23:00</p>
                  <p className="text-sm text-muted-foreground">주말: 08:00 - 20:00</p>
                </div>

                <div>
                  <p className="text-sm mb-2">연락처</p>
                  <p className="text-sm text-muted-foreground">02-1234-5678</p>
                </div>

                <div>
                  <p className="text-sm mb-2">전담 트레이너</p>
                  <p className="text-sm">{gyms[showGymDetail]?.trainer || '김트레이너'}</p>
                </div>

                <div>
                  <p className="text-sm mb-2">전문 분야</p>
                  <div className="flex gap-2">
                    {(gyms[showGymDetail]?.specialties || ['다이어트', '재활운동']).map((specialty, i) => (
                      <span key={i} className="px-3 py-1 bg-accent text-sm rounded-full">
                        {specialty}
                      </span>
                    ))}
                  </div>
                </div>

                <button
                  onClick={() => {
                    setShowGymDetail(null);
                    if (!hasMyGym) {
                      handleRegisterGym(showGymDetail);
                    }
                  }}
                  className="w-full py-3 bg-primary text-white rounded-xl hover:bg-primary/90 transition-colors"
                >
                  {hasMyGym ? '닫기' : '이 헬스장 등록하기'}
                </button>
              </div>
            </motion.div>
          </motion.div>
        )}

        {showCalendar && (
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            className="fixed inset-0 bg-black/50 z-50 flex items-end sm:items-center justify-center"
            onClick={() => setShowCalendar(false)}
          >
            <motion.div
              initial={{ y: '100%', opacity: 0 }}
              animate={{ y: 0, opacity: 1 }}
              exit={{ y: '100%', opacity: 0 }}
              transition={{ type: 'spring', damping: 25 }}
              className="bg-background rounded-t-3xl sm:rounded-2xl w-full sm:max-w-2xl max-h-[80vh] overflow-y-auto"
              onClick={(e) => e.stopPropagation()}
            >
              <div className="sticky top-0 bg-background border-b border-border p-4 flex items-center justify-between rounded-t-3xl sm:rounded-t-2xl">
                <h2 className="text-xl">일정 관리</h2>
                <button
                  onClick={() => setShowCalendar(false)}
                  className="w-8 h-8 bg-accent rounded-full flex items-center justify-center hover:bg-accent/80 transition-colors"
                >
                  <X size={18} />
                </button>
              </div>

              <div className="p-4">
                <div className="flex items-center justify-between mb-4">
                  <h3>2026년 5월</h3>
                  <button className="px-4 py-2 bg-primary text-white rounded-lg text-sm hover:bg-primary/90 transition-colors">
                    일정 추가
                  </button>
                </div>

                <div className="grid grid-cols-7 gap-2 mb-4">
                  {['일', '월', '화', '수', '목', '금', '토'].map((day) => (
                    <div key={day} className="text-center text-sm text-muted-foreground py-2">
                      {day}
                    </div>
                  ))}
                  {(() => {
                    const days = [];
                    const firstDay = new Date(2026, 4, 1);
                    const lastDay = new Date(2026, 4 + 1, 0);
                    for (let i = 0; i < firstDay.getDay(); i++) {
                      days.push(<div key={`empty-${i}`} />);
                    }
                    for (let i = 1; i <= lastDay.getDate(); i++) {
                      const isToday = i === 14;
                      const hasEvent = [10, 14, 18, 20].includes(i);
                      days.push(
                        <button
                          key={i}
                          className={`aspect-square flex flex-col items-center justify-center rounded-lg transition-colors ${
                            isToday
                              ? 'bg-primary text-white'
                              : hasEvent
                              ? 'bg-accent hover:bg-accent/80'
                              : 'hover:bg-accent/50'
                          }`}
                        >
                          <span className="text-sm">{i}</span>
                          {hasEvent && !isToday && (
                            <div className="w-1 h-1 bg-primary rounded-full mt-1" />
                          )}
                        </button>
                      );
                    }
                    return days;
                  })()}
                </div>

                <div className="border-t border-border pt-4">
                  <h4 className="mb-3">5월 14일 일정</h4>
                  <div className="space-y-2">
                    {[
                      { time: '10:00', title: '병원 정기검진', icon: '🏥' },
                      { time: '18:00', title: '헬스장 운동', icon: '💪' }
                    ].map((item, idx) => (
                      <div key={idx} className="flex items-center justify-between p-3 bg-accent rounded-xl">
                        <div className="flex items-center gap-3">
                          <span className="text-xl">{item.icon}</span>
                          <div>
                            <p className="text-sm font-medium">{item.title}</p>
                            <p className="text-xs text-muted-foreground">{item.time}</p>
                          </div>
                        </div>
                        <button className="text-sm text-primary hover:opacity-70">수정</button>
                      </div>
                    ))}
                  </div>
                </div>
              </div>
            </motion.div>
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  );
}
