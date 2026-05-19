import { useState } from 'react';
import { X, Bell } from 'lucide-react';
import { motion, AnimatePresence } from 'motion/react';

interface NotificationPanelProps {
  isOpen: boolean;
  onClose: () => void;
  onNavigate: (path: 'diet' | 'exercise' | 'health') => void;
}

export function NotificationPanel({ isOpen, onClose, onNavigate }: NotificationPanelProps) {
  const [showUnreadOnly, setShowUnreadOnly] = useState(false);

  const notifications = [
    {
      id: 1,
      icon: '🚨',
      iconColor: 'bg-red-100',
      title: '점심 나트륨 섭취량 초과 ⚠️',
      message: '오늘 점심에 나트륨을 많이 섭취하셨어요. 온이가 추천하는 담백한 저녁 식단을 확인해 보세요!',
      time: '방금 전',
      isRead: false,
      type: 'diet' as const
    },
    {
      id: 2,
      icon: '🩺',
      iconColor: 'bg-blue-100',
      title: '공복 혈당 기록하셨나요? 🩺',
      message: '개인 맞춤 당뇨 관리를 위해 오늘 아침 공복 혈당을 입력해 주세요.',
      time: '2시간 전',
      isRead: false,
      type: 'health' as const
    },
    {
      id: 3,
      icon: '🎉',
      iconColor: 'bg-yellow-100',
      title: '이번 주 운동 목표 달성! 👏',
      message: '주 5회 운동 성공! 고혈압 관리에 아주 좋은 신호입니다. 온이의 주간 분석 리포트를 확인해 보세요.',
      time: '어제',
      isRead: true,
      type: 'exercise' as const
    }
  ];

  const filteredNotifications = showUnreadOnly
    ? notifications.filter(n => !n.isRead)
    : notifications;

  const handleMarkAllRead = () => {
    // Mark all as read logic
  };

  const handleNotificationClick = (notification: typeof notifications[0]) => {
    onNavigate(notification.type);
    onClose();
  };

  return (
    <AnimatePresence>
      {isOpen && (
        <>
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            className="fixed inset-0 bg-black/50 z-50"
            onClick={onClose}
          />
          <motion.div
            initial={{ x: '100%' }}
            animate={{ x: 0 }}
            exit={{ x: '100%' }}
            transition={{ type: 'spring', damping: 25 }}
            className="fixed right-0 top-0 bottom-0 w-full sm:w-96 bg-background z-50 flex flex-col shadow-xl"
          >
            <div className="p-4 border-b border-border flex items-center justify-between">
              <h2 className="text-xl">알림</h2>
              <button
                onClick={onClose}
                className="w-8 h-8 bg-accent rounded-full flex items-center justify-center hover:bg-accent/80 transition-colors"
              >
                <X size={18} />
              </button>
            </div>

            <div className="p-4 border-b border-border flex items-center justify-between">
              <button
                onClick={() => setShowUnreadOnly(!showUnreadOnly)}
                className="flex items-center gap-2 text-sm"
              >
                <div className={`w-4 h-4 rounded border-2 flex items-center justify-center ${
                  showUnreadOnly ? 'bg-primary border-primary' : 'border-border'
                }`}>
                  {showUnreadOnly && <span className="text-white text-xs">✓</span>}
                </div>
                <span>안 읽은 알림만 보기</span>
              </button>
              <button
                onClick={handleMarkAllRead}
                className="text-sm text-primary hover:opacity-70 transition-opacity"
              >
                모두 읽음
              </button>
            </div>

            <div className="flex-1 overflow-y-auto">
              {filteredNotifications.length > 0 ? (
                <div className="divide-y divide-border">
                  {filteredNotifications.map((notification) => (
                    <button
                      key={notification.id}
                      onClick={() => handleNotificationClick(notification)}
                      className={`w-full p-4 text-left hover:bg-accent/50 transition-colors ${
                        !notification.isRead ? 'bg-primary/5' : ''
                      }`}
                    >
                      <div className="flex gap-3">
                        <div className={`w-10 h-10 ${notification.iconColor} rounded-full flex items-center justify-center text-xl flex-shrink-0`}>
                          {notification.icon}
                        </div>
                        <div className="flex-1 min-w-0">
                          <div className="flex items-center gap-2 mb-1">
                            <h3 className="text-sm font-medium">{notification.title}</h3>
                            {!notification.isRead && (
                              <div className="w-2 h-2 bg-primary rounded-full" />
                            )}
                          </div>
                          <p className="text-sm text-muted-foreground line-clamp-2 mb-2">
                            {notification.message}
                          </p>
                          <p className="text-xs text-muted-foreground">{notification.time}</p>
                        </div>
                      </div>
                    </button>
                  ))}
                </div>
              ) : (
                <div className="flex flex-col items-center justify-center h-full p-8 text-center">
                  <div className="text-6xl mb-4">🔔</div>
                  <p className="text-lg mb-2">아직 새로운 알림이 없어요</p>
                  <p className="text-sm text-muted-foreground">
                    온이와 함께 건강한 하루를 기록해 보세요!
                  </p>
                </div>
              )}
            </div>
          </motion.div>
        </>
      )}
    </AnimatePresence>
  );
}
