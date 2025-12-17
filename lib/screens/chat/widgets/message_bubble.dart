import 'package:flutter/material.dart';
import 'package:fyllens/models/ai_message.dart';
import 'package:fyllens/core/theme/app_colors.dart';
import 'package:fyllens/core/theme/app_text_styles.dart';
import 'package:fyllens/core/theme/app_icons.dart';
import 'package:fyllens/core/constants/app_spacing.dart';
import 'package:fyllens/core/utils/timestamp_formatter.dart';

/// Message Bubble Widget
///
/// Displays a single chat message in a bubble UI.
/// Styles differ based on sender (user vs AI):
/// - User messages: Right-aligned, gray background, shows profile picture
/// - AI messages: Left-aligned, green background, shows leaf icon
class MessageBubble extends StatelessWidget {
  final AIMessage message;
  final bool isConsecutive;
  final String? avatarUrl;
  final String? displayName;

  const MessageBubble({
    super.key,
    required this.message,
    this.isConsecutive = false,
    this.avatarUrl,
    this.displayName,
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
                    color: AppColors.textPrimary.withOpacity(0.05),
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

  /// Build avatar - displays profile picture for user, icon for AI
  Widget _buildAvatar(bool isUser) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isUser
            ? AppColors.primaryGreenModern
            : AppColors.primaryGreenModern.withOpacity(0.1),
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.primaryGreenModern.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: ClipOval(
        child: isUser && avatarUrl != null && avatarUrl!.isNotEmpty
            ? Image.network(
                avatarUrl!,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 1.5,
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.primaryGreenModern,
                        ),
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  // Log error and fall back to initials or icon
                  debugPrint('🔴 [CHAT AVATAR ERROR] Failed to load user avatar');
                  debugPrint('   URL: $avatarUrl');
                  debugPrint('   Error: $error');
                  return _buildFallbackAvatar(isUser);
                },
              )
            : _buildFallbackAvatar(isUser),
      ),
    );
  }

  /// Build fallback avatar - logo for AI, initials for user
  Widget _buildFallbackAvatar(bool isUser) {
    if (!isUser) {
      // AI: Show Fyllens logo
      return Padding(
        padding: const EdgeInsets.all(4),
        child: Image.asset(
          'assets/images/fyllens_logo.png',
          fit: BoxFit.contain,
        ),
      );
    }

    // User: Show initials if displayName available, otherwise profile icon
    if (displayName != null && displayName!.isNotEmpty) {
      final initials = _getInitials(displayName!);
      return Container(
        color: AppColors.primaryGreenModern,
        child: Center(
          child: Text(
            initials,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      );
    }

    // Default: Profile icon
    return Center(
      child: Icon(
        AppIcons.profile,
        size: 18,
        color: Colors.white,
      ),
    );
  }

  /// Get user initials from display name
  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  /// Format timestamp using TimestampFormatter for consistent Philippine timezone display
  String _formatTimestamp(DateTime dateTime) {
    // Use TimestampFormatter.formatChatTime for chat-specific formatting
    // Returns: "8:11 PM" (today), "Yesterday 8:11 PM", "Mon 8:11 PM", "Dec 17 8:11 PM"
    return TimestampFormatter.formatChatTime(dateTime);
  }
}
