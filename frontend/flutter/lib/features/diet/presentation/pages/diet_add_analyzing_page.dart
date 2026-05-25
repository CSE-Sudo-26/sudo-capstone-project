import 'dart:async';

import 'package:flutter/material.dart';

import 'package:oncare/design_system/tokens/colors.dart';
import 'package:oncare/design_system/tokens/radius.dart';
import 'package:oncare/design_system/tokens/spacing.dart';

/// Fake "AI 분석 중" screen shown after the shutter is pressed.
/// Steps cycle every ~900ms and the screen auto-completes after ~2.8s,
/// popping `true` so the camera page knows the capture flow finished.
/// The actual YOLO / Gemini Vision pipeline is not wired up yet — this
/// is a UX placeholder so the diet add flow feels live in demos.
class DietAddAnalyzingPage extends StatefulWidget {
  const DietAddAnalyzingPage({super.key});

  @override
  State<DietAddAnalyzingPage> createState() => _DietAddAnalyzingPageState();
}

class _DietAddAnalyzingPageState extends State<DietAddAnalyzingPage> {
  static const List<_Step> _steps = <_Step>[
    _Step(icon: Icons.center_focus_strong, label: '음식을 인식하고 있어요'),
    _Step(icon: Icons.calculate_outlined, label: '영양 정보를 계산하고 있어요'),
    _Step(icon: Icons.fact_check_outlined, label: '결과를 정리하고 있어요'),
  ];

  int _stepIndex = 0;
  Timer? _stepTimer;
  Timer? _doneTimer;

  @override
  void initState() {
    super.initState();
    _stepTimer = Timer.periodic(const Duration(milliseconds: 900), (Timer t) {
      if (!mounted) return;
      if (_stepIndex >= _steps.length - 1) {
        t.cancel();
        return;
      }
      setState(() => _stepIndex++);
    });
    _doneTimer = Timer(const Duration(milliseconds: 2800), () {
      if (!mounted) return;
      Navigator.of(context).pop(true);
    });
  }

  @override
  void dispose() {
    _stepTimer?.cancel();
    _doneTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: IconButton(
                  tooltip: '취소',
                  onPressed: () => Navigator.of(context).pop(false),
                  icon: const Icon(Icons.close),
                ),
              ),
            ),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 360),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const Center(child: _CapturedThumbnail()),
                      const SizedBox(height: AppSpacing.xl),
                      const Center(
                        child: SizedBox(
                          width: 48,
                          height: 48,
                          child: CircularProgressIndicator(
                            strokeWidth: 4,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        'AI가 식단을 분석하고 있어요',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        '잠시만 기다려 주세요 · 보통 2~3초 소요됩니다',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.mutedForeground,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      for (int i = 0; i < _steps.length; i++)
                        Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: _StepRow(
                            step: _steps[i],
                            state: i < _stepIndex
                                ? _RowState.done
                                : i == _stepIndex
                                    ? _RowState.active
                                    : _RowState.pending,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _RowState { pending, active, done }

class _Step {
  const _Step({required this.icon, required this.label});
  final IconData icon;
  final String label;
}

class _StepRow extends StatelessWidget {
  const _StepRow({required this.step, required this.state});

  final _Step step;
  final _RowState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final leading = switch (state) {
      _RowState.done => const Icon(
          Icons.check_circle,
          color: AppColors.success,
          size: 22,
        ),
      _RowState.active => const SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(
            strokeWidth: 2.4,
            color: AppColors.primary,
          ),
        ),
      _RowState.pending => Icon(
          step.icon,
          color: AppColors.mutedForeground,
          size: 22,
        ),
    };
    return Row(
      children: <Widget>[
        SizedBox(width: 28, height: 28, child: Center(child: leading)),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            step.label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: state == _RowState.pending
                  ? AppColors.mutedForeground
                  : AppColors.foreground,
              fontWeight: state == _RowState.active
                  ? FontWeight.w600
                  : FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _CapturedThumbnail extends StatelessWidget {
  const _CapturedThumbnail();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 132,
      height: 132,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(AppRadius.lg),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[AppColors.accent, AppColors.muted],
        ),
        border: Border.all(color: AppColors.border),
      ),
      child: const Center(
        child: Icon(Icons.restaurant, size: 48, color: AppColors.primary),
      ),
    );
  }
}
