import 'package:flutter/material.dart';

import 'package:oncare/design_system/tokens/spacing.dart';
import 'package:oncare/features/diet/presentation/pages/diet_add_analyzing_page.dart';

/// Fake camera capture screen. Renders a viewfinder-style overlay over
/// a dark gradient placeholder (no real camera preview yet). Tapping the
/// shutter flashes the screen and pushes the analyzing page. When the
/// analyzing page returns `true`, this page pops with `true` so the
/// diet record page can confirm the capture flow finished.
class DietAddCameraPage extends StatefulWidget {
  const DietAddCameraPage({super.key});

  @override
  State<DietAddCameraPage> createState() => _DietAddCameraPageState();
}

class _DietAddCameraPageState extends State<DietAddCameraPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _flashCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 220),
  );
  bool _capturing = false;

  @override
  void dispose() {
    _flashCtrl.dispose();
    super.dispose();
  }

  Future<void> _onShutter() async {
    if (_capturing) return;
    setState(() => _capturing = true);
    await _flashCtrl.forward(from: 0);
    if (!mounted) return;
    final analyzed = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => const DietAddAnalyzingPage(),
        fullscreenDialog: true,
      ),
    );
    if (!mounted) return;
    if (analyzed == true) {
      Navigator.of(context).pop(true);
    } else {
      // User cancelled analysis — stay on camera so they can retake.
      _flashCtrl.reverse();
      setState(() => _capturing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          const Positioned.fill(child: _FauxCameraPreview()),
          const Center(child: _ViewfinderFrame()),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _RoundIconButton(
                    icon: Icons.close,
                    onTap: () => Navigator.of(context).pop(false),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text(
                      '식단 사진 촬영',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 40),
                ],
              ),
            ),
          ),
          Align(
            alignment: const Alignment(0, 0.6),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Text(
                '음식이 프레임 안에 들어오도록 맞춰 주세요',
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
                child: _ShutterButton(
                  onTap: _onShutter,
                  enabled: !_capturing,
                ),
              ),
            ),
          ),
          IgnorePointer(
            child: FadeTransition(
              opacity: Tween<double>(begin: 0, end: 1).animate(
                CurvedAnimation(parent: _flashCtrl, curve: Curves.easeOut),
              ),
              child: Container(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _FauxCameraPreview extends StatelessWidget {
  const _FauxCameraPreview();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          colors: <Color>[Color(0xFF1F2937), Color(0xFF0B1220)],
          radius: 1.2,
        ),
      ),
    );
  }
}

class _ViewfinderFrame extends StatelessWidget {
  const _ViewfinderFrame();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.shortestSide * 0.72;
    return SizedBox(
      width: size,
      height: size,
      child: const Stack(
        children: <Widget>[
          Align(alignment: Alignment.topLeft, child: _CornerBracket(corner: Alignment.topLeft)),
          Align(alignment: Alignment.topRight, child: _CornerBracket(corner: Alignment.topRight)),
          Align(alignment: Alignment.bottomLeft, child: _CornerBracket(corner: Alignment.bottomLeft)),
          Align(alignment: Alignment.bottomRight, child: _CornerBracket(corner: Alignment.bottomRight)),
        ],
      ),
    );
  }
}

class _CornerBracket extends StatelessWidget {
  const _CornerBracket({required this.corner});

  final Alignment corner;

  @override
  Widget build(BuildContext context) {
    const double thickness = 3;
    const double length = 28;
    final color = Colors.white.withValues(alpha: 0.9);
    final isTop = corner.y < 0;
    final isLeft = corner.x < 0;
    return SizedBox(
      width: length,
      height: length,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: isTop ? 0 : null,
            bottom: isTop ? null : 0,
            left: isLeft ? 0 : null,
            right: isLeft ? null : 0,
            child: Container(width: length, height: thickness, color: color),
          ),
          Positioned(
            top: isTop ? 0 : null,
            bottom: isTop ? null : 0,
            left: isLeft ? 0 : null,
            right: isLeft ? null : 0,
            child: Container(width: thickness, height: length, color: color),
          ),
        ],
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.45),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(icon, color: Colors.white, size: 22),
        ),
      ),
    );
  }
}

class _ShutterButton extends StatelessWidget {
  const _ShutterButton({required this.onTap, required this.enabled});

  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedOpacity(
        opacity: enabled ? 1.0 : 0.5,
        duration: const Duration(milliseconds: 120),
        child: Container(
          width: 78,
          height: 78,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 4),
          ),
          child: Center(
            child: Container(
              width: 62,
              height: 62,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
