import { Bell, Calendar } from 'lucide-react';

interface HeaderProps {
  title: string;
  onNotificationClick: () => void;
  onCalendarClick: () => void;
  hasUnreadNotifications?: boolean;
}

export function Header({ title, onNotificationClick, onCalendarClick, hasUnreadNotifications = true }: HeaderProps) {
  return (
    <div className="sticky top-0 z-20 bg-background border-b border-border">
      <div className="px-4 py-4 flex items-center justify-between">
        <h1 className="text-2xl">{title}</h1>

        <div className="flex items-center gap-2">
          <button
            onClick={onNotificationClick}
            className="w-10 h-10 flex items-center justify-center rounded-full hover:bg-accent transition-colors relative"
          >
            <Bell size={20} className="text-foreground" />
            {hasUnreadNotifications && (
              <span className="absolute top-2 right-2 w-2 h-2 bg-warning rounded-full" />
            )}
          </button>

          <button
            onClick={onCalendarClick}
            className="w-10 h-10 flex items-center justify-center rounded-full hover:bg-accent transition-colors"
          >
            <Calendar size={20} className="text-foreground" />
          </button>
        </div>
      </div>
    </div>
  );
}
