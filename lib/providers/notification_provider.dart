import 'package:flutter/foundation.dart';
import 'package:fyllens/models/notification.dart';
import 'package:fyllens/models/notification_preference.dart';
import 'package:fyllens/services/database_service.dart';
import 'package:fyllens/services/notification_service.dart';

/// Notification Provider - Manages notification state
///
/// Handles loading, creating, updating, and deleting notifications.
/// Integrates with NotificationService for local push notifications
/// and DatabaseService for persistence.
class NotificationProvider with ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService.instance;
  final NotificationService _notificationService = NotificationService.instance;

  List<AppNotification> _notifications = [];
  NotificationPreference? _preferences;
  bool _isLoading = false;
  String? _errorMessage;

  List<AppNotification> get notifications => _notifications;
  NotificationPreference? get preferences => _preferences;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Get unread notification count
  int get unreadCount =>
      _notifications.where((n) => !n.isRead).length;

  /// Load notifications for user
  Future<void> loadNotifications(String userId, {int limit = 50}) async {
    debugPrint('\n🔔 NotificationProvider: Loading notifications...');
    debugPrint('   User ID: $userId');

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final notificationsData = await _databaseService.fetchNotifications(
        userId,
        limit: limit,
      );

      _notifications = notificationsData
          .map((data) => AppNotification.fromJson(data))
          .toList();

      debugPrint('✅ NotificationProvider: Loaded ${_notifications.length} notifications');
      debugPrint('   Unread: $unreadCount');

      _isLoading = false;
      notifyListeners();
    } catch (e, stackTrace) {
      debugPrint('❌ NotificationProvider: Load failed');
      debugPrint('   Error: $e');
      debugPrint('   Stack trace: $stackTrace');
      _errorMessage = _extractErrorMessage(e);
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Create and show notification
  Future<void> createNotification({
    required String userId,
    required String title,
    required String body,
    required String notificationType,
    String? scanId,
    String? plantId,
    String? plantName,
    DateTime? scheduledFor,
    String? actionType,
    Map<String, dynamic>? actionData,
  }) async {
    debugPrint('\n🔔 NotificationProvider: Creating notification...');
    debugPrint('   Type: $notificationType');
    debugPrint('   Title: $title');

    try {
      // Check preferences before creating notification
      if (_preferences != null && !_shouldSendNotification(notificationType)) {
        debugPrint('⚠️ Notification blocked by user preferences');
        return;
      }

      // Check quiet hours
      if (_preferences?.isQuietHoursActive ?? false) {
        debugPrint('⚠️ Quiet hours active, notification blocked');
        return;
      }

      // Save to database
      final notificationData = await _databaseService.createNotification(
        userId: userId,
        title: title,
        body: body,
        notificationType: notificationType,
        scanId: scanId,
        plantId: plantId,
        plantName: plantName,
        scheduledFor: scheduledFor,
        actionType: actionType,
        actionData: actionData,
      );

      final notification = AppNotification.fromJson(notificationData);

      // Add to local list
      _notifications.insert(0, notification);
      notifyListeners();

      // Show local notification
      final notificationId = notification.id.hashCode; // Convert UUID to int
      final channelId = _notificationService.getChannelForType(notificationType);

      if (scheduledFor != null && scheduledFor.isAfter(DateTime.now())) {
        // Schedule for future
        await _notificationService.scheduleNotification(
          id: notificationId,
          title: title,
          body: body,
          scheduledDate: scheduledFor,
          payload: notification.id,
          channelId: channelId,
        );
      } else {
        // Show immediately
        await _notificationService.showNotification(
          id: notificationId,
          title: title,
          body: body,
          payload: notification.id,
          channelId: channelId,
        );
      }

      debugPrint('✅ Notification created and shown');
    } catch (e, stackTrace) {
      debugPrint('❌ Failed to create notification: $e');
      debugPrint('   Stack trace: $stackTrace');
      _errorMessage = _extractErrorMessage(e);
      notifyListeners();
    }
  }

  /// Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    debugPrint('🔔 Marking notification as read: $notificationId');

    try {
      await _databaseService.markNotificationAsRead(notificationId);

      // Update local state
      final index = _notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        _notifications[index] = _notifications[index].copyWith(
          isRead: true,
          readAt: DateTime.now(),
        );
        notifyListeners();
      }

      debugPrint('✅ Notification marked as read');
    } catch (e) {
      debugPrint('❌ Failed to mark as read: $e');
      _errorMessage = _extractErrorMessage(e);
      notifyListeners();
    }
  }

  /// Mark notification as actioned
  Future<void> markAsActioned(String notificationId) async {
    debugPrint('🔔 Marking notification as actioned: $notificationId');

    try {
      await _databaseService.markNotificationAsActioned(notificationId);

      // Update local state
      final index = _notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        _notifications[index] = _notifications[index].copyWith(
          isActioned: true,
          actionedAt: DateTime.now(),
        );
        notifyListeners();
      }

      debugPrint('✅ Notification marked as actioned');
    } catch (e) {
      debugPrint('❌ Failed to mark as actioned: $e');
    }
  }

  /// Delete notification
  Future<void> deleteNotification(String notificationId) async {
    debugPrint('🔔 Deleting notification: $notificationId');

    try {
      await _databaseService.deleteNotification(notificationId);

      // Remove from local state
      _notifications.removeWhere((n) => n.id == notificationId);
      notifyListeners();

      debugPrint('✅ Notification deleted');
    } catch (e) {
      debugPrint('❌ Failed to delete notification: $e');
      _errorMessage = _extractErrorMessage(e);
      notifyListeners();
    }
  }

  /// Load notification preferences
  Future<void> loadPreferences(String userId) async {
    debugPrint('\n🔔 NotificationProvider: Loading preferences...');

    try {
      final preferencesData =
          await _databaseService.getOrCreateNotificationPreferences(userId);

      _preferences = NotificationPreference.fromJson(preferencesData);

      debugPrint('✅ Preferences loaded');
      debugPrint('   Health alerts: ${_preferences!.healthAlertsEnabled}');
      debugPrint('   Care reminders: ${_preferences!.careRemindersEnabled}');
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Failed to load preferences: $e');
    }
  }

  /// Update notification preferences
  Future<void> updatePreferences(
    String userId,
    Map<String, dynamic> updates,
  ) async {
    debugPrint('\n🔔 NotificationProvider: Updating preferences...');

    try {
      final preferencesData = await _databaseService.updateNotificationPreferences(
        userId,
        updates,
      );

      _preferences = NotificationPreference.fromJson(preferencesData);

      debugPrint('✅ Preferences updated');
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Failed to update preferences: $e');
      _errorMessage = _extractErrorMessage(e);
      notifyListeners();
    }
  }

  /// Check if notification should be sent based on preferences
  bool _shouldSendNotification(String notificationType) {
    if (_preferences == null) return true;

    switch (notificationType) {
      case NotificationType.deficiencyAlert:
        return _preferences!.healthAlertsEnabled;
      case NotificationType.rescanReminder:
      case NotificationType.treatmentReminder:
        return _preferences!.careRemindersEnabled;
      case NotificationType.progressUpdate:
      case NotificationType.deficiencyResolved:
        return _preferences!.progressNotificationsEnabled;
      case NotificationType.careTip:
        return _preferences!.educationalTipsEnabled;
      case NotificationType.healthyCelebration:
      case NotificationType.streakMilestone:
      case NotificationType.newPlantAdded:
        return _preferences!.engagementNotificationsEnabled;
      default:
        return true;
    }
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Extract user-friendly error message
  String _extractErrorMessage(Object error) {
    final errorStr = error.toString();
    if (errorStr.startsWith('Exception: ')) {
      return errorStr.substring(11);
    }
    return errorStr;
  }

  /// Group notifications by date
  Map<String, List<AppNotification>> get groupedNotifications {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final thisWeek = today.subtract(const Duration(days: 7));

    final Map<String, List<AppNotification>> grouped = {
      'Today': [],
      'Yesterday': [],
      'This Week': [],
      'Older': [],
    };

    for (final notification in _notifications) {
      final notificationDate = DateTime(
        notification.createdAt.year,
        notification.createdAt.month,
        notification.createdAt.day,
      );

      if (notificationDate.isAtSameMomentAs(today)) {
        grouped['Today']!.add(notification);
      } else if (notificationDate.isAtSameMomentAs(yesterday)) {
        grouped['Yesterday']!.add(notification);
      } else if (notificationDate.isAfter(thisWeek)) {
        grouped['This Week']!.add(notification);
      } else {
        grouped['Older']!.add(notification);
      }
    }

    // Remove empty groups
    grouped.removeWhere((key, value) => value.isEmpty);

    return grouped;
  }
}
