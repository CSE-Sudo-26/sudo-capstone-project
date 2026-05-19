import { useState } from 'react';
import { TrendingDown, TrendingUp, Award, ChevronRight, Activity, Scale, Heart, Droplet, X } from 'lucide-react';
import { Header } from './Header';
import { NotificationPanel } from './NotificationPanel';
import { motion, AnimatePresence } from 'motion/react';
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer } from 'recharts';

export function MyHealth() {
  const [showNotifications, setShowNotifications] = useState(false);
  const [showCalendar, setShowCalendar] = useState(false);
  const [showMetricDetail, setShowMetricDetail] = useState<number | null>(null);
  const healthMetrics = [
    {
      title: '체중 변화',
      icon: Scale,
      iconColor: 'text-blue-500',
      data: [
        { value: 78, status: 'high' },
        { value: 76, status: 'medium' },
        { value: 75, status: 'medium' },
        { value: 73, status: 'good' },
        { value: 72, status: 'good' }
      ],
      trend: 'down',
      trendValue: '-6kg',
      unit: 'kg'
    },
    {
      title: '혈압 변화',
      icon: Heart,
      iconColor: 'text-red-500',
      data: [
        { value: 138, status: 'high' },
        { value: 135, status: 'high' },
        { value: 132, status: 'medium' },
        { value: 128, status: 'medium' },
        { value: 125, status: 'good' }
      ],
      trend: 'down',
      trendValue: '-13',
      unit: 'mmHg'
    },
    {
      title: '혈당 변화',
      icon: Droplet,
      iconColor: 'text-orange-500',
      data: [
        { value: 118, status: 'high' },
        { value: 112, status: 'medium' },
        { value: 108, status: 'medium' },
        { value: 102, status: 'good' },
        { value: 98, status: 'good' }
      ],
      trend: 'down',
      trendValue: '-20',
      unit: 'mg/dL'
    }
  ];

  const getStatusColor = (status: string) => {
    switch (status) {
      case 'high':
        return '#ef4444';
      case 'medium':
        return '#f97316';
      case 'good':
        return '#22c55e';
      default:
        return '#6b7280';
    }
  };

  const renderMiniLineChart = (data: Array<{ value: number; status: string }>) => {
    const maxValue = Math.max(...data.map(d => d.value));
    const minValue = Math.min(...data.map(d => d.value));
    const range = maxValue - minValue || 1;
    const width = 120;
    const height = 40;
    const padding = 8;

    const points = data.map((d, i) => ({
      x: padding + (i / (data.length - 1)) * (width - padding * 2),
      y: height - padding - ((d.value - minValue) / range) * (height - padding * 2),
      value: d.value,
      status: d.status
    }));

    const pathD = points.map((p, i) =>
      `${i === 0 ? 'M' : 'L'} ${p.x} ${p.y}`
    ).join(' ');

    return (
      <svg width={width} height={height} className="flex-shrink-0">
        <path
          d={pathD}
          fill="none"
          stroke="#9ca3af"
          strokeWidth="2"
          strokeLinecap="round"
          strokeLinejoin="round"
        />
        {points.map((p, i) => (
          <g key={i}>
            <circle
              cx={p.x}
              cy={p.y}
              r="4"
              fill={getStatusColor(data[i].status)}
              stroke="white"
              strokeWidth="2"
            />
            <text
              x={p.x}
              y={p.y - 10}
              textAnchor="middle"
              fontSize="9"
              fill="#6b7280"
              fontWeight="500"
            >
              {p.value}
            </text>
          </g>
        ))}
      </svg>
    );
  };

  const handleMetricClick = (index: number) => {
    setShowMetricDetail(index);
  };

  const getDetailChartData = (metricIndex: number) => {
    const metric = healthMetrics[metricIndex];
    return metric.data.map((d, i) => ({
      date: i === metric.data.length - 1 ? '오늘' : `${metric.data.length - i}일전`,
      value: d.value,
      status: d.status
    }));
  };

  return (
    <div className="pb-20 bg-background min-h-screen">
      <Header
        title="My"
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

      <div className="px-4 pt-6 max-w-2xl mx-auto space-y-6">
        <div className="flex items-center justify-between mb-2">
          <div>
            <h1 className="text-2xl mb-1">김민수님</h1>
            <p className="text-sm text-muted-foreground">minsu@oncare.com</p>
          </div>
          <div className="w-16 h-16 bg-gradient-to-br from-primary to-secondary rounded-full flex items-center justify-center text-white text-2xl shadow-lg">
            김
          </div>
        </div>

        <div className="bg-gradient-to-br from-orange-500 to-red-500 rounded-2xl p-6 text-white">
          <div className="flex items-center justify-between mb-2">
            <span className="text-sm opacity-90">만성질환 위험군</span>
            <Activity size={20} />
          </div>
          <p className="text-2xl mb-1">고혈압 주의</p>
          <p className="text-sm opacity-90">꾸준한 관리로 건강을 지키고 있어요</p>
        </div>

        <div className="bg-card rounded-2xl shadow-sm border border-border overflow-hidden">
          <div className="p-4 border-b border-border">
            <h2 className="text-lg">건강 지표</h2>
          </div>

          {healthMetrics.map((metric, index) => {
            const Icon = metric.icon;
            const TrendIcon = metric.trend === 'down' ? TrendingDown : TrendingUp;
            const trendColor = metric.trend === 'down' ? 'text-green-600' : 'text-red-600';

            return (
              <button
                key={index}
                onClick={() => handleMetricClick(index)}
                className="w-full p-4 border-b border-border last:border-b-0 hover:bg-accent/50 transition-colors cursor-pointer text-left"
              >
                <div className="flex items-center gap-4">
                  <div className={`flex items-center justify-center w-10 h-10 bg-accent rounded-full ${metric.iconColor}`}>
                    <Icon size={20} />
                  </div>

                  <div className="flex-1 min-w-0">
                    <p className="font-medium mb-1">{metric.title}</p>
                    <div className={`flex items-center gap-1 text-sm ${trendColor}`}>
                      <TrendIcon size={14} />
                      <span>{metric.trendValue}</span>
                    </div>
                  </div>

                  <div className="flex items-center gap-3">
                    {renderMiniLineChart(metric.data)}
                    <ChevronRight size={20} className="text-muted-foreground flex-shrink-0" />
                  </div>
                </div>
              </button>
            );
          })}
        </div>

        <div className="bg-card rounded-2xl shadow-sm border border-border p-6">
          <div className="flex items-center justify-between mb-4">
            <div className="flex items-center gap-2">
              <Award size={20} className="text-yellow-500" />
              <h2 className="text-lg">활동 포인트</h2>
            </div>
            <p className="text-2xl text-primary">1,240P</p>
          </div>
          <button className="w-full py-3 bg-primary text-white rounded-xl flex items-center justify-center gap-2 hover:bg-primary/90 transition-colors">
            포인트 랭킹 바로가기
            <ChevronRight size={18} />
          </button>
        </div>

        <div className="bg-card rounded-2xl shadow-sm border border-border overflow-hidden">
          {[
            { label: '개인정보 관리', icon: '👤' },
            { label: '건강 데이터 설정', icon: '📊' },
            { label: '알림 설정', icon: '🔔' },
            { label: '고객 지원', icon: '💬' },
          ].map((item, index) => (
            <button
              key={index}
              className="w-full px-6 py-4 flex items-center justify-between border-b border-border last:border-b-0 hover:bg-accent/50 transition-colors"
            >
              <div className="flex items-center gap-3">
                <span className="text-xl">{item.icon}</span>
                <span>{item.label}</span>
              </div>
              <ChevronRight size={18} className="text-muted-foreground" />
            </button>
          ))}
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

        {showMetricDetail !== null && (
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            className="fixed inset-0 bg-black/50 z-50 flex items-center justify-center"
            onClick={() => setShowMetricDetail(null)}
          >
            <motion.div
              initial={{ scale: 0.9, opacity: 0 }}
              animate={{ scale: 1, opacity: 1 }}
              exit={{ scale: 0.9, opacity: 0 }}
              className="bg-background rounded-2xl p-6 w-full max-w-2xl mx-4 max-h-[80vh] overflow-y-auto"
              onClick={(e) => e.stopPropagation()}
            >
              <div className="flex items-center justify-between mb-6">
                <h2 className="text-xl">{healthMetrics[showMetricDetail].title}</h2>
                <button
                  onClick={() => setShowMetricDetail(null)}
                  className="w-8 h-8 bg-accent rounded-full flex items-center justify-center"
                >
                  <X size={18} />
                </button>
              </div>

              <div className="space-y-6">
                <div className="bg-accent rounded-xl p-4">
                  <p className="text-sm text-muted-foreground mb-1">최근 측정값</p>
                  <p className="text-3xl font-medium">
                    {healthMetrics[showMetricDetail].data[healthMetrics[showMetricDetail].data.length - 1].value}
                    <span className="text-lg text-muted-foreground ml-2">{healthMetrics[showMetricDetail].unit}</span>
                  </p>
                  <div className={`flex items-center gap-1 mt-2 ${healthMetrics[showMetricDetail].trend === 'down' ? 'text-green-600' : 'text-red-600'}`}>
                    {healthMetrics[showMetricDetail].trend === 'down' ? <TrendingDown size={16} /> : <TrendingUp size={16} />}
                    <span className="text-sm">{healthMetrics[showMetricDetail].trendValue}</span>
                  </div>
                </div>

                <div className="bg-card border border-border rounded-xl p-4">
                  <h3 className="mb-4">변화 추이</h3>
                  <ResponsiveContainer width="100%" height={200}>
                    <LineChart data={getDetailChartData(showMetricDetail)}>
                      <CartesianGrid strokeDasharray="3 3" stroke="#e5e7eb" />
                      <XAxis dataKey="date" stroke="#6b7280" style={{ fontSize: '12px' }} />
                      <YAxis stroke="#6b7280" style={{ fontSize: '12px' }} />
                      <Tooltip />
                      <Line
                        type="monotone"
                        dataKey="value"
                        stroke="#3EAFDF"
                        strokeWidth={2}
                        dot={{ fill: '#3EAFDF', r: 4 }}
                      />
                    </LineChart>
                  </ResponsiveContainer>
                </div>

                <div className="space-y-3">
                  <h3>최근 기록</h3>
                  {healthMetrics[showMetricDetail].data.slice().reverse().map((record, idx) => (
                    <div key={idx} className="flex items-center justify-between p-3 bg-accent rounded-xl">
                      <div className="flex items-center gap-3">
                        <div className={`w-3 h-3 rounded-full`} style={{ backgroundColor: getStatusColor(record.status) }} />
                        <span className="text-sm">{idx === 0 ? '오늘' : `${idx}일 전`}</span>
                      </div>
                      <span className="font-medium">{record.value} {healthMetrics[showMetricDetail].unit}</span>
                    </div>
                  ))}
                </div>

                <button
                  onClick={() => setShowMetricDetail(null)}
                  className="w-full py-3 bg-primary text-white rounded-xl hover:bg-primary/90 transition-colors"
                >
                  닫기
                </button>
              </div>
            </motion.div>
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  );
}
