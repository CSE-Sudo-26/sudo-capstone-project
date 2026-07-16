import 'package:flutter/material.dart';

import 'package:oncare/design_system/figma/figma_kit.dart';
import 'package:oncare/features/exercise/presentation/widgets/exercise_flows.dart';
import 'package:oncare/features/notification/presentation/widgets/notification_panel.dart';
import 'package:oncare/shared/widgets/modals/right_slide_panel.dart';
import 'package:oncare/shared/widgets/modals/schedule_calendar_sheet.dart';

/// 운동 tab, rebuilt to the On-Care Figma redesign — a 운동 기록 / 헬스장
/// sub-tab switcher over a weekly summary, stacked activity chart, AI routine,
/// today's logs, and the gym card.
class ExercisePage extends StatefulWidget {
  const ExercisePage({super.key});

  @override
  State<ExercisePage> createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  int _subTab = 0; // 0 = 운동 기록, 1 = 헬스장
  String? _slot;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: ListView(
              padding: const EdgeInsets.only(bottom: 108),
              children: <Widget>[
                FigmaTabHeader(
                  title: '운동',
                  onBell: () => showRightSlidePanel<void>(
                    context,
                    content: const NotificationPanelBody(),
                  ),
                  onCalendar: () => showScheduleCalendarSheet(context),
                ),
                _SubTabs(
                  active: _subTab,
                  onChanged: (int i) => setState(() => _subTab = i),
                ),
                const SizedBox(height: 16),
                if (_subTab == 0)
                  _RecordTab(onAdd: () => showExerciseAddSheet(context))
                else
                  _GymTab(
                    selectedSlot: _slot,
                    onSlot: (String s) =>
                        setState(() => _slot = _slot == s ? null : s),
                    onFind: () => showGymLocatorSheet(context),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SubTabs extends StatelessWidget {
  const _SubTabs({required this.active, required this.onChanged});
  final int active;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0x12000000), width: 1.5),
          ),
        ),
        child: Row(
          children: <Widget>[
            _tab(0, Icons.event_note_outlined, '운동 기록'),
            _tab(1, Icons.place_outlined, '헬스장'),
          ],
        ),
      ),
    );
  }

  Widget _tab(int i, IconData icon, String label) {
    final bool on = active == i;
    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(i),
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: on ? FigmaColors.primary : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                icon,
                size: 14,
                color: on ? FigmaColors.primary : FigmaColors.textMuted,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: on ? FigmaColors.ink : FigmaColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ───────────────────────────────────────────────────────── 운동 기록 ──

class _RecordTab extends StatelessWidget {
  const _RecordTab({required this.onAdd});
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.fromLTRB(24, 0, 24, 12),
          child: Text(
            '이번 주 운동 요약',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: FigmaColors.ink,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: <Widget>[
              Expanded(
                child: _StatCard(label: '이번 주', value: '6', unit: '회'),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _StatCard(label: '시간', value: '350', unit: '분'),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _StatCard(
                  label: '칼로리',
                  value: '2239',
                  unit: 'kcal',
                  accent: true,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _StatCard(
                  label: '연속',
                  value: '6',
                  unit: '일 연속',
                  streak: true,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Padding(
          padding: EdgeInsets.fromLTRB(24, 0, 24, 12),
          child: Row(
            children: <Widget>[
              Text(
                '운동 현황',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: FigmaColors.ink,
                ),
              ),
              SizedBox(width: 8),
              Text(
                '이번 주',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: FigmaColors.textMuted,
                ),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: _ActivityChart(),
        ),
        const SizedBox(height: 20),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: _ExerciseFeedback(),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: _AiRoutine(onAdd: onAdd),
        ),
        const SizedBox(height: 20),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: _TodayLogs(),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.unit,
    this.accent = false,
    this.streak = false,
  });

  final String label;
  final String value;
  final String unit;
  final bool accent;
  final bool streak;

  @override
  Widget build(BuildContext context) {
    final Color bg = streak
        ? FigmaColors.heartOrange
        : accent
        ? FigmaColors.primaryA(0.07)
        : FigmaColors.statBg;
    final Color valueColor = streak
        ? Colors.white
        : accent
        ? FigmaColors.primary
        : FigmaColors.ink;
    final Color labelColor = streak
        ? Colors.white.withValues(alpha: 0.8)
        : FigmaColors.textMuted;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: streak
            ? null
            : Border.all(
                color: accent
                    ? FigmaColors.primaryA(0.15)
                    : FigmaColors.hairline,
              ),
        boxShadow: streak
            ? <BoxShadow>[
                BoxShadow(
                  color: FigmaColors.heartOrange.withValues(alpha: 0.4),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w600,
                    color: labelColor,
                  ),
                ),
              ),
              if (streak) const Text('🔥', style: TextStyle(fontSize: 12)),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: accent ? 13 : 15,
              fontWeight: FontWeight.w800,
              color: valueColor,
              height: 1,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            unit,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w500,
              color: streak
                  ? Colors.white.withValues(alpha: 0.85)
                  : accent
                  ? FigmaColors.primary.withValues(alpha: 0.7)
                  : FigmaColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityChart extends StatelessWidget {
  const _ActivityChart();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: FigmaColors.primaryA(0.10)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: FigmaColors.primaryA(0.08),
            blurRadius: 16,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 150,
            width: double.infinity,
            child: CustomPaint(painter: _StackedBarPainter()),
          ),
          const SizedBox(height: 6),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _Legend(color: FigmaColors.primary, label: '유산소'),
              SizedBox(width: 16),
              _Legend(color: Color(0xFF1B6FA8), label: '근력'),
              SizedBox(width: 16),
              _Legend(color: Color(0xFFD4EEF8), label: '스트레칭'),
            ],
          ),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: FigmaColors.textSub,
          ),
        ),
      ],
    );
  }
}

class _Bar {
  const _Bar(this.cardio, this.strength, this.stretch);
  final double cardio;
  final double strength;
  final double stretch;
}

const List<_Bar> _bars = <_Bar>[
  _Bar(30, 16, 8),
  _Bar(40, 24, 9),
  _Bar(32, 18, 9),
  _Bar(36, 24, 9),
  _Bar(40, 25, 9),
  _Bar(28, 12, 5),
  _Bar(6, 0, 0),
];
const List<String> _barDays = <String>['월', '화', '수', '목', '금', '토', '일'];

class _StackedBarPainter extends CustomPainter {
  static const double _max = 90;
  static const List<double> _grids = <double>[80, 60, 40, 20, 0];

  @override
  void paint(Canvas canvas, Size size) {
    const double left = 24;
    const double bottomPad = 24;
    final double chartH = size.height - bottomPad;
    final double chartW = size.width - left;

    const TextStyle gridStyle = TextStyle(
      fontSize: 8,
      color: FigmaColors.textFaint,
    );
    for (final double g in _grids) {
      final double y = chartH - (g / _max) * chartH;
      final Paint line = Paint()
        ..color = const Color(0x0F000000)
        ..strokeWidth = 1;
      canvas.drawLine(Offset(left, y), Offset(size.width, y), line);
      final TextPainter tp = TextPainter(
        text: TextSpan(text: '${g.toInt()}', style: gridStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(left - tp.width - 4, y - tp.height / 2));
    }

    final double slot = chartW / _bars.length;
    const double barW = 26;
    for (int i = 0; i < _bars.length; i++) {
      final _Bar b = _bars[i];
      final double cx = left + slot * i + slot / 2;
      final double x = cx - barW / 2;
      final bool isToday = i == 6;
      double yBottom = chartH;
      double h;
      // stretch (light, bottom)
      h = (b.stretch / _max) * chartH;
      if (h > 0) {
        _rrect(canvas, x, yBottom - h, barW, h, const Color(0xFFD4EEF8), 3);
        yBottom -= h;
      }
      // strength (dark mid)
      h = (b.strength / _max) * chartH;
      if (h > 0) {
        _rrect(canvas, x, yBottom - h, barW, h, const Color(0xFF1B6FA8), 0);
        yBottom -= h;
      }
      // cardio (blue top)
      h = (b.cardio / _max) * chartH;
      if (h > 0) {
        _rrect(
          canvas,
          x,
          yBottom - h,
          barW,
          h,
          isToday ? const Color(0xFF2190C4) : FigmaColors.primary,
          3,
        );
        yBottom -= h;
      }
      if (b.cardio + b.strength + b.stretch == 0) {
        _rrect(canvas, x, chartH - 3, barW, 3, const Color(0xFFEEF2F6), 1.5);
      }
      // day label
      final TextPainter tp = TextPainter(
        text: TextSpan(
          text: _barDays[i],
          style: TextStyle(
            fontSize: 9,
            fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
            color: isToday ? FigmaColors.primary : FigmaColors.textMuted,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(cx - tp.width / 2, chartH + 5));
      if (isToday) {
        final TextPainter t2 = TextPainter(
          text: const TextSpan(
            text: '오늘',
            style: TextStyle(
              fontSize: 7.5,
              fontWeight: FontWeight.w600,
              color: FigmaColors.primary,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        t2.paint(canvas, Offset(cx - t2.width / 2, chartH + 15));
      }
    }
  }

  void _rrect(
    Canvas c,
    double x,
    double y,
    double w,
    double h,
    Color color,
    double r,
  ) {
    final RRect rr = RRect.fromRectAndCorners(
      Rect.fromLTWH(x, y, w, h),
      topLeft: Radius.circular(r),
      topRight: Radius.circular(r),
    );
    c.drawRRect(rr, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ExerciseFeedback extends StatelessWidget {
  const _ExerciseFeedback();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: FigmaColors.softBlue,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: FigmaColors.primaryA(0.15)),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              OniAvatar(size: 40),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'AI 피드백',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: FigmaColors.primary,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      '걷기 30분 완료! 💪\n하체 스트레칭과 근력 운동까지 마치면 오늘 루틴 100%예요.',
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.5,
                        fontWeight: FontWeight.w500,
                        color: FigmaColors.ink,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFF4F5F7),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            children: <Widget>[
              Text('✦', style: TextStyle(fontSize: 10)),
              SizedBox(width: 6),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: FigmaColors.textMuted,
                    ),
                    children: <InlineSpan>[
                      TextSpan(text: '오늘 루틴은 '),
                      TextSpan(
                        text: 'AI 맞춤 조언',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF8A929E),
                        ),
                      ),
                      TextSpan(text: '을 바탕으로 구성됐어요'),
                    ],
                  ),
                ),
              ),
              Icon(Icons.check, size: 13, color: FigmaColors.primary),
            ],
          ),
        ),
      ],
    );
  }
}

class _AiRoutine extends StatelessWidget {
  const _AiRoutine({required this.onAdd});
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            const Text(
              'AI 맞춤 루틴 · 오늘',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: FigmaColors.ink,
              ),
            ),
            const Spacer(),
            const Text(
              '1/3',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: FigmaColors.primary,
              ),
            ),
            const SizedBox(width: 8),
            Material(
              color: FigmaColors.primary,
              borderRadius: BorderRadius.circular(999),
              child: InkWell(
                onTap: onAdd,
                borderRadius: BorderRadius.circular(999),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(Icons.add, size: 12, color: Colors.white),
                      SizedBox(width: 4),
                      Text(
                        '운동 추가',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _Fill33(),
        const SizedBox(height: 16),
        const _RoutineCard(
          title: '빠르게 걷기 30분',
          subtitle: '유산소 · 혈압 관리',
          done: true,
        ),
        const SizedBox(height: 10),
        const _RoutineCard(
          title: '하체 스트레칭',
          subtitle: '스트레칭 · 유연성',
          minutes: '10분',
        ),
        const SizedBox(height: 10),
        const _RoutineCard(
          title: '저강도 근력',
          subtitle: '근력 · 근지구력',
          minutes: '15분',
        ),
      ],
    );
  }
}

class _Fill33 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: SizedBox(
        height: 5,
        child: Row(
          children: <Widget>[
            const Expanded(
              flex: 33,
              child: ColoredBox(color: FigmaColors.primary),
            ),
            Expanded(
              flex: 67,
              child: ColoredBox(color: FigmaColors.primaryA(0.12)),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoutineCard extends StatelessWidget {
  const _RoutineCard({
    required this.title,
    required this.subtitle,
    this.done = false,
    this.minutes,
  });

  final String title;
  final String subtitle;
  final bool done;
  final String? minutes;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: done ? FigmaColors.primaryA(0.15) : FigmaColors.hairline,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          if (done)
            Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                color: FigmaColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, size: 15, color: Colors.white),
            )
          else
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: const Color(0xFFF6FBFE),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: FigmaColors.primaryA(0.3), width: 2),
              ),
            ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: done ? FigmaColors.textFaint : FigmaColors.ink,
                    decoration: done ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: done ? FigmaColors.textFaint : FigmaColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          if (done)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: FigmaColors.statusGreen,
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(Icons.check, size: 9, color: Colors.white),
                  SizedBox(width: 3),
                  Text(
                    '미션 완료!',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            )
          else if (minutes != null)
            Text(
              minutes!,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: FigmaColors.textMuted,
              ),
            ),
        ],
      ),
    );
  }
}

class _TodayLogs extends StatelessWidget {
  const _TodayLogs();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          '오늘의 운동',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: FigmaColors.ink,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFF4F5F7),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            children: <Widget>[
              Text('📥', style: TextStyle(fontSize: 10)),
              SizedBox(width: 6),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: FigmaColors.textMuted,
                    ),
                    children: <InlineSpan>[
                      TextSpan(text: '오늘 헬스장 운동 데이터를 '),
                      TextSpan(
                        text: '김트레이너님',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF8A929E),
                        ),
                      ),
                      TextSpan(text: '이 전송했어요'),
                    ],
                  ),
                ),
              ),
              Icon(Icons.check, size: 13, color: FigmaColors.statusGreen),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const _LogCard(
          tag: '유산소',
          time: '07:30',
          kcal: 225,
          items: <String>['러닝머신 30분', '30분 운동'],
        ),
        const SizedBox(height: 12),
        const _LogCard(
          tag: '근력',
          time: '18:00',
          kcal: 150,
          items: <String>['스쿼트 3세트', '데드리프트 3세트'],
        ),
      ],
    );
  }
}

class _LogCard extends StatelessWidget {
  const _LogCard({
    required this.tag,
    required this.time,
    required this.kcal,
    required this.items,
  });

  final String tag;
  final String time;
  final int kcal;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: FigmaColors.hairline),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 16,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: FigmaColors.primaryA(0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  tag,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: FigmaColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                time,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: FigmaColors.textFaint,
                ),
              ),
              const Spacer(),
              Text(
                '$kcal kcal',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: FigmaColors.primary,
                ),
              ),
              const SizedBox(width: 4),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => showExerciseAddSheet(context, edit: true),
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(
                    Icons.chevron_right,
                    size: 16,
                    color: FigmaColors.textFaint,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: FigmaColors.hairline),
          const SizedBox(height: 12),
          for (final String it in items)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: FigmaColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    it,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF3A3A4A),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ───────────────────────────────────────────────────────── 헬스장 ──

class _GymTab extends StatelessWidget {
  const _GymTab({
    required this.selectedSlot,
    required this.onSlot,
    required this.onFind,
  });

  final String? selectedSlot;
  final ValueChanged<String> onSlot;
  final VoidCallback onFind;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onFind,
              style: FilledButton.styleFrom(
                backgroundColor: FigmaColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: const Icon(Icons.search, size: 16),
              label: const Text(
                '헬스장 찾기',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: FigmaColors.hairline),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.09),
                  blurRadius: 24,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Row(
                  children: <Widget>[
                    Icon(
                      Icons.place_outlined,
                      size: 15,
                      color: FigmaColors.primary,
                    ),
                    SizedBox(width: 6),
                    Text(
                      '내 헬스장',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: FigmaColors.textMuted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  '강남 피트니스 센터',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: FigmaColors.ink,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  '📍 서울시 강남구 역삼동 123-45 · 0.8km',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: FigmaColors.textMuted,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: <Widget>[
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEEF2F6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person_outline,
                        size: 18,
                        color: FigmaColors.textFaint,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '김트레이너',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: FigmaColors.ink,
                          ),
                        ),
                        Text(
                          '전담 트레이너',
                          style: TextStyle(
                            fontSize: 11,
                            color: FigmaColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: <Widget>[
                    for (final String t in <String>['다이어트', '재활운동'])
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: FigmaColors.primaryA(0.10),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            t,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: FigmaColors.primary,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[
                        FigmaColors.bannerStart,
                        FigmaColors.bannerEnd,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: FigmaColors.primaryA(0.18)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Row(
                        children: <Widget>[
                          Text(
                            '✦ AI 추천 예약 시간',
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              color: FigmaColors.primary,
                            ),
                          ),
                          SizedBox(width: 6),
                          Text(
                            '김트레이너 빈 시간',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w500,
                              color: FigmaColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: <Widget>[
                          for (final List<String> s in const <List<String>>[
                            <String>['오늘 19:00', '잔여 1자리'],
                            <String>['내일 07:30', '여유 있음'],
                            <String>['내일 20:00', '잔여 2자리'],
                          ])
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: _SlotChip(
                                label: s[0],
                                sub: s[1],
                                selected: selectedSlot == s[0],
                                onTap: () => onSlot(s[0]),
                              ),
                            ),
                        ],
                      ),
                      if (selectedSlot != null) ...<Widget>[
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('$selectedSlot 예약이 확정됐어요'),
                                ),
                              );
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: FigmaColors.primary,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              '$selectedSlot 예약 확정',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                const Divider(height: 1, color: FigmaColors.hairline),
                const SizedBox(height: 12),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => showGymInfoSheet(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: FigmaColors.primary,
                          backgroundColor: FigmaColors.softBlue,
                          side: BorderSide(color: FigmaColors.primaryA(0.18)),
                          padding: const EdgeInsets.symmetric(vertical: 11),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          '헬스장 정보',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: FilledButton(
                        onPressed: () => showGymChatSheet(context),
                        style: FilledButton.styleFrom(
                          backgroundColor: FigmaColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 11),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          '💬 1:1 상담',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SlotChip extends StatelessWidget {
  const _SlotChip({
    required this.label,
    required this.sub,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String sub;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? FigmaColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: selected
              ? null
              : Border.all(color: FigmaColors.primaryA(0.25)),
          boxShadow: selected
              ? <BoxShadow>[
                  BoxShadow(
                    color: FigmaColors.primaryA(0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Column(
          children: <Widget>[
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: selected ? Colors.white : FigmaColors.ink,
              ),
            ),
            Text(
              sub,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w500,
                color: selected
                    ? Colors.white.withValues(alpha: 0.8)
                    : FigmaColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
