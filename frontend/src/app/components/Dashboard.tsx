import { useState } from 'react';
import { Flame, Calendar, UtensilsCrossed, Dumbbell, TrendingUp, ChevronRight, Plus, X } from 'lucide-react';
import { Header } from './Header';
import { NotificationPanel } from './NotificationPanel';
import { motion, AnimatePresence } from 'motion/react';

export function Dashboard() {
  const [showCalendar, setShowCalendar] = useState(false);
  const [showQuickInput, setShowQuickInput] = useState(false);
  const [inputType, setInputType] = useState<'weight' | 'bloodPressure' | 'bloodSugar' | null>(null);
  const [showNotifications, setShowNotifications] = useState(false);

  const healthData = [
    { label: '칼로리', current: 1170, max: 2000, unit: 'kcal', warning: false },
    { label: '나트륨', current: 2100, max: 2000, unit: 'mg', warning: true },
    { label: '당류', current: 45, max: 50, unit: 'g', warning: false },
    { label: '혈당', current: 95, max: 120, unit: 'mg/dL', warning: false },
  ];

  const todaySchedule = [
    { time: '10:00', title: '병원 정기검진', icon: '🏥', type: 'hospital' },
    { time: '18:00', title: '헬스장 운동', icon: '💪', type: 'exercise' },
  ];

  const quickStats = [
    { label: '식단 기록', value: '2', unit: '회', icon: UtensilsCrossed },
    { label: '운동 시간', value: '45', unit: '분', icon: Dumbbell },
  ];

  const weekDays = ['일', '월', '화', '수', '목', '금', '토'];

  const getCalendarDays = () => {
    const year = 2026;
    const month = 4; // May
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

  const calendarDays = getCalendarDays();

  const handleQuickInput = (type: 'weight' | 'bloodPressure' | 'bloodSugar') => {
    setInputType(type);
    setShowQuickInput(true);
  };

  return (
    <div className="pb-20 bg-background min-h-screen">
      <Header
        title="홈"
        onNotificationClick={() => setShowNotifications(true)}
        onCalendarClick={() => setShowCalendar(true)}
      />

      <NotificationPanel
        isOpen={showNotifications}
        onClose={() => setShowNotifications(false)}
        onNavigate={(path) => {
          // Navigation logic would go here
          console.log('Navigate to:', path);
        }}
      />

      <div className="px-4 pt-6 space-y-6 max-w-2xl mx-auto">
        <div>
          <h2 className="text-xl mb-1">안녕하세요, 김민수님</h2>
          <p className="text-muted-foreground">오늘도 건강한 하루 되세요 ☀️</p>
        </div>

        <div className="bg-gradient-to-br from-primary to-secondary rounded-2xl shadow-sm p-6 text-white">
          <div className="flex items-center justify-between mb-4">
            <div className="flex items-center gap-3">
              <Flame size={28} />
              <div>
                <p className="text-sm opacity-90">현재 스트릭</p>
                <p className="text-3xl font-medium">3일</p>
              </div>
            </div>
            <div className="text-right">
              <p className="text-sm opacity-90">목표까지</p>
              <p className="text-2xl font-medium">4일</p>
            </div>
          </div>
          <div className="h-2 bg-white/20 rounded-full overflow-hidden mb-4">
            <div className="h-full bg-white rounded-full" style={{ width: '43%' }} />
          </div>

          <div className="border-t border-white/20 pt-4 mt-2">
            <p className="text-sm opacity-90 mb-3">오늘의 건강 기록</p>
            <div className="grid grid-cols-3 gap-2">
              <button
                onClick={() => handleQuickInput('weight')}
                className="bg-white/20 hover:bg-white/30 rounded-xl p-3 text-center transition-colors backdrop-blur-sm"
              >
                <div className="text-2xl mb-1">⚖️</div>
                <p className="text-xs opacity-90">체중</p>
              </button>
              <button
                onClick={() => handleQuickInput('bloodPressure')}
                className="bg-white/20 hover:bg-white/30 rounded-xl p-3 text-center transition-colors backdrop-blur-sm"
              >
                <div className="text-2xl mb-1">❤️</div>
                <p className="text-xs opacity-90">혈압</p>
              </button>
              <button
                onClick={() => handleQuickInput('bloodSugar')}
                className="bg-white/20 hover:bg-white/30 rounded-xl p-3 text-center transition-colors backdrop-blur-sm"
              >
                <div className="text-2xl mb-1">💉</div>
                <p className="text-xs opacity-90">혈당</p>
              </button>
            </div>
          </div>
        </div>

        <div className="bg-card rounded-2xl shadow-sm border border-border p-6">
          <h2 className="text-lg mb-4">오늘의 건강 요약</h2>

          <div className="space-y-4">
            {healthData.map((item) => {
              const percentage = (item.current / item.max) * 100;
              const isWarning = item.warning === true;

              return (
                <div key={item.label}>
                  <div className="flex justify-between items-center mb-2">
                    <span className="text-sm">{item.label}</span>
                    <span className={`text-sm font-medium ${isWarning ? 'text-warning' : 'text-foreground'}`}>
                      {item.current} / {item.max} {item.unit}
                    </span>
                  </div>
                  <div className="relative h-2.5 w-full overflow-hidden rounded-full bg-muted">
                    <div
                      className={`h-full transition-all rounded-full ${
                        isWarning ? 'bg-warning' : 'bg-primary'
                      }`}
                      style={{ width: `${Math.min(percentage, 100)}%` }}
                    />
                  </div>
                </div>
              );
            })}
          </div>

          <div className="grid grid-cols-2 gap-3 mt-4 pt-4 border-t border-border">
            {quickStats.map((stat, idx) => {
              const Icon = stat.icon;
              return (
                <div key={idx} className="flex items-center gap-3 p-3 bg-accent rounded-xl">
                  <Icon size={20} className="text-primary" />
                  <div>
                    <p className="text-xs text-muted-foreground">{stat.label}</p>
                    <p className="text-lg font-medium">
                      {stat.value}
                      <span className="text-sm text-muted-foreground ml-1">{stat.unit}</span>
                    </p>
                  </div>
                </div>
              );
            })}
          </div>
        </div>

        <div className="bg-card rounded-2xl shadow-sm border border-border p-6">
          <div className="flex items-center justify-between mb-4">
            <div className="flex items-center gap-2">
              <Calendar size={20} className="text-primary" />
              <h2 className="text-lg">오늘의 일정</h2>
            </div>
            <button
              onClick={() => setShowCalendar(true)}
              className="text-sm text-primary flex items-center gap-1 hover:opacity-70 transition-opacity"
            >
              전체보기
              <ChevronRight size={16} />
            </button>
          </div>

          <div className="space-y-3">
            {todaySchedule.map((item, index) => (
              <div
                key={index}
                className="flex items-center gap-4 p-4 rounded-xl bg-accent hover:bg-accent/80 transition-colors cursor-pointer"
              >
                <div className="flex items-center justify-center w-12 h-12 bg-white rounded-xl text-2xl">
                  {item.icon}
                </div>
                <div className="flex-1">
                  <p className="font-medium mb-1">{item.title}</p>
                  <p className="text-sm text-muted-foreground">{item.time}</p>
                </div>
                <ChevronRight size={20} className="text-muted-foreground" />
              </div>
            ))}
          </div>
        </div>

        <div className="bg-gradient-to-br from-green-500 to-emerald-600 rounded-2xl shadow-sm p-6 text-white">
          <div className="flex items-center gap-3 mb-3">
            <TrendingUp size={24} />
            <div>
              <p className="text-sm opacity-90">이번 주 건강 점수</p>
              <p className="text-3xl font-medium">85점</p>
            </div>
          </div>
          <p className="text-sm opacity-90">
            지난 주보다 12점 상승했어요! 🎉
          </p>
        </div>
      </div>

      <AnimatePresence>
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
                    {todaySchedule.map((item, idx) => (
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

        {showQuickInput && inputType && (
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            className="fixed inset-0 bg-black/50 z-50 flex items-center justify-center"
            onClick={() => setShowQuickInput(false)}
          >
            <motion.div
              initial={{ scale: 0.9, opacity: 0 }}
              animate={{ scale: 1, opacity: 1 }}
              exit={{ scale: 0.9, opacity: 0 }}
              className="bg-background rounded-2xl p-6 w-full max-w-sm mx-4"
              onClick={(e) => e.stopPropagation()}
            >
              <div className="flex items-center justify-between mb-4">
                <h3 className="text-lg">
                  {inputType === 'weight' && '체중 입력'}
                  {inputType === 'bloodPressure' && '혈압 입력'}
                  {inputType === 'bloodSugar' && '혈당 입력'}
                </h3>
                <button
                  onClick={() => setShowQuickInput(false)}
                  className="w-8 h-8 bg-accent rounded-full flex items-center justify-center"
                >
                  <X size={18} />
                </button>
              </div>

              {inputType === 'weight' && (
                <div className="space-y-4">
                  <div>
                    <label className="block text-sm mb-2">체중 (kg)</label>
                    <input
                      type="number"
                      placeholder="72.0"
                      className="w-full px-4 py-3 bg-input-background rounded-xl border border-border outline-none focus:ring-2 focus:ring-primary"
                    />
                  </div>
                </div>
              )}

              {inputType === 'bloodPressure' && (
                <div className="space-y-4">
                  <div>
                    <label className="block text-sm mb-2">수축기 (mmHg)</label>
                    <input
                      type="number"
                      placeholder="120"
                      className="w-full px-4 py-3 bg-input-background rounded-xl border border-border outline-none focus:ring-2 focus:ring-primary"
                    />
                  </div>
                  <div>
                    <label className="block text-sm mb-2">이완기 (mmHg)</label>
                    <input
                      type="number"
                      placeholder="80"
                      className="w-full px-4 py-3 bg-input-background rounded-xl border border-border outline-none focus:ring-2 focus:ring-primary"
                    />
                  </div>
                </div>
              )}

              {inputType === 'bloodSugar' && (
                <div className="space-y-4">
                  <div>
                    <label className="block text-sm mb-2">혈당 (mg/dL)</label>
                    <input
                      type="number"
                      placeholder="95"
                      className="w-full px-4 py-3 bg-input-background rounded-xl border border-border outline-none focus:ring-2 focus:ring-primary"
                    />
                  </div>
                </div>
              )}

              <button className="w-full py-3 bg-primary text-white rounded-xl mt-4 hover:bg-primary/90 transition-colors">
                저장하기
              </button>
            </motion.div>
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  );
}
