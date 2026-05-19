import { useState } from 'react';
import { Send, AlertCircle } from 'lucide-react';

export function AICoach() {
  const [message, setMessage] = useState('');

  const quickReplies = [
    '간식 추천해줘',
    '오늘 나트륨 괜찮아?',
    '저녁 메뉴 추천',
    '운동 팁 알려줘',
  ];

  const messages = [
    {
      type: 'ai',
      content: '안녕하세요! 건강 관리를 도와드릴 AI 코치예요. 무엇이든 물어보세요.',
      timestamp: '10:30',
    },
    {
      type: 'user',
      content: '오늘 점심에 김치찌개 먹었는데 괜찮아?',
      timestamp: '13:05',
    },
    {
      type: 'ai',
      content: '김치찌개는 나트륨이 높은 편이에요. 오늘 이미 1,420mg의 나트륨을 섭취하셨어서, 저녁에는 담백한 식단을 추천드려요. 구운 생선이나 샐러드는 어떨까요?',
      timestamp: '13:05',
      recommendations: [
        { name: '구운 연어', image: '🐟', sodium: '150mg' },
        { name: '그릭 샐러드', image: '🥗', sodium: '280mg' },
      ],
    },
  ];

  return (
    <div className="pb-20 flex flex-col h-screen bg-background">
      <div className="px-4 pt-6 pb-4 bg-white border-b border-border">
        <h1 className="text-2xl mb-3">AI 건강 코치</h1>
        <div className="bg-warning/10 border border-warning/20 rounded-xl p-3 flex items-start gap-2">
          <AlertCircle size={18} className="text-warning mt-0.5" />
          <p className="text-sm text-warning">
            이번 주 탄수화물 섭취량이 12% 초과했어요
          </p>
        </div>
      </div>

      <div className="flex-1 overflow-y-auto px-4 py-4 space-y-4">
        {messages.map((msg, index) => (
          <div
            key={index}
            className={`flex ${msg.type === 'user' ? 'justify-end' : 'justify-start'}`}
          >
            <div
              className={`max-w-[80%] ${
                msg.type === 'user'
                  ? 'bg-primary text-white'
                  : 'bg-card border border-border'
              } rounded-2xl p-4`}
            >
              <p className="text-sm">{msg.content}</p>
              {msg.recommendations && (
                <div className="grid grid-cols-2 gap-3 mt-3">
                  {msg.recommendations.map((rec, i) => (
                    <div
                      key={i}
                      className="bg-background rounded-xl p-3 text-center border border-border"
                    >
                      <div className="text-3xl mb-2">{rec.image}</div>
                      <p className="text-sm font-medium text-foreground">{rec.name}</p>
                      <p className="text-xs text-muted-foreground">{rec.sodium}</p>
                    </div>
                  ))}
                </div>
              )}
              <p className="text-xs opacity-70 mt-2">{msg.timestamp}</p>
            </div>
          </div>
        ))}
      </div>

      <div className="px-4 pb-4 bg-white border-t border-border">
        <div className="flex gap-2 mb-3 overflow-x-auto">
          {quickReplies.map((reply, index) => (
            <button
              key={index}
              className="px-4 py-2 bg-accent rounded-full text-sm whitespace-nowrap hover:bg-accent/80"
            >
              {reply}
            </button>
          ))}
        </div>

        <div className="flex gap-2">
          <input
            type="text"
            value={message}
            onChange={(e) => setMessage(e.target.value)}
            placeholder="메시지를 입력하세요..."
            className="flex-1 px-4 py-3 bg-input-background rounded-xl outline-none focus:ring-2 focus:ring-primary"
          />
          <button className="w-12 h-12 bg-primary rounded-xl flex items-center justify-center">
            <Send size={20} className="text-white" />
          </button>
        </div>
      </div>
    </div>
  );
}
