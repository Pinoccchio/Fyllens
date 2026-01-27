import 'package:flutter/material.dart';
import 'package:fyllens/core/theme/app_colors.dart';
import 'package:fyllens/core/constants/app_spacing.dart';
import 'package:fyllens/core/theme/app_gradients.dart';

/// Custom card widget - "Organic Luxury" Design System
///
/// A premium card component featuring:
/// - Warm off-white background (#FAF8F5)
/// - Layered shadows for depth
/// - 24px border radius (luxury corners)
/// - Optional gradient overlay
/// - Optional accent border (left, top, or full)
/// - Press animation support
enum CardVariant {
  /// Standard card - warm off-white background
  standard,

  /// Elevated card - white with stronger shadow
  elevated,

  /// Gradient card - with gradient background
  gradient,

  /// Glass card - frosted glass effect
  glass,

  /// Outlined card - with border, no fill
  outlined,
}

enum AccentPosition {
  none,
  left,
  top,
  bottom,
  full,
}

class CustomCard extends StatefulWidget {
  final Widget child;
  final CardVariant variant;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? width;
  final double? height;
  final VoidCallback? onTap;
  final LinearGradient? gradient;
  final Color? backgroundColor;
  final Color? accentColor;
  final AccentPosition accentPosition;
  final double accentWidth;
  final bool enableAnimation;

  const CustomCard({
    super.key,
    required this.child,
    this.variant = CardVariant.standard,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.onTap,
    this.gradient,
    this.backgroundColor,
    this.accentColor,
    this.accentPosition = AccentPosition.none,
    this.accentWidth = 4.0,
    this.enableAnimation = true,
  });

  /// Standard warm card
  const CustomCard.standard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.onTap,
    this.accentColor,
    this.accentPosition = AccentPosition.none,
    this.accentWidth = 4.0,
    this.enableAnimation = true,
  })  : variant = CardVariant.standard,
        gradient = null,
        backgroundColor = null;

  /// Elevated white card
  const CustomCard.elevated({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.onTap,
    this.accentColor,
    this.accentPosition = AccentPosition.none,
    this.accentWidth = 4.0,
    this.enableAnimation = true,
  })  : variant = CardVariant.elevated,
        gradient = null,
        backgroundColor = null;

  /// Gradient card
  const CustomCard.gradient({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.onTap,
    this.gradient,
    this.enableAnimation = true,
  })  : variant = CardVariant.gradient,
        backgroundColor = null,
        accentColor = null,
        accentPosition = AccentPosition.none,
        accentWidth = 4.0;

  /// Glass morphism card
  const CustomCard.glass({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.onTap,
    this.enableAnimation = true,
  })  : variant = CardVariant.glass,
        gradient = null,
        backgroundColor = null,
        accentColor = null,
        accentPosition = AccentPosition.none,
        accentWidth = 4.0;

  /// Outlined card
  const CustomCard.outlined({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.onTap,
    this.accentColor,
    this.enableAnimation = true,
  })  : variant = CardVariant.outlined,
        gradient = null,
        backgroundColor = null,
        accentPosition = AccentPosition.none,
        accentWidth = 4.0;

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

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
    _elevationAnimation = Tween<double>(begin: 0.0, end: -2.0).animate(
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
    if (widget.onTap != null && widget.enableAnimation) {
      _animationController.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.enableAnimation) {
      _animationController.reverse();
    }
    widget.onTap?.call();
  }

  void _handleTapCancel() {
    if (widget.enableAnimation) {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultPadding = const EdgeInsets.all(AppSpacing.cardPadding);

    Widget cardContent = _buildCardContent(defaultPadding);

    // Add accent border if needed
    if (widget.accentPosition != AccentPosition.none && widget.accentColor != null) {
      cardContent = _wrapWithAccent(cardContent);
    }

    if (widget.onTap == null) {
      return Container(
        width: widget.width,
        height: widget.height,
        margin: widget.margin,
        child: cardContent,
      );
    }

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _elevationAnimation.value),
          child: Transform.scale(
            scale: widget.enableAnimation ? _scaleAnimation.value : 1.0,
            child: GestureDetector(
              onTapDown: _handleTapDown,
              onTapUp: _handleTapUp,
              onTapCancel: _handleTapCancel,
              child: Container(
                width: widget.width,
                height: widget.height,
                margin: widget.margin,
                child: cardContent,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCardContent(EdgeInsets defaultPadding) {
    switch (widget.variant) {
      case CardVariant.standard:
        return _buildStandardCard(defaultPadding);
      case CardVariant.elevated:
        return _buildElevatedCard(defaultPadding);
      case CardVariant.gradient:
        return _buildGradientCard(defaultPadding);
      case CardVariant.glass:
        return _buildGlassCard(defaultPadding);
      case CardVariant.outlined:
        return _buildOutlinedCard(defaultPadding);
    }
  }

  Widget _buildStandardCard(EdgeInsets defaultPadding) {
    return Container(
      padding: widget.padding ?? defaultPadding,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? AppColors.surfaceWarm,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        boxShadow: AppSpacing.shadowCard,
      ),
      child: widget.child,
    );
  }

  Widget _buildElevatedCard(EdgeInsets defaultPadding) {
    return Container(
      padding: widget.padding ?? defaultPadding,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: widget.child,
    );
  }

  Widget _buildGradientCard(EdgeInsets defaultPadding) {
    return Container(
      padding: widget.padding ?? defaultPadding,
      decoration: BoxDecoration(
        gradient: widget.gradient ?? AppGradients.forest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        boxShadow: [
          BoxShadow(
            color: (widget.gradient?.colors.first ?? AppColors.primaryForest)
                .withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: widget.child,
    );
  }

  Widget _buildGlassCard(EdgeInsets defaultPadding) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
      child: Container(
        padding: widget.padding ?? defaultPadding,
        decoration: BoxDecoration(
          gradient: AppGradients.glassLight,
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: widget.child,
      ),
    );
  }

  Widget _buildOutlinedCard(EdgeInsets defaultPadding) {
    return Container(
      padding: widget.padding ?? defaultPadding,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        border: Border.all(
          color: AppColors.borderLight,
          width: AppSpacing.borderThin,
        ),
      ),
      child: widget.child,
    );
  }

  Widget _wrapWithAccent(Widget card) {
    switch (widget.accentPosition) {
      case AccentPosition.left:
        return ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
            ),
            child: Row(
              children: [
                Container(
                  width: widget.accentWidth,
                  decoration: BoxDecoration(
                    color: widget.accentColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(AppSpacing.radiusCard),
                      bottomLeft: Radius.circular(AppSpacing.radiusCard),
                    ),
                  ),
                ),
                Expanded(child: card),
              ],
            ),
          ),
        );

      case AccentPosition.top:
        return ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: widget.accentWidth,
                decoration: BoxDecoration(
                  color: widget.accentColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppSpacing.radiusCard),
                    topRight: Radius.circular(AppSpacing.radiusCard),
                  ),
                ),
              ),
              Flexible(child: card),
            ],
          ),
        );

      case AccentPosition.bottom:
        return ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(child: card),
              Container(
                height: widget.accentWidth,
                decoration: BoxDecoration(
                  color: widget.accentColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(AppSpacing.radiusCard),
                    bottomRight: Radius.circular(AppSpacing.radiusCard),
                  ),
                ),
              ),
            ],
          ),
        );

      case AccentPosition.full:
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
            border: Border.all(
              color: widget.accentColor!,
              width: widget.accentWidth,
            ),
          ),
          child: card,
        );

      case AccentPosition.none:
        return card;
    }
  }
}

/// Hero card for prominent sections
class HeroCard extends StatelessWidget {
  final Widget child;
  final LinearGradient? gradient;
  final VoidCallback? onTap;
  final double? height;
  final EdgeInsets? padding;

  const HeroCard({
    super.key,
    required this.child,
    this.gradient,
    this.onTap,
    this.height,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard.gradient(
      gradient: gradient ?? AppGradients.forest,
      padding: padding ?? const EdgeInsets.all(AppSpacing.cardPaddingLg),
      height: height ?? AppSpacing.heroCardHeight,
      onTap: onTap,
      child: child,
    );
  }
}

/// Info card with icon and content
class InfoCard extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final Color? iconBackgroundColor;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final AccentPosition accentPosition;
  final Color? accentColor;

  const InfoCard({
    super.key,
    required this.icon,
    this.iconColor,
    this.iconBackgroundColor,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.accentPosition = AccentPosition.none,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard.standard(
      onTap: onTap,
      accentPosition: accentPosition,
      accentColor: accentColor,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          // Icon container
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: iconBackgroundColor ??
                  (iconColor ?? AppColors.primarySage).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Icon(
              icon,
              color: iconColor ?? AppColors.primarySage,
              size: AppSpacing.iconMd,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    subtitle!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ],
            ),
          ),
          // Trailing widget
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
