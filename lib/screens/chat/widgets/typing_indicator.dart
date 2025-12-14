import 'package:flutter/material.dart';
import 'package:fyllens/core/theme/app_colors.dart';
import 'package:fyllens/core/theme/app_text_styles.dart';
import 'package:fyllens/core/theme/app_icons.dart';
import 'package:fyllens/core/constants/app_spacing.dart';

/// Typing Indicator Widget
///
/// Shows an animated "Fyllens AI is typing..." indicator
/// while waiting for AI response.
class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          // AI avatar with Fyllens logo
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.primaryGreenModern.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Image.asset(
                'assets/images/fyllens_logo.png',
                fit: BoxFit.contain,
              ),
            ),
          ),

          const SizedBox(width: AppSpacing.xs),

          // Typing bubble
          Container(
            constraints: const BoxConstraints(minWidth: 60),
            decoration: BoxDecoration(
              color: AppColors.primaryGreenModern.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Fyllens AI is typing',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primaryGreenModern,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                _buildDots(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build animated dots
  Widget _buildDots() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            // Calculate delay for each dot
            final delay = index * 0.3;
            final progress = (_controller.value - delay).clamp(0.0, 1.0);

            // Bounce animation
            final scale = 0.5 + (0.5 * (1 - (progress * 2 - 1).abs()));

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 1.5),
              child: Transform.scale(
                scale: scale,
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreenModern.withOpacity(0.6),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
