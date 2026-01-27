import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fyllens/core/theme/app_colors.dart';
import 'package:fyllens/core/theme/app_text_styles.dart';
import 'package:fyllens/core/constants/app_spacing.dart';
import 'package:fyllens/core/theme/app_icons.dart';

/// Custom text field widget - "Organic Luxury" Design System
///
/// A premium text field component featuring:
/// - Warm cream background (#FFF9F5)
/// - Gold accent focus border
/// - Floating labels in serif font
/// - 12px border radius
/// - Smooth focus animation
/// - Error state styling
class CustomTextfield extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final Widget? prefixIcon;
  final String? errorText;
  final TextInputType? keyboardType;
  final bool enabled;
  final int? maxLines;
  final Function(String)? onChanged;
  final String? labelText;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final void Function(String)? onSubmitted;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextfield({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    this.prefixIcon,
    this.errorText,
    this.keyboardType,
    this.enabled = true,
    this.maxLines = 1,
    this.onChanged,
    this.labelText,
    this.textInputAction,
    this.validator,
    this.onSubmitted,
    this.focusNode,
    this.inputFormatters,
  });

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield>
    with SingleTickerProviderStateMixin {
  bool _isPasswordVisible = false;
  bool _isFocused = false;
  late AnimationController _animationController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
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

  void _handleFocusChange(bool hasFocus) {
    setState(() {
      _isFocused = hasFocus;
    });
    if (hasFocus) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Focus(
          onFocusChange: _handleFocusChange,
          child: AnimatedBuilder(
            animation: _glowAnimation,
            builder: (context, child) {
              return Container(
                height: widget.maxLines == 1 ? AppSpacing.inputHeight : null,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  boxShadow: _isFocused
                      ? [
                          BoxShadow(
                            color: (hasError
                                    ? AppColors.error
                                    : AppColors.accentGold)
                                .withValues(alpha: 0.15 * _glowAnimation.value),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: TextFormField(
                  controller: widget.controller,
                  obscureText: widget.obscureText && !_isPasswordVisible,
                  enabled: widget.enabled,
                  keyboardType: widget.keyboardType,
                  maxLines: widget.maxLines,
                  onChanged: widget.onChanged,
                  textInputAction: widget.textInputAction,
                  validator: widget.validator,
                  onFieldSubmitted: widget.onSubmitted,
                  focusNode: widget.focusNode,
                  inputFormatters: widget.inputFormatters,
                  style: AppTextStyles.inputText,
                  cursorColor: AppColors.accentGold,
                  decoration: InputDecoration(
                    // Label text (floating label)
                    labelText: widget.labelText,
                    labelStyle: AppTextStyles.inputLabel.copyWith(
                      color: _isFocused
                          ? (hasError ? AppColors.error : AppColors.accentGold)
                          : AppColors.textSecondary,
                    ),
                    floatingLabelStyle: GoogleFonts.dmSerifDisplay(
                      color: hasError ? AppColors.error : AppColors.primarySage,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,

                    // Prefix icon
                    prefixIcon: widget.prefixIcon != null
                        ? Padding(
                            padding: const EdgeInsets.only(
                              left: AppSpacing.md,
                              right: AppSpacing.sm,
                            ),
                            child: IconTheme(
                              data: IconThemeData(
                                color: _isFocused
                                    ? (hasError
                                        ? AppColors.error
                                        : AppColors.accentGold)
                                    : AppColors.iconSecondary,
                                size: AppSpacing.iconSm,
                              ),
                              child: widget.prefixIcon!,
                            ),
                          )
                        : null,
                    prefixIconConstraints: const BoxConstraints(
                      minWidth: 48,
                      minHeight: 24,
                    ),

                    // Suffix icon (password toggle)
                    suffixIcon: widget.obscureText
                        ? IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? AppIcons.visibility
                                  : AppIcons.visibilityOff,
                              color: _isFocused
                                  ? AppColors.accentGold
                                  : AppColors.iconSecondary,
                              size: AppSpacing.iconMd,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          )
                        : null,

                    // Hint text
                    hintText: widget.hintText,
                    hintStyle: AppTextStyles.inputHint,

                    // Error text (handled separately below)
                    errorText: null,

                    // Filled style with warm cream
                    filled: true,
                    fillColor: widget.enabled
                        ? AppColors.surfaceCream
                        : AppColors.surfaceGray.withValues(alpha: 0.5),

                    // Content padding
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: widget.prefixIcon != null
                          ? AppSpacing.sm
                          : AppSpacing.md,
                      vertical: widget.maxLines == 1
                          ? AppSpacing.md
                          : AppSpacing.md,
                    ),

                    // Border styling with gold accent
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      borderSide: BorderSide(
                        color: hasError
                            ? AppColors.error.withValues(alpha: 0.5)
                            : Colors.transparent,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      borderSide: BorderSide(
                        color:
                            hasError ? AppColors.error : AppColors.accentGold,
                        width: AppSpacing.borderFocus,
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      borderSide: const BorderSide(
                        color: Colors.transparent,
                        width: 1,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      borderSide: BorderSide(
                        color: AppColors.error.withValues(alpha: 0.5),
                        width: 1,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      borderSide: const BorderSide(
                        color: AppColors.error,
                        width: AppSpacing.borderFocus,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // Error message display
        if (hasError) ...[
          const SizedBox(height: AppSpacing.xs),
          Padding(
            padding: const EdgeInsets.only(left: AppSpacing.md),
            child: Row(
              children: [
                Icon(AppIcons.error, size: 16, color: AppColors.error),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    widget.errorText!,
                    style: AppTextStyles.inputError,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

/// Premium search bar with warm styling
class PremiumSearchBar extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final VoidCallback? onClear;
  final bool autofocus;

  const PremiumSearchBar({
    super.key,
    this.controller,
    this.hintText,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.autofocus = false,
  });

  @override
  State<PremiumSearchBar> createState() => _PremiumSearchBarState();
}

class _PremiumSearchBarState extends State<PremiumSearchBar> {
  late TextEditingController _controller;
  bool _hasText = false;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _hasText = _controller.text.isNotEmpty;
    _controller.addListener(_handleTextChange);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _handleTextChange() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
  }

  void _handleClear() {
    _controller.clear();
    widget.onClear?.call();
    widget.onChanged?.call('');
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (hasFocus) {
        setState(() {
          _isFocused = hasFocus;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: AppColors.surfaceCream,
          borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
          border: Border.all(
            color: _isFocused ? AppColors.accentGold : Colors.transparent,
            width: _isFocused ? AppSpacing.borderFocus : 1,
          ),
          boxShadow: _isFocused
              ? [
                  BoxShadow(
                    color: AppColors.accentGold.withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : AppSpacing.shadowSubtle,
        ),
        child: TextField(
          controller: _controller,
          autofocus: widget.autofocus,
          onChanged: widget.onChanged,
          onSubmitted: widget.onSubmitted,
          style: AppTextStyles.bodyMedium,
          cursorColor: AppColors.accentGold,
          decoration: InputDecoration(
            hintText: widget.hintText ?? 'Search...',
            hintStyle: AppTextStyles.inputHint,
            prefixIcon: Icon(
              Icons.search,
              color: _isFocused ? AppColors.accentGold : AppColors.iconSecondary,
            ),
            suffixIcon: _hasText
                ? IconButton(
                    icon: Icon(
                      Icons.clear,
                      size: 20,
                      color: _isFocused
                          ? AppColors.accentGold
                          : AppColors.iconSecondary,
                    ),
                    onPressed: _handleClear,
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
          ),
        ),
      ),
    );
  }
}
