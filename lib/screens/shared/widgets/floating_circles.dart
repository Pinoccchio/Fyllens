import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Reusable floating circle decoration widget
/// Creates animated circles that float up and down with sine wave motion
class FloatingCircle extends StatelessWidget {
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  final double size;
  final Color color;
  final AnimationController controller;

  const FloatingCircle({
    super.key,
    this.top,
    this.bottom,
    this.left,
    this.right,
    required this.size,
    required this.color,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, math.sin(controller.value * 2 * math.pi) * 10),
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(shape: BoxShape.circle, color: color),
            ),
          );
        },
      ),
    );
  }
}

/// Helper widget to create multiple floating circles for a screen
/// Automatically creates and manages animation controller
class FloatingCirclesBackground extends StatefulWidget {
  final List<FloatingCircleData> circles;
  final Widget child;

  const FloatingCirclesBackground({
    super.key,
    required this.circles,
    required this.child,
  });

  @override
  State<FloatingCirclesBackground> createState() =>
      _FloatingCirclesBackgroundState();
}

class _FloatingCirclesBackgroundState extends State<FloatingCirclesBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        // Floating circles
        ...widget.circles.map((circleData) {
          return FloatingCircle(
            top: circleData.top != null ? screenHeight * circleData.top! : null,
            bottom: circleData.bottom != null
                ? screenHeight * circleData.bottom!
                : null,
            left: circleData.left,
            right: circleData.right,
            size: circleData.size,
            color: circleData.color,
            controller: _controller,
          );
        }),

        // Main content
        widget.child,
      ],
    );
  }
}

/// Data class for floating circle configuration
class FloatingCircleData {
  final double? top; // Percentage of screen height (0.0 - 1.0)
  final double? bottom; // Percentage of screen height (0.0 - 1.0)
  final double? left; // Absolute pixels
  final double? right; // Absolute pixels
  final double size; // Circle diameter in pixels
  final Color color;

  const FloatingCircleData({
    this.top,
    this.bottom,
    this.left,
    this.right,
    required this.size,
    required this.color,
  });
}
