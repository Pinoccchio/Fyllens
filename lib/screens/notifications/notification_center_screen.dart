import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:fyllens/core/theme/app_colors.dart';
import 'package:fyllens/core/theme/app_text_styles.dart';
import 'package:fyllens/core/constants/app_spacing.dart';
import 'package:fyllens/core/constants/app_routes.dart';
import 'package:fyllens/providers/notification_provider.dart';
import 'package:fyllens/providers/scan_provider.dart';
import 'package:fyllens/providers/auth_provider.dart';
import 'package:fyllens/models/notification.dart';
import 'package:fyllens/models/scan_result.dart';
import 'package:fyllens/services/database_service.dart';

/// Notification Center Screen
///
/// Displays all user notifications grouped by date.
/// Features:
/// - Grouped by: Today, Yesterday, This Week, Older
/// - Unread badge indicators
/// - Swipe to delete
/// - Mark as read on tap
/// - Empty state when no notifications
class NotificationCenterScreen extends StatelessWidget {
  const NotificationCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notificationProvider = context.watch<NotificationProvider>();
    final groupedNotifications = notificationProvider.groupedNotifications;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Notifications',
          style: AppTextStyles.heading2.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (notificationProvider.notifications.isNotEmpty)
            TextButton(
              onPressed: () => _showClearAllDialog(context),
              child: Text(
                'Clear All',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.primaryGreenModern,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: notificationProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : notificationProvider.errorMessage != null
              ? _buildErrorState(context, notificationProvider)
              : groupedNotifications.isEmpty
                  ? _buildEmptyState(context)
                  : _buildNotificationList(context, groupedNotifications),
    );
  }

  /// Build notification list grouped by date
  Widget _buildNotificationList(
    BuildContext context,
    Map<String, List<AppNotification>> groupedNotifications,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: groupedNotifications.length,
      itemBuilder: (context, index) {
        final section = groupedNotifications.keys.elementAt(index);
        final notifications = groupedNotifications[section]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section header
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.sm,
              ),
              child: Text(
                section,
                style: AppTextStyles.heading3.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // Notification cards
            ...notifications.map((notification) {
              return _buildNotificationCard(context, notification);
            }),

            const SizedBox(height: AppSpacing.lg),
          ],
        );
      },
    );
  }

  /// Build individual notification card
  Widget _buildNotificationCard(
    BuildContext context,
    AppNotification notification,
  ) {
    final notificationProvider = context.read<NotificationProvider>();

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSpacing.md),
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.delete_outline,
          color: Colors.white,
          size: 28,
        ),
      ),
      confirmDismiss: (direction) async {
        return await _showDeleteDialog(context);
      },
      onDismissed: (direction) {
        notificationProvider.deleteNotification(notification.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Notification deleted'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      },
      child: GestureDetector(
        onTap: () {
          if (!notification.isRead) {
            notificationProvider.markAsRead(notification.id);
          }
          _handleNotificationTap(context, notification);
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: notification.isRead
                ? Colors.transparent
                : AppColors.primaryGreenModern.withOpacity(0.05),
            border: Border.all(
              color: notification.isRead
                  ? AppColors.borderLight
                  : AppColors.primaryGreenModern.withOpacity(0.2),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Notification icon
              _buildNotificationIcon(notification.notificationType),
              const SizedBox(width: AppSpacing.md),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title row with unread indicator
                    Row(
                      children: [
                        if (!notification.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.only(right: AppSpacing.xs),
                            decoration: BoxDecoration(
                              color: AppColors.primaryGreenModern,
                              shape: BoxShape.circle,
                            ),
                          ),
                        Expanded(
                          child: Text(
                            notification.title,
                            style: AppTextStyles.bodyLarge.copyWith(
                              fontWeight: notification.isRead
                                  ? FontWeight.normal
                                  : FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppSpacing.xs),

                    // Body
                    Text(
                      notification.body,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: AppSpacing.xs),

                    // Timestamp
                    Text(
                      notification.timeAgo,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build notification type icon
  Widget _buildNotificationIcon(String notificationType) {
    IconData iconData;
    Color backgroundColor;

    switch (notificationType) {
      case NotificationType.deficiencyAlert:
        iconData = Icons.warning_amber_rounded;
        backgroundColor = AppColors.error.withOpacity(0.1);
        break;
      case NotificationType.rescanReminder:
      case NotificationType.treatmentReminder:
        iconData = Icons.schedule_rounded;
        backgroundColor = AppColors.warning.withOpacity(0.1);
        break;
      case NotificationType.deficiencyResolved:
      case NotificationType.healthyCelebration:
        iconData = Icons.check_circle_rounded;
        backgroundColor = AppColors.success.withOpacity(0.1);
        break;
      case NotificationType.progressUpdate:
        iconData = Icons.trending_up_rounded;
        backgroundColor = AppColors.primaryGreenModern.withOpacity(0.1);
        break;
      case NotificationType.careTip:
        iconData = Icons.lightbulb_outline_rounded;
        backgroundColor = AppColors.warning.withOpacity(0.1);
        break;
      default:
        iconData = Icons.notifications_outlined;
        backgroundColor = AppColors.primaryGreenModern.withOpacity(0.1);
    }

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        iconData,
        color: AppColors.primaryGreenModern,
        size: 24,
      ),
    );
  }

  /// Handle notification tap - navigate based on action type
  Future<void> _handleNotificationTap(
    BuildContext context,
    AppNotification notification,
  ) async {
    debugPrint('🔔 Notification tapped: ${notification.id}');
    debugPrint('   Type: ${notification.notificationType}');
    debugPrint('   Action: ${notification.actionType}');
    debugPrint('   Scan ID: ${notification.scanId}');

    final notificationProvider = context.read<NotificationProvider>();

    // Handle navigation based on notification type
    switch (notification.notificationType) {
      case NotificationType.deficiencyAlert:
      case NotificationType.deficiencyResolved:
      case NotificationType.healthyCelebration:
      case NotificationType.progressUpdate:
        // Navigate to scan result if scan_id exists
        if (notification.scanId != null) {
          await _navigateToScanResult(context, notification);
        } else {
          _showNotificationDetailDialog(context, notification);
        }
        break;

      case NotificationType.rescanReminder:
      case NotificationType.treatmentReminder:
        // Navigate to scan screen or show scan result
        if (notification.scanId != null) {
          await _navigateToScanResult(context, notification);
        } else {
          // Navigate to scan tab
          context.go('${AppRoutes.home}?tab=2'); // Scan is tab index 2
        }
        break;

      case NotificationType.careTip:
      case NotificationType.streakMilestone:
      case NotificationType.newPlantAdded:
        // Show detail dialog for informational notifications
        _showNotificationDetailDialog(context, notification);
        break;

      default:
        _showNotificationDetailDialog(context, notification);
    }

    // Mark as actioned
    await notificationProvider.markAsActioned(notification.id);
  }

  /// Navigate to scan result screen
  Future<void> _navigateToScanResult(
    BuildContext context,
    AppNotification notification,
  ) async {
    try {
      debugPrint('🔍 Loading scan result: ${notification.scanId}');

      // Load scan data from database
      final scanData = await DatabaseService.instance.fetchById(
        'scan_results',
        notification.scanId!,
      );

      if (scanData == null) {
        if (context.mounted) {
          _showErrorDialog(
            context,
            'Scan Not Found',
            'The scan associated with this notification could not be found.',
          );
        }
        return;
      }

      // Import scan result model to parse the data
      final scanResult = ScanResult.fromJson(scanData);

      // Store in scan provider so scan result screen can access it
      if (context.mounted) {
        final scanProvider = context.read<ScanProvider>();
        scanProvider.setCurrentScanResult(scanResult);

        // Navigate to scan result screen
        context.push(AppRoutes.scanResult);
      }
    } catch (e) {
      debugPrint('❌ Error loading scan result: $e');
      if (context.mounted) {
        _showErrorDialog(
          context,
          'Error',
          'Failed to load scan details. Please try again.',
        );
      }
    }
  }

  /// Show notification detail dialog for informational notifications
  void _showNotificationDetailDialog(
    BuildContext context,
    AppNotification notification,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          notification.title,
          style: AppTextStyles.heading3.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Text(
            notification.body,
            style: AppTextStyles.bodyMedium,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Close',
              style: TextStyle(color: AppColors.primaryGreenModern),
            ),
          ),
        ],
      ),
    );
  }

  /// Show error dialog
  void _showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          title,
          style: AppTextStyles.heading3.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.error,
          ),
        ),
        content: Text(
          message,
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'OK',
              style: TextStyle(color: AppColors.primaryGreenModern),
            ),
          ),
        ],
      ),
    );
  }

  /// Build empty state
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none_rounded,
              size: 80,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'No Notifications',
              style: AppTextStyles.heading2.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'You\'re all caught up!\nWe\'ll notify you when there\'s something new.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Build error state
  Widget _buildErrorState(
    BuildContext context,
    NotificationProvider provider,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: AppColors.error,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Error Loading Notifications',
              style: AppTextStyles.heading2.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              provider.errorMessage ?? 'Something went wrong',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            ElevatedButton(
              onPressed: () {
                provider.clearError();
                // Retry loading notifications
                final authProvider = context.read<AuthProvider>();
                final userId = authProvider.currentUser?.id;
                if (userId != null) {
                  provider.loadNotifications(userId);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreenModern,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                  vertical: AppSpacing.md,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  /// Show delete confirmation dialog
  Future<bool> _showDeleteDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Delete Notification',
              style: AppTextStyles.heading3.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              'Are you sure you want to delete this notification?',
              style: AppTextStyles.bodyMedium,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(
                  'Delete',
                  style: TextStyle(color: AppColors.error),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  /// Show clear all confirmation dialog
  Future<void> _showClearAllDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Clear All Notifications',
          style: AppTextStyles.heading3.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to delete all notifications? This cannot be undone.',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Clear All',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final notificationProvider = context.read<NotificationProvider>();
      final notifications = List.from(notificationProvider.notifications);

      for (final notification in notifications) {
        await notificationProvider.deleteNotification(notification.id);
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('All notifications cleared'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    }
  }
}
