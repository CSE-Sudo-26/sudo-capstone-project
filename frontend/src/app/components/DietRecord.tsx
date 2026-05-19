import { useState } from 'react';
import { Camera, Clock, AlertCircle, Check, ChevronDown, ChevronLeft, ChevronRight, ChevronUp, X } from 'lucide-react';
import { motion, AnimatePresence } from 'motion/react';
import { Header } from './Header';
import { NotificationPanel } from './NotificationPanel';

export function DietRecord() {
  const [showCamera, setShowCamera] = useState(false);
  const [scanning, setScanning] = useState(false);
  const [showCalendar, setShowCalendar] = useState(false);
  const [showFullCalendar, setShowFullCalendar] = useState(false);
  const [selectedDate, setSelectedDate] = useState(new Date(2026, 4, 14)); // May 14, 2026
  const [showAICoach, setShowAICoach] = useState(false);
  const [chatMessage, setChatMessage] = useState('');
  const [showAddMeal, setShowAddMeal] = useState(false);
  const [showNotifications, setShowNotifications] = useState(false);
  const [showManualEdit, setShowManualEdit] = useState(false);
  const [analyzedFood, setAnalyzedFood] = useState({
    name: '비빔밥',
    calories: 650,
    sodium: 1200,
    sugar: 25
  });

  const weekDays = ['일', '월', '화', '수', '목', '금', '토'];

  const getWeekDates = () => {
    const dates = [];
    const today = new Date(selectedDate);
    const currentDay = today.getDay();

    for (let i = 0; i < 7; i++) {
      const date = new Date(today);
      date.setDate(today.getDate() - currentDay + i);
      dates.push(date);
    }
    return dates;
  };

  const getCalendarDays = () => {
    const year = selectedDate.getFullYear();
    const month = selectedDate.getMonth();
    const firstDay = new Date(year, month, 1);
    const lastDay = new Date(year, month + 1, 0);
    const days = [];

    for (let i = 0; i < firstDay.getDay(); i++) {
      days.push(null);
    }

    for (let i = 1; i <= lastDay.getDate(); i++) {
      days.push(new Date(year, month, i));
    }

    return days;
  };

  const formatDate = (date: Date) => {
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    const dayName = weekDays[date.getDay()];
    return `${month}. ${day}. (${dayName})`;
  };

  const mealRecords = [
    {
      time: '08:30',
      name: '아침',
      items: ['토스트', '계란후라이', '샐러드'],
      calories: 450,
      sodium: 680,
      sugar: 12,
      warning: false,
      image: '🥗'
    },
    {
      time: '13:00',
      name: '점심',
      items: ['김치찌개', '공기밥', '반찬 3가지'],
      calories: 720,
      sodium: 1420,
      sugar: 33,
      warning: true,
      image: '🍲'
    },
  ];

  const handleCameraClick = () => {
    setShowCamera(true);
    setScanning(true);
    setTimeout(() => setScanning(false), 2000);
  };

  const handleSendMessage = (message?: string) => {
    const text = message || chatMessage;
    if (!text.trim()) return;
    setChatMessage('');
  };

  const quickReplies = [
    '간식 추천해줘',
    '오늘 나트륨 괜찮아?',
    '저녁 메뉴 추천',
  ];

  const weekDates = getWeekDates();
  const calendarDays = getCalendarDays();

  return (
    <div className="pb-20 bg-background min-h-screen">
      <Header
        title="식단"
        onNotificationClick={() => setShowNotifications(true)}
        onCalendarClick={() => setShowFullCalendar(true)}
      />

      <NotificationPanel
        isOpen={showNotifications}
        onClose={() => setShowNotifications(false)}
        onNavigate={(path) => console.log('Navigate to:', path)}
      />

      <div className="sticky top-[73px] bg-background z-10 border-b border-border">
        <div className="px-4 py-4">
          <div className="flex items-center justify-between mb-3">
            <button
              onClick={() => setShowCalendar(!showCalendar)}
              className="flex items-center gap-2 hover:opacity-70 transition-opacity"
            >
              <h2 className="text-lg">{formatDate(selectedDate)}</h2>
              {showCalendar ? (
                <ChevronUp className="w-4 h-4" />
              ) : (
                <ChevronDown className="w-4 h-4" />
              )}
            </button>
          </div>

          {!showCalendar && (
            <>
              <div className="flex items-center gap-2 overflow-x-auto hide-scrollbar -mx-4 px-4">
                <button
                  onClick={() => {
                    const newDate = new Date(selectedDate);
                    newDate.setDate(selectedDate.getDate() - 7);
                    setSelectedDate(newDate);
                  }}
                  className="p-2 hover:bg-accent rounded-lg flex-shrink-0"
                >
                  <ChevronLeft className="w-4 h-4" />
                </button>
                <div className="flex gap-2">
                  {weekDates.map((date, idx) => {
                    const isSelected = date.toDateString() === selectedDate.toDateString();
                    const isToday = date.toDateString() === new Date(2026, 4, 14).toDateString();
                    return (
                      <button
                        key={idx}
                        onClick={() => setSelectedDate(date)}
                        className={`flex flex-col items-center gap-1 min-w-[44px] p-2 rounded-xl transition-colors flex-shrink-0 ${
                          isSelected
                            ? 'bg-primary text-white'
                            : 'hover:bg-accent'
                        }`}
                      >
                        <span className="text-xs opacity-80">{weekDays[date.getDay()]}</span>
                        <span className="text-sm font-medium">{date.getDate()}</span>
                        {isToday && !isSelected && (
                          <div className="w-1 h-1 bg-primary rounded-full" />
                        )}
                      </button>
                    );
                  })}
                </div>
                <button
                  onClick={() => {
                    const newDate = new Date(selectedDate);
                    newDate.setDate(selectedDate.getDate() + 7);
                    setSelectedDate(newDate);
                  }}
                  className="p-2 hover:bg-accent rounded-lg flex-shrink-0"
                >
                  <ChevronRight className="w-4 h-4" />
                </button>
              </div>

              <style>{`
                .hide-scrollbar::-webkit-scrollbar {
                  display: none;
                }
                .hide-scrollbar {
                  -ms-overflow-style: none;
                  scrollbar-width: none;
                }
              `}</style>
            </>
          )}

        <AnimatePresence>
          {showCalendar && (
            <motion.div
              initial={{ height: 0, opacity: 0 }}
              animate={{ height: 'auto', opacity: 1 }}
              exit={{ height: 0, opacity: 0 }}
              className="overflow-hidden border-t border-border"
            >
              <div className="p-4">
                <div className="flex items-center justify-between mb-4">
                  <h3>{selectedDate.getFullYear()}년 {selectedDate.getMonth() + 1}월</h3>
                  <div className="flex gap-2">
                    <button
                      onClick={() => {
                        const newDate = new Date(selectedDate);
                        newDate.setMonth(newDate.getMonth() - 1);
                        setSelectedDate(newDate);
                      }}
                      className="p-1 hover:bg-accent rounded"
                    >
                      <ChevronLeft className="w-4 h-4" />
                    </button>
                    <button
                      onClick={() => {
                        const newDate = new Date(selectedDate);
                        newDate.setMonth(newDate.getMonth() + 1);
                        setSelectedDate(newDate);
                      }}
                      className="p-1 hover:bg-accent rounded"
                    >
                      <ChevronRight className="w-4 h-4" />
                    </button>
                  </div>
                </div>

                <div className="grid grid-cols-7 gap-2">
                  {weekDays.map((day) => (
                    <div key={day} className="text-center text-sm text-muted-foreground py-2">
                      {day}
                    </div>
                  ))}
                  {calendarDays.map((day, idx) => {
                    if (!day) return <div key={idx} />;
                    const isSelected = day.toDateString() === selectedDate.toDateString();
                    const hasRecord = day.getDate() <= 14; // Mock: records for days 1-14
                    return (
                      <button
                        key={idx}
                        onClick={() => {
                          setSelectedDate(day);
                          setShowCalendar(false);
                        }}
                        className={`aspect-square flex flex-col items-center justify-center rounded-lg transition-colors ${
                          isSelected
                            ? 'bg-primary text-white'
                            : hasRecord
                            ? 'bg-accent hover:bg-accent/80'
                            : 'hover:bg-accent/50'
                        }`}
                      >
                        <span className="text-sm">{day.getDate()}</span>
                        {hasRecord && !isSelected && (
                          <div className="w-1 h-1 bg-primary rounded-full mt-1" />
                        )}
                      </button>
                    );
                  })}
                </div>
              </div>
            </motion.div>
          )}
        </AnimatePresence>
        </div>
      </div>

      <div className="px-4 pt-4 space-y-4 mb-24">
        <div className="bg-accent/50 rounded-xl p-3 border border-primary/20">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm text-muted-foreground mb-1">오늘 섭취량</p>
              <div className="grid grid-cols-2 gap-2 text-sm">
                <span>칼로리: <strong>1,170</strong>/2,000</span>
                <span className="text-warning">나트륨: <strong>2,100</strong>/2,000mg</span>
                <span>당류: <strong>45</strong>/50g</span>
              </div>
            </div>
          </div>
        </div>

        <div className="bg-card rounded-2xl shadow-sm border border-border">
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
                <p className="text-sm text-muted-foreground">AI 식단 코치와 대화하기</p>
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
                      <p className="text-sm">오늘 나트륨 섭취가 권장량을 초과했어요. 저녁에는 국물 대신 담백한 구이나 샐러드 어떠세요? 😊</p>
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

        {mealRecords.map((meal, index) => (
          <div
            key={index}
            className="bg-card rounded-2xl shadow-sm border border-border p-5"
          >
            <div className="flex gap-4">
              <div className="text-4xl">{meal.image}</div>
              <div className="flex-1">
                <div className="flex items-start justify-between mb-2">
                  <div className="flex items-center gap-3">
                    <Clock size={16} className="text-muted-foreground" />
                    <div>
                      <p className="text-sm text-muted-foreground">{meal.time}</p>
                      <p className="font-medium">{meal.name}</p>
                    </div>
                  </div>
                  {meal.warning && (
                    <div className="flex items-center gap-1 bg-warning/10 text-warning px-3 py-1 rounded-full">
                      <AlertCircle size={14} />
                      <span className="text-xs">나트륨 주의</span>
                    </div>
                  )}
                </div>

                <div className="space-y-1 mb-3">
                  {meal.items.map((item, i) => (
                    <p key={i} className="text-sm text-muted-foreground">• {item}</p>
                  ))}
                </div>

                <div className="flex gap-4 pt-3 border-t border-border text-sm">
                  <span>{meal.calories}kcal</span>
                  <span className={meal.warning ? 'text-warning' : ''}>
                    나트륨 {meal.sodium}mg
                  </span>
                  <span>당류 {meal.sugar}g</span>
                </div>
              </div>
            </div>
          </div>
        ))}
      </div>

      {!showAddMeal && !showCamera && (
        <button
          onClick={handleCameraClick}
          className="fixed bottom-24 right-6 w-16 h-16 bg-primary rounded-full shadow-lg flex items-center justify-center hover:scale-105 transition-transform z-30"
        >
          <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" className="text-white">
            <line x1="12" y1="5" x2="12" y2="19"></line>
            <line x1="5" y1="12" x2="19" y2="12"></line>
          </svg>
        </button>
      )}

      <AnimatePresence>
        {showCamera && (
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            className="fixed inset-0 bg-black z-50"
            onClick={() => !scanning && setShowCamera(false)}
          >
            <div className="relative w-full h-full flex items-center justify-center">
              {scanning ? (
                <div className="text-center">
                  <motion.div
                    animate={{ rotate: 360 }}
                    transition={{ duration: 1, repeat: Infinity, ease: 'linear' }}
                    className="w-16 h-16 border-4 border-t-primary border-white/30 rounded-full mx-auto mb-4"
                  />
                  <p className="text-white">음식을 분석하고 있어요...</p>
                  <p className="text-white/70 text-sm mt-2">YOLOv8 & Gemini AI 작동 중</p>
                </div>
              ) : (
                <div className="absolute bottom-8 left-0 right-0 bg-white rounded-t-3xl p-6 max-w-2xl mx-auto">
                  <div className="flex items-center gap-2 mb-4">
                    <Check className="text-green-500" size={24} />
                    <h3 className="text-lg">분석 완료</h3>
                  </div>

                  <div className="space-y-3 mb-4">
                    <p><span className="text-muted-foreground">음식:</span> {analyzedFood.name}</p>
                    <p><span className="text-muted-foreground">칼로리:</span> {analyzedFood.calories}kcal</p>
                    <p><span className="text-muted-foreground">나트륨:</span> <span className="text-warning">{analyzedFood.sodium}mg</span></p>
                    <p><span className="text-muted-foreground">당류:</span> {analyzedFood.sugar}g</p>
                    <div className="bg-warning/10 text-warning p-3 rounded-xl flex items-start gap-2">
                      <AlertCircle size={18} className="mt-0.5" />
                      <p className="text-sm">나트륨 함량이 높아요. 국물은 남기는 것을 추천해요.</p>
                    </div>
                  </div>

                  <div className="flex gap-3">
                    <button
                      onClick={() => setShowManualEdit(true)}
                      className="flex-1 py-3 bg-muted rounded-xl hover:bg-muted/80 transition-colors"
                    >
                      수동 보정
                    </button>
                    <button
                      onClick={() => setShowCamera(false)}
                      className="flex-1 py-3 bg-primary text-white rounded-xl hover:bg-primary/90 transition-colors"
                    >
                      저장하기
                    </button>
                  </div>
                </div>
              )}
            </div>
          </motion.div>
        )}

        {showAddMeal && (
          <motion.div
            initial={{ y: '100%' }}
            animate={{ y: 0 }}
            exit={{ y: '100%' }}
            transition={{ type: 'spring', damping: 25 }}
            className="fixed inset-0 bg-background z-50 flex flex-col"
          >
            <div className="p-4 border-b border-border flex items-center justify-between">
              <h2>식단 추가</h2>
              <button
                onClick={() => setShowAddMeal(false)}
                className="w-8 h-8 bg-accent rounded-full flex items-center justify-center"
              >
                ✕
              </button>
            </div>

            <div className="flex-1 overflow-y-auto p-4 space-y-4">
              <div className="text-center py-12">
                <button
                  onClick={() => {
                    setShowAddMeal(false);
                    handleCameraClick();
                  }}
                  className="w-32 h-32 bg-primary/10 rounded-full flex items-center justify-center mx-auto mb-4 hover:bg-primary/20 transition-colors"
                >
                  <Camera size={48} className="text-primary" />
                </button>
                <p className="text-lg mb-2">사진으로 식단 기록</p>
                <p className="text-sm text-muted-foreground">음식 사진을 찍어 자동으로 분석해요</p>
              </div>

              <div className="relative">
                <div className="absolute inset-0 flex items-center">
                  <div className="w-full border-t border-border" />
                </div>
                <div className="relative flex justify-center">
                  <span className="bg-background px-4 text-sm text-muted-foreground">또는</span>
                </div>
              </div>

              <div className="space-y-4">
                <div>
                  <label className="block text-sm mb-2">식사 시간</label>
                  <select className="w-full px-4 py-3 bg-input-background rounded-xl border border-border outline-none focus:ring-2 focus:ring-primary">
                    <option>아침</option>
                    <option>점심</option>
                    <option>저녁</option>
                    <option>간식</option>
                  </select>
                </div>

                <div>
                  <label className="block text-sm mb-2">음식명</label>
                  <input
                    type="text"
                    placeholder="예: 김치찌개"
                    className="w-full px-4 py-3 bg-input-background rounded-xl border border-border outline-none focus:ring-2 focus:ring-primary"
                  />
                </div>

                <button className="w-full py-4 bg-primary text-white rounded-xl hover:bg-primary/90 transition-colors">
                  수동으로 추가하기
                </button>
              </div>
            </div>
          </motion.div>
        )}

        {showManualEdit && (
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            className="fixed inset-0 bg-black/50 z-[60] flex items-center justify-center"
            onClick={() => setShowManualEdit(false)}
          >
            <motion.div
              initial={{ scale: 0.9, opacity: 0 }}
              animate={{ scale: 1, opacity: 1 }}
              exit={{ scale: 0.9, opacity: 0 }}
              className="bg-background rounded-2xl p-6 w-full max-w-md mx-4"
              onClick={(e) => e.stopPropagation()}
            >
              <div className="flex items-center justify-between mb-4">
                <h3 className="text-lg">음식 정보 수정</h3>
                <button
                  onClick={() => setShowManualEdit(false)}
                  className="w-8 h-8 bg-accent rounded-full flex items-center justify-center"
                >
                  <X size={18} />
                </button>
              </div>

              <div className="space-y-4">
                <div>
                  <label className="block text-sm mb-2">음식명</label>
                  <input
                    type="text"
                    value={analyzedFood.name}
                    onChange={(e) => setAnalyzedFood({ ...analyzedFood, name: e.target.value })}
                    className="w-full px-4 py-3 bg-input-background rounded-xl border border-border outline-none focus:ring-2 focus:ring-primary"
                  />
                </div>

                <div>
                  <label className="block text-sm mb-2">칼로리 (kcal)</label>
                  <input
                    type="number"
                    value={analyzedFood.calories}
                    onChange={(e) => setAnalyzedFood({ ...analyzedFood, calories: parseInt(e.target.value) || 0 })}
                    className="w-full px-4 py-3 bg-input-background rounded-xl border border-border outline-none focus:ring-2 focus:ring-primary"
                  />
                </div>

                <div>
                  <label className="block text-sm mb-2">나트륨 (mg)</label>
                  <input
                    type="number"
                    value={analyzedFood.sodium}
                    onChange={(e) => setAnalyzedFood({ ...analyzedFood, sodium: parseInt(e.target.value) || 0 })}
                    className="w-full px-4 py-3 bg-input-background rounded-xl border border-border outline-none focus:ring-2 focus:ring-primary"
                  />
                </div>

                <div>
                  <label className="block text-sm mb-2">당류 (g)</label>
                  <input
                    type="number"
                    value={analyzedFood.sugar}
                    onChange={(e) => setAnalyzedFood({ ...analyzedFood, sugar: parseInt(e.target.value) || 0 })}
                    className="w-full px-4 py-3 bg-input-background rounded-xl border border-border outline-none focus:ring-2 focus:ring-primary"
                  />
                </div>

                <button
                  onClick={() => setShowManualEdit(false)}
                  className="w-full py-3 bg-primary text-white rounded-xl hover:bg-primary/90 transition-colors"
                >
                  수정 완료
                </button>
              </div>
            </motion.div>
          </motion.div>
        )}

        {showFullCalendar && (
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            className="fixed inset-0 bg-black/50 z-50 flex items-end sm:items-center justify-center"
            onClick={() => setShowFullCalendar(false)}
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
                  onClick={() => setShowFullCalendar(false)}
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
                  {weekDays.map((day) => (
                    <div key={day} className="text-center text-sm text-muted-foreground py-2">
                      {day}
                    </div>
                  ))}
                  {calendarDays.map((day, idx) => {
                    if (!day) return <div key={idx} />;
                    const isToday = day.getDate() === 14;
                    const hasEvent = [10, 14, 18, 20].includes(day.getDate());
                    return (
                      <button
                        key={idx}
                        className={`aspect-square flex flex-col items-center justify-center rounded-lg transition-colors ${
                          isToday
                            ? 'bg-primary text-white'
                            : hasEvent
                            ? 'bg-accent hover:bg-accent/80'
                            : 'hover:bg-accent/50'
                        }`}
                      >
                        <span className="text-sm">{day.getDate()}</span>
                        {hasEvent && !isToday && (
                          <div className="w-1 h-1 bg-primary rounded-full mt-1" />
                        )}
                      </button>
                    );
                  })}
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
