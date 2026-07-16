import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:oncare/app/router/routes.dart';
import 'package:oncare/design_system/figma/figma_kit.dart';

/// The AI 코치 chat screen, rebuilt to the On-Care Figma design. Opened from the
/// coaching sheet's "AI와 대화하기" CTA.
class AICoachPage extends StatefulWidget {
  const AICoachPage({super.key});

  @override
  State<AICoachPage> createState() => _AICoachPageState();
}

class _ChatMsg {
  const _ChatMsg(this.text, {required this.fromUser, this.time});
  final String text;
  final bool fromUser;
  final String? time;
}

const List<String> _quickReplies = <String>[
  '오늘 저녁 메뉴 추천해줘',
  '오늘 운동은 얼마나 하면 좋을까?',
  '내 혈당 기록은 괜찮아?',
];

class _AICoachPageState extends State<AICoachPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scroll = ScrollController();
  final List<_ChatMsg> _messages = <_ChatMsg>[
    const _ChatMsg(
      '안녕하세요, 민수님!\n오늘 기록을 바탕으로 건강 관리를 함께 도와드릴게요.',
      fromUser: false,
      time: '오후 2:10',
    ),
  ];

  bool get _hasConversation => _messages.any((_ChatMsg m) => m.fromUser);

  @override
  void dispose() {
    _controller.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _send([String? preset]) {
    final String text = (preset ?? _controller.text).trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_ChatMsg(text, fromUser: true));
      _messages.add(
        const _ChatMsg(
          '좋은 질문이에요! 오늘 기록을 살펴보면 나트륨이 조금 높은 편이라, '
          '저녁은 담백한 구이나 샐러드를 추천해요. 식후 20분 가벼운 산책도 함께 해보세요. 🙂',
          fromUser: false,
        ),
      );
      _controller.clear();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              children: <Widget>[
                _header(context),
                Expanded(
                  child: ListView(
                    controller: _scroll,
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                    children: <Widget>[
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8EEF4),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: const Text(
                            '오늘',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: FigmaColors.textSub,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      for (final _ChatMsg m in _messages) ...<Widget>[
                        _bubble(m),
                        const SizedBox(height: 16),
                      ],
                      if (!_hasConversation) _quickReplySection(),
                    ],
                  ),
                ),
                _inputBar(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: <Widget>[
          _circle(
            Icons.chevron_left,
            () => context.canPop()
                ? context.pop()
                : context.go(AppRoutes.dashboard),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Stack(
                  clipBehavior: Clip.none,
                  children: <Widget>[
                    const OniAvatar(size: 38),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: FigmaColors.onlineGreen,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'AI 코치',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: FigmaColors.ink,
                      ),
                    ),
                    Text(
                      '언제든 물어보세요',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: FigmaColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _circle(Icons.more_horiz, () {}),
        ],
      ),
    );
  }

  Widget _circle(IconData icon, VoidCallback onTap) {
    return Material(
      color: FigmaColors.softBlue,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: 36,
          height: 36,
          child: Icon(icon, size: 20, color: FigmaColors.primary),
        ),
      ),
    );
  }

  Widget _bubble(_ChatMsg m) {
    if (m.fromUser) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Flexible(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 260),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: FigmaColors.primary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(4),
                ),
              ),
              child: Text(
                m.text,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        const OniAvatar(size: 34),
        const SizedBox(width: 10),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                constraints: const BoxConstraints(maxWidth: 255),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 13,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(4),
                    bottomRight: Radius.circular(16),
                  ),
                  border: Border.all(color: FigmaColors.hairline),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.07),
                      blurRadius: 14,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  m.text,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                    color: FigmaColors.ink,
                  ),
                ),
              ),
              if (m.time != null)
                Padding(
                  padding: const EdgeInsets.only(top: 6, left: 4),
                  child: Text(
                    m.time!,
                    style: const TextStyle(
                      fontSize: 11,
                      color: FigmaColors.textFaint,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _quickReplySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            '이런 걸 물어보세요',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: FigmaColors.textSub,
            ),
          ),
        ),
        for (final String q in _quickReplies) ...<Widget>[
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              onTap: () => _send(q),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 13,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: FigmaColors.primaryA(0.3), width: 1.5),
                ),
                child: Text(
                  q,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: FigmaColors.primary,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }

  Widget _inputBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: FigmaColors.softBlue,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: FigmaColors.primaryA(0.22), width: 1.5),
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: FigmaColors.primaryA(0.25), width: 1.5),
              ),
              child: const Icon(Icons.add, size: 16, color: FigmaColors.primary),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _controller,
                onSubmitted: (_) => _send(),
                style: const TextStyle(fontSize: 14, color: FigmaColors.ink),
                decoration: const InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  hintText: 'AI에게 무엇이든 물어보세요',
                  hintStyle: TextStyle(
                    fontSize: 13,
                    color: FigmaColors.textFaint,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => _send(),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: FigmaColors.primary,
                  shape: BoxShape.circle,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: FigmaColors.primaryA(0.45),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.arrow_upward,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
