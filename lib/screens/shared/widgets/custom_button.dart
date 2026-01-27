import 'package:flutter/material.dart';
import 'package:fyllens/core/theme/app_colors.dart';
import 'package:fyllens/core/theme/app_text_styles.dart';
import 'package:fyllens/core/constants/app_spacing.dart';
import 'package:fyllens/core/theme/app_gradients.dart';

/// Custom button widget - "Organic Luxury" Design System
///
/// A premium button component with:
/// - Gold accent primary style (warm CTA)
/// - Sage green secondary style
/// - Pill shape with subtle shadows
/// - Press animations with spring bounce
/// - Loading state with custom indicator
enum ButtonVariant {
  /// Gold accent - primary CTAs (recommended for main actions)
  primary,

  /// Sage green - secondary actions
  secondary,

  /// Outlined - tertiary actions
  outlined,

  /// Ghost - minimal visual weight
  ghost,
}

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final ButtonVariant variant;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final IconData? icon;
  final bool iconLeading;
  final bool fullWidth;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.variant = ButtonVariant.primary,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.icon,
    this.iconLeading = true,
    this.fullWidth = true,
  });

  /// Convenience constructors
  const CustomButton.primary({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.width,
    this.height,
    this.icon,
    this.iconLeading = true,
    this.fullWidth = true,
  })  : variant = ButtonVariant.primary,
        backgroundColor = null,
        textColor = null;

  const CustomButton.secondary({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.width,
    this.height,
    this.icon,
    this.iconLeading = true,
    this.fullWidth = true,
  })  : variant = ButtonVariant.secondary,
        backgroundColor = null,
        textColor = null;

  const CustomButton.outlined({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.width,
    this.height,
    this.icon,
    this.iconLeading = true,
    this.fullWidth = true,
  })  : variant = ButtonVariant.outlined,
        backgroundColor = null,
        textColor = null;

  const CustomButton.ghost({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.width,
    this.height,
    this.icon,
    this.iconLeading = true,
    this.fullWidth = true,
  })  : variant = ButtonVariant.ghost,
        backgroundColor = null,
        textColor = null;

  // Legacy support
  factory CustomButton.legacy({
    Key? key,
    required String text,
    required VoidCallback onPressed,
    bool isLoading = false,
    bool isOutlined = false,
    Color? backgroundColor,
    Color? textColor,
    double? width,
  }) {
    return CustomButton(
      key: key,
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      variant: isOutlined ? ButtonVariant.outlined : ButtonVariant.secondary,
      backgroundColor: backgroundColor,
      textColor: textColor,
      width: width,
    );
  }

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (!widget.isLoading) {
      _animationController.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    _animationController.reverse();
  }

  void _handleTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final buttonHeight = widget.height ?? AppSpacing.buttonHeight;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: _handleTapDown,
            onTapUp: _handleTapUp,
            onTapCancel: _handleTapCancel,
            child: SizedBox(
              width: widget.fullWidth ? (widget.width ?? double.infinity) : widget.width,
              height: buttonHeight,
              child: _buildButton(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildButton() {
    switch (widget.variant) {
      case ButtonVariant.primary:
        return _buildPrimaryButton();
      case ButtonVariant.secondary:
        return _buildSecondaryButton();
      case ButtonVariant.outlined:
        return _buildOutlinedButton();
      case ButtonVariant.ghost:
        return _buildGhostButton();
    }
  }

  /// Primary button - Gold accent with forest text
  Widget _buildPrimaryButton() {
    final fgColor = widget.textColor ?? AppColors.textOnGold;

    return Container(
      decoration: BoxDecoration(
        gradient: widget.backgroundColor == null ? AppGradients.gold : null,
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
        boxShadow: widget.isLoading
            ? null
            : [
                BoxShadow(
                  color: AppColors.accentGold.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.isLoading ? null : widget.onPressed,
          borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
          splashColor: Colors.white.withValues(alpha: 0.2),
          highlightColor: Colors.white.withValues(alpha: 0.1),
          child: _buildButtonContent(fgColor),
        ),
      ),
    );
  }

  /// Secondary button - Sage green
  Widget _buildSecondaryButton() {
    final bgColor = widget.backgroundColor ?? AppColors.primarySage;
    final fgColor = widget.textColor ?? AppColors.textOnPrimary;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
        boxShadow: widget.isLoading
            ? null
            : [
                BoxShadow(
                  color: AppColors.primarySage.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.isLoading ? null : widget.onPressed,
          borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
          splashColor: Colors.white.withValues(alpha: 0.2),
          highlightColor: Colors.white.withValues(alpha: 0.1),
          child: _buildButtonContent(fgColor),
        ),
      ),
    );
  }

  /// Outlined button - Transparent with border
  Widget _buildOutlinedButton() {
    final fgColor = widget.textColor ?? AppColors.primarySage;

    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
        border: Border.all(
          color: AppColors.borderLight,
          width: AppSpacing.borderThin,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.isLoading ? null : widget.onPressed,
          borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
          splashColor: AppColors.primarySage.withValues(alpha: 0.1),
          highlightColor: AppColors.primarySage.withValues(alpha: 0.05),
          child: _buildButtonContent(fgColor),
        ),
      ),
    );
  }

  /// Ghost button - Minimal visual weight
  Widget _buildGhostButton() {
    final fgColor = widget.textColor ?? AppColors.primarySage;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.isLoading ? null : widget.onPressed,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        splashColor: AppColors.primarySage.withValues(alpha: 0.1),
        highlightColor: AppColors.primarySage.withValues(alpha: 0.05),
        child: _buildButtonContent(fgColor),
      ),
    );
  }

  Widget _buildButtonContent(Color foregroundColor) {
    if (widget.isLoading) {
      return Center(
        child: SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
          ),
        ),
      );
    }

    final textWidget = Text(
      widget.text,
      style: AppTextStyles.buttonLarge.copyWith(color: foregroundColor),
    );

    if (widget.icon == null) {
      return Center(child: textWidget);
    }

    final iconWidget = Icon(
      widget.icon,
      color: foregroundColor,
      size: AppSpacing.iconSm,
    );

    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: widget.iconLeading
            ? [
                iconWidget,
                const SizedBox(width: AppSpacing.sm),
                textWidget,
              ]
            : [
                textWidget,
                const SizedBox(width: AppSpacing.sm),
                iconWidget,
              ],
      ),
    );
  }
}

/// Gradient button for special CTAs
class GradientButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final LinearGradient? gradient;
  final double? width;
  final double? height;
  final IconData? icon;

  const GradientButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.gradient,
    this.width,
    this.height,
    this.icon,
  });

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: (_) => _animationController.forward(),
            onTapUp: (_) => _animationController.reverse(),
            onTapCancel: () => _animationController.reverse(),
            child: Container(
              width: widget.width ?? double.infinity,
              height: widget.height ?? AppSpacing.buttonHeight,
              decoration: BoxDecoration(
                gradient: widget.gradient ?? AppGradients.goldCoral,
                borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                boxShadow: [
                  BoxShadow(
                    color: (widget.gradient?.colors.first ?? AppColors.accentGold)
                        .withValues(alpha: 0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.isLoading ? null : widget.onPressed,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                  splashColor: Colors.white.withValues(alpha: 0.2),
                  child: Center(
                    child: widget.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (widget.icon != null) ...[
                                Icon(
                                  widget.icon,
                                  color: Colors.white,
                                  size: AppSpacing.iconSm,
                                ),
                                const SizedBox(width: AppSpacing.sm),
                              ],
                              Text(
                                widget.text,
                                style: AppTextStyles.buttonLarge.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
