import 'package:flutter/material.dart';

/// Modern icon container with radial gradient glow and depth effects
/// Matches the onboarding screen aesthetic
class ModernIconContainer extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final Color iconColor;
  final Color primaryColor;
  final Color secondaryColor;
  final double containerSize;
  final AnimationController? animationController;

  const ModernIconContainer({
    super.key,
    required this.icon,
    this.iconSize = 80,
    required this.iconColor,
    required this.primaryColor,
    required this.secondaryColor,
    this.containerSize = 200,
    this.animationController,
  });

  @override
  Widget build(BuildContext context) {
    final Widget iconWidget = Container(
      width: containerSize,
      height: containerSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            primaryColor.withValues(alpha: 0.2),
            secondaryColor.withValues(alpha: 0.1),
            Colors.transparent,
          ],
          stops: const [0.0, 0.6, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.3),
            blurRadius: 40,
            spreadRadius: 10,
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: primaryColor.withValues(alpha: 0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Icon(
          icon,
          size: iconSize,
          color: iconColor,
        ),
      ),
    );

    // Add animation if controller provided
    if (animationController != null) {
      return ScaleTransition(
        scale: Tween<double>(begin: 0.8, end: 1.0).animate(
          CurvedAnimation(
            parent: animationController!,
            curve: Curves.elasticOut,
          ),
        ),
        child: iconWidget,
      );
    }

    return iconWidget;
  }
}
