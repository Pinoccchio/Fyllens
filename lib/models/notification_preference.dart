import 'package:fyllens/core/utils/timezone_helper.dart';

/// Notification Preference model - User's notification settings
///
/// Stores user preferences for which notifications to receive and when.
/// Maps to the `notification_preferences` table in Supabase.
class NotificationPreference {
  final String id;
  final String userId;

  // Feature toggles
  final bool healthAlertsEnabled;
  final bool careRemindersEnabled;
  final bool progressNotificationsEnabled;
  final bool educationalTipsEnabled;
  final bool engagementNotificationsEnabled;

  // Timing preferences
  final int reminderFrequencyDays;
  final int treatmentFollowupDays;

  // Quiet hours
  final bool quietHoursEnabled;
  final String? quietHoursStart; // "21:00:00" format
  final String? quietHoursEnd; // "08:00:00" format

  // Metadata
  final DateTime createdAt;
  final DateTime? updatedAt;

  NotificationPreference({
    required this.id,
    required this.userId,
    this.healthAlertsEnabled = true,
    this.careRemindersEnabled = true,
    this.progressNotificationsEnabled = true,
    this.educationalTipsEnabled = true,
    this.engagementNotificationsEnabled = false,
    this.reminderFrequencyDays = 7,
    this.treatmentFollowupDays = 3,
    this.quietHoursEnabled = false,
    this.quietHoursStart,
    this.quietHoursEnd,
    required this.createdAt,
    this.updatedAt,
  });

  /// Create from JSON (from Supabase)
  factory NotificationPreference.fromJson(Map<String, dynamic> json) {
    return NotificationPreference(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      healthAlertsEnabled: json['health_alerts_enabled'] as bool? ?? true,
      careRemindersEnabled: json['care_reminders_enabled'] as bool? ?? true,
      progressNotificationsEnabled:
          json['progress_notifications_enabled'] as bool? ?? true,
      educationalTipsEnabled:
          json['educational_tips_enabled'] as bool? ?? true,
      engagementNotificationsEnabled:
          json['engagement_notifications_enabled'] as bool? ?? false,
      reminderFrequencyDays: json['reminder_frequency_days'] as int? ?? 7,
      treatmentFollowupDays: json['treatment_followup_days'] as int? ?? 3,
      quietHoursEnabled: json['quiet_hours_enabled'] as bool? ?? false,
      quietHoursStart: json['quiet_hours_start'] as String?,
      quietHoursEnd: json['quiet_hours_end'] as String?,
      // Parse UTC timestamps from Supabase and convert to Manila time
      createdAt: TimezoneHelper.parseUtcToManila(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? TimezoneHelper.parseUtcToManila(json['updated_at'] as String)
          : null,
    );
  }

  /// Convert to JSON (for Supabase)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'health_alerts_enabled': healthAlertsEnabled,
      'care_reminders_enabled': careRemindersEnabled,
      'progress_notifications_enabled': progressNotificationsEnabled,
      'educational_tips_enabled': educationalTipsEnabled,
      'engagement_notifications_enabled': engagementNotificationsEnabled,
      'reminder_frequency_days': reminderFrequencyDays,
      'treatment_followup_days': treatmentFollowupDays,
      'quiet_hours_enabled': quietHoursEnabled,
      'quiet_hours_start': quietHoursStart,
      'quiet_hours_end': quietHoursEnd,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Create copy with updated fields
  NotificationPreference copyWith({
    String? id,
    String? userId,
    bool? healthAlertsEnabled,
    bool? careRemindersEnabled,
    bool? progressNotificationsEnabled,
    bool? educationalTipsEnabled,
    bool? engagementNotificationsEnabled,
    int? reminderFrequencyDays,
    int? treatmentFollowupDays,
    bool? quietHoursEnabled,
    String? quietHoursStart,
    String? quietHoursEnd,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NotificationPreference(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      healthAlertsEnabled: healthAlertsEnabled ?? this.healthAlertsEnabled,
      careRemindersEnabled: careRemindersEnabled ?? this.careRemindersEnabled,
      progressNotificationsEnabled:
          progressNotificationsEnabled ?? this.progressNotificationsEnabled,
      educationalTipsEnabled:
          educationalTipsEnabled ?? this.educationalTipsEnabled,
      engagementNotificationsEnabled: engagementNotificationsEnabled ??
          this.engagementNotificationsEnabled,
      reminderFrequencyDays:
          reminderFrequencyDays ?? this.reminderFrequencyDays,
      treatmentFollowupDays:
          treatmentFollowupDays ?? this.treatmentFollowupDays,
      quietHoursEnabled: quietHoursEnabled ?? this.quietHoursEnabled,
      quietHoursStart: quietHoursStart ?? this.quietHoursStart,
      quietHoursEnd: quietHoursEnd ?? this.quietHoursEnd,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Check if current time is within quiet hours
  bool get isQuietHoursActive {
    if (!quietHoursEnabled ||
        quietHoursStart == null ||
        quietHoursEnd == null) {
      return false;
    }

    final now = DateTime.now();
    final currentTime = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';

    // Handle quiet hours that span midnight
    if (quietHoursStart!.compareTo(quietHoursEnd!) > 0) {
      return currentTime.compareTo(quietHoursStart!) >= 0 ||
          currentTime.compareTo(quietHoursEnd!) < 0;
    } else {
      return currentTime.compareTo(quietHoursStart!) >= 0 &&
          currentTime.compareTo(quietHoursEnd!) < 0;
    }
  }

  @override
  String toString() {
    return 'NotificationPreference(userId: $userId, healthAlerts: $healthAlertsEnabled, reminders: $careRemindersEnabled)';
  }
}
