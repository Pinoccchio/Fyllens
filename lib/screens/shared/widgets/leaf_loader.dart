import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:fyllens/core/theme/app_colors.dart';
import 'package:fyllens/core/constants/app_spacing.dart';

/// Leaf loader widget - "Organic Luxury" Design System
///
/// A custom animated loading indicator featuring:
/// - Rotating leaf with gentle sway
/// - Pulsing glow effect
/// - Multiple leaf variants for variety
/// - Fade and scale animations
class LeafLoader extends StatefulWidget {
  final double size;
  final Color? color;
  final Duration duration;
  final bool showGlow;

  const LeafLoader({
    super.key,
    this.size = 40,
    this.color,
    this.duration = const Duration(milliseconds: 1500),
    this.showGlow = true,
  });

  /// Small variant
  const LeafLoader.small({
    super.key,
    this.color,
    this.showGlow = false,
  })  : size = 24,
        duration = const Duration(milliseconds: 1200);

  /// Medium variant (default)
  const LeafLoader.medium({
    super.key,
    this.color,
    this.showGlow = true,
  })  : size = 40,
        duration = const Duration(milliseconds: 1500);

  /// Large variant
  const LeafLoader.large({
    super.key,
    this.color,
    this.showGlow = true,
  })  : size = 60,
        duration = const Duration(milliseconds: 1800);

  @override
  State<LeafLoader> createState() => _LeafLoaderState();
}

class _LeafLoaderState extends State<LeafLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _swayAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat();

    // Main rotation (360 degrees)
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));

    // Gentle sway side-to-side
    _swayAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 0.1),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.1, end: 0.0),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: -0.1),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween(begin: -0.1, end: 0.0),
        weight: 25,
      ),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Subtle scale pulse
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.1),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.1, end: 1.0),
        weight: 50,
      ),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Glow pulse
    _glowAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.2, end: 0.4),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.4, end: 0.2),
        weight: 50,
      ),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final leafColor = widget.color ?? AppColors.primarySage;

    return SizedBox(
      width: widget.size * 1.5,
      height: widget.size * 1.5,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // Glow effect
              if (widget.showGlow)
                Container(
                  width: widget.size * 1.2,
                  height: widget.size * 1.2,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: leafColor.withValues(alpha: _glowAnimation.value),
                        blurRadius: widget.size * 0.5,
                        spreadRadius: widget.size * 0.1,
                      ),
                    ],
                  ),
                ),

              // Rotating leaf
              Transform.rotate(
                angle: _rotationAnimation.value,
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..rotateY(_swayAnimation.value),
                    child: CustomPaint(
                      size: Size(widget.size, widget.size),
                      painter: LeafPainter(
                        color: leafColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Custom painter for drawing a leaf shape
class LeafPainter extends CustomPainter {
  final Color color;

  LeafPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();

    // Draw a simple leaf shape
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final leafWidth = size.width * 0.4;
    final leafHeight = size.height * 0.9;

    // Top point
    path.moveTo(centerX, centerY - leafHeight / 2);

    // Right curve
    path.quadraticBezierTo(
      centerX + leafWidth,
      centerY - leafHeight / 4,
      centerX + leafWidth * 0.8,
      centerY + leafHeight / 6,
    );
    path.quadraticBezierTo(
      centerX + leafWidth * 0.5,
      centerY + leafHeight / 3,
      centerX,
      centerY + leafHeight / 2,
    );

    // Left curve (mirror)
    path.quadraticBezierTo(
      centerX - leafWidth * 0.5,
      centerY + leafHeight / 3,
      centerX - leafWidth * 0.8,
      centerY + leafHeight / 6,
    );
    path.quadraticBezierTo(
      centerX - leafWidth,
      centerY - leafHeight / 4,
      centerX,
      centerY - leafHeight / 2,
    );

    path.close();
    canvas.drawPath(path, paint);

    // Draw center vein
    final veinPaint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.03;

    final veinPath = Path()
      ..moveTo(centerX, centerY - leafHeight / 2)
      ..quadraticBezierTo(
        centerX,
        centerY,
        centerX,
        centerY + leafHeight / 2 - size.height * 0.05,
      );

    canvas.drawPath(veinPath, veinPaint);

    // Draw side veins
    for (var i = 1; i <= 3; i++) {
      final y = centerY - leafHeight / 4 + (i * leafHeight / 6);
      final xOffset = leafWidth * 0.6 * (1 - (i / 4));

      // Right vein
      final rightVein = Path()
        ..moveTo(centerX, y)
        ..quadraticBezierTo(
          centerX + xOffset * 0.5,
          y - size.height * 0.02,
          centerX + xOffset,
          y - size.height * 0.05,
        );
      canvas.drawPath(rightVein, veinPaint);

      // Left vein
      final leftVein = Path()
        ..moveTo(centerX, y)
        ..quadraticBezierTo(
          centerX - xOffset * 0.5,
          y - size.height * 0.02,
          centerX - xOffset,
          y - size.height * 0.05,
        );
      canvas.drawPath(leftVein, veinPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Triple leaf loading indicator for chat typing
class TripleLeafLoader extends StatefulWidget {
  final double size;
  final Color? color;
  final Duration staggerDelay;

  const TripleLeafLoader({
    super.key,
    this.size = 16,
    this.color,
    this.staggerDelay = const Duration(milliseconds: 150),
  });

  @override
  State<TripleLeafLoader> createState() => _TripleLeafLoaderState();
}

class _TripleLeafLoaderState extends State<TripleLeafLoader>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();

    _controllers = List.generate(
      3,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: this,
      ),
    );

    _animations = _controllers.map((controller) {
      return TweenSequence<double>([
        TweenSequenceItem(
          tween: Tween(begin: 0.0, end: -8.0).chain(CurveTween(curve: Curves.easeOut)),
          weight: 50,
        ),
        TweenSequenceItem(
          tween: Tween(begin: -8.0, end: 0.0).chain(CurveTween(curve: Curves.easeIn)),
          weight: 50,
        ),
      ]).animate(controller);
    }).toList();

    // Start staggered animation
    _startStaggeredAnimation();
  }

  void _startStaggeredAnimation() async {
    while (mounted) {
      for (var i = 0; i < _controllers.length; i++) {
        if (!mounted) return;
        _controllers[i].forward(from: 0);
        await Future.delayed(widget.staggerDelay);
      }
      await Future.delayed(const Duration(milliseconds: 200));
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final leafColor = widget.color ?? AppColors.primaryMint;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              child: Transform.translate(
                offset: Offset(0, _animations[index].value),
                child: CustomPaint(
                  size: Size(widget.size, widget.size),
                  painter: LeafPainter(color: leafColor),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

/// Loading overlay with leaf animation
class LeafLoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String? message;
  final Color? backgroundColor;

  const LeafLoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.message,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: backgroundColor ?? Colors.black.withValues(alpha: 0.3),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const LeafLoader.large(),
                  if (message != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      message!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ],
                ],
              ),
            ),
          ),
      ],
    );
  }
}
