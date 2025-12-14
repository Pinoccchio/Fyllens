import 'package:flutter/material.dart';
import 'package:fyllens/models/ai_message.dart';
import 'package:fyllens/core/theme/app_colors.dart';
import 'package:fyllens/core/theme/app_text_styles.dart';
import 'package:fyllens/core/theme/app_icons.dart';
import 'package:fyllens/core/constants/app_spacing.dart';
import 'package:intl/intl.dart';

/// Message Bubble Widget
///
/// Displays a single chat message in a bubble UI.
/// Styles differ based on sender (user vs AI):
/// - User messages: Right-aligned, gray background
/// - AI messages: Left-aligned, green background
class MessageBubble extends StatelessWidget {
  final AIMessage message;
  final bool isConsecutive;

  const MessageBubble({
    super.key,
    required this.message,
    this.isConsecutive = false,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;

    return Padding(
      padding: EdgeInsets.only(
        bottom: isConsecutive ? AppSpacing.xs : AppSpacing.sm,
      ),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // AI avatar (left side)
          if (!isUser && !isConsecutive) _buildAvatar(isUser),
          if (!isUser && !isConsecutive) const SizedBox(width: AppSpacing.xs),
          if (!isUser && isConsecutive) const SizedBox(width: 32 + AppSpacing.xs),

          // Message bubble
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              decoration: BoxDecoration(
                color: isUser
                    ? AppColors.backgroundSoft
                    : AppColors.primaryGreenModern,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isUser ? 16 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Message text
                  Text(
                    message.messageText,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: isUser ? AppColors.textPrimary : Colors.white,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xs),

                  // Timestamp
                  Text(
                    _formatTimestamp(message.createdAt),
                    style: AppTextStyles.caption.copyWith(
                      color: isUser
                          ? AppColors.textSecondary
                          : Colors.white.withOpacity(0.7),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // User avatar (right side)
          if (isUser && !isConsecutive) const SizedBox(width: AppSpacing.xs),
          if (isUser && !isConsecutive) _buildAvatar(isUser),
          if (isUser && isConsecutive) const SizedBox(width: 32 + AppSpacing.xs),
        ],
      ),
    );
  }

  /// Build avatar
  Widget _buildAvatar(bool isUser) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isUser
            ? AppColors.primaryGreenModern
            : AppColors.primaryGreenModern.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          isUser ? AppIcons.profile : AppIcons.leafFilled,
          size: 18,
          color: isUser ? Colors.white : AppColors.primaryGreenModern,
        ),
      ),
    );
  }

  /// Format timestamp
  String _formatTimestamp(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    // Today: Show time only
    if (difference.inDays == 0) {
      return DateFormat('h:mm a').format(dateTime);
    }

    // Yesterday
    if (difference.inDays == 1) {
      return 'Yesterday ${DateFormat('h:mm a').format(dateTime)}';
    }

    // This week: Show day name
    if (difference.inDays < 7) {
      return DateFormat('EEE h:mm a').format(dateTime);
    }

    // Older: Show date
    return DateFormat('MMM d, h:mm a').format(dateTime);
  }
}
