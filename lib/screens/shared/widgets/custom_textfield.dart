import 'package:flutter/material.dart';
import 'package:fyllens/core/theme/app_colors.dart';
import 'package:fyllens/core/theme/app_text_styles.dart';
import 'package:fyllens/core/constants/app_spacing.dart';
import 'package:fyllens/core/theme/app_icons.dart';

/// Custom TextField widget with Material 3 design
/// Supports prefix icons, password toggle, and modern styling
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
  });

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  bool _isPasswordVisible = false;
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Focus(
          onFocusChange: (hasFocus) {
            setState(() {
              _isFocused = hasFocus;
            });
          },
          child: Container(
            height: widget.maxLines == 1 ? AppSpacing.inputHeight : null,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              boxShadow: _isFocused
                  ? [
                      BoxShadow(
                        color: AppColors.primaryGreen.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: TextField(
              controller: widget.controller,
              obscureText: widget.obscureText && !_isPasswordVisible,
              enabled: widget.enabled,
              keyboardType: widget.keyboardType,
              maxLines: widget.maxLines,
              onChanged: widget.onChanged,
              style: AppTextStyles.inputText,
              cursorColor: AppColors.primaryGreen,
              decoration: InputDecoration(
                // Prefix icon
                prefixIcon: widget.prefixIcon != null
                    ? Padding(
                        padding: const EdgeInsets.only(
                          left: AppSpacing.md,
                          right: AppSpacing.sm,
                        ),
                        child: widget.prefixIcon,
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
                          color: AppColors.iconSecondary,
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

                // Filled style (Material 3)
                filled: true,
                fillColor: widget.enabled
                    ? AppColors.surfaceGray
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

                // Border styling
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  borderSide: BorderSide(
                    color: hasError
                        ? AppColors.borderError
                        : Colors.transparent,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  borderSide: BorderSide(
                    color: hasError
                        ? AppColors.borderError
                        : AppColors.borderFocused,
                    width: 2,
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
                  borderSide: const BorderSide(
                    color: AppColors.borderError,
                    width: 1,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  borderSide: const BorderSide(
                    color: AppColors.borderError,
                    width: 2,
                  ),
                ),
              ),
            ),
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
