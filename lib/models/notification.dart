/// Notification model - Represents an in-app notification
///
/// Stores notification data including title, body, type, and action metadata.
/// Maps to the `notifications` table in Supabase.
class AppNotification {
  final String id;
  final String userId;
  final String title;
  final String body;
  final String notificationType;

  // Related entities
  final String? scanId;
  final String? plantId;
  final String? plantName;

  // State
  final bool isRead;
  final bool isActioned;

  // Timestamps
  final DateTime? scheduledFor;
  final DateTime? sentAt;
  final DateTime? readAt;
  final DateTime? actionedAt;
  final DateTime createdAt;
  final DateTime? updatedAt;

  // Action metadata
  final String? actionType;
  final Map<String, dynamic>? actionData;

  AppNotification({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.notificationType,
    this.scanId,
    this.plantId,
    this.plantName,
    this.isRead = false,
    this.isActioned = false,
    this.scheduledFor,
    this.sentAt,
    this.readAt,
    this.actionedAt,
    required this.createdAt,
    this.updatedAt,
    this.actionType,
    this.actionData,
  });

  /// Create from JSON (from Supabase)
  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      notificationType: json['notification_type'] as String,
      scanId: json['scan_id'] as String?,
      plantId: json['plant_id'] as String?,
      plantName: json['plant_name'] as String?,
      isRead: json['is_read'] as bool? ?? false,
      isActioned: json['is_actioned'] as bool? ?? false,
      scheduledFor: json['scheduled_for'] != null
          ? DateTime.parse(json['scheduled_for'] as String)
          : null,
      sentAt: json['sent_at'] != null
          ? DateTime.parse(json['sent_at'] as String)
          : null,
      readAt: json['read_at'] != null
          ? DateTime.parse(json['read_at'] as String)
          : null,
      actionedAt: json['actioned_at'] != null
          ? DateTime.parse(json['actioned_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      actionType: json['action_type'] as String?,
      actionData: json['action_data'] as Map<String, dynamic>?,
    );
  }

  /// Convert to JSON (for Supabase)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'body': body,
      'notification_type': notificationType,
      'scan_id': scanId,
      'plant_id': plantId,
      'plant_name': plantName,
      'is_read': isRead,
      'is_actioned': isActioned,
      'scheduled_for': scheduledFor?.toIso8601String(),
      'sent_at': sentAt?.toIso8601String(),
      'read_at': readAt?.toIso8601String(),
      'actioned_at': actionedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'action_type': actionType,
      'action_data': actionData,
    };
  }

  /// Create copy with updated fields
  AppNotification copyWith({
    String? id,
    String? userId,
    String? title,
    String? body,
    String? notificationType,
    String? scanId,
    String? plantId,
    String? plantName,
    bool? isRead,
    bool? isActioned,
    DateTime? scheduledFor,
    DateTime? sentAt,
    DateTime? readAt,
    DateTime? actionedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? actionType,
    Map<String, dynamic>? actionData,
  }) {
    return AppNotification(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      body: body ?? this.body,
      notificationType: notificationType ?? this.notificationType,
      scanId: scanId ?? this.scanId,
      plantId: plantId ?? this.plantId,
      plantName: plantName ?? this.plantName,
      isRead: isRead ?? this.isRead,
      isActioned: isActioned ?? this.isActioned,
      scheduledFor: scheduledFor ?? this.scheduledFor,
      sentAt: sentAt ?? this.sentAt,
      readAt: readAt ?? this.readAt,
      actionedAt: actionedAt ?? this.actionedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      actionType: actionType ?? this.actionType,
      actionData: actionData ?? this.actionData,
    );
  }

  /// Check if notification is scheduled for future
  bool get isScheduled => scheduledFor != null && scheduledFor!.isAfter(DateTime.now());

  /// Check if notification was sent
  bool get isSent => sentAt != null;

  /// Get time ago string for display
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${createdAt.month}/${createdAt.day}/${createdAt.year}';
    }
  }

  @override
  String toString() {
    return 'AppNotification(id: $id, type: $notificationType, title: $title, isRead: $isRead)';
  }
}

/// Notification types enum for type safety
class NotificationType {
  static const String deficiencyAlert = 'deficiency_alert';
  static const String rescanReminder = 'rescan_reminder';
  static const String treatmentReminder = 'treatment_reminder';
  static const String deficiencyResolved = 'deficiency_resolved';
  static const String progressUpdate = 'progress_update';
  static const String careTip = 'care_tip';
  static const String healthyCelebration = 'healthy_celebration';
  static const String newPlantAdded = 'new_plant_added';
  static const String streakMilestone = 'streak_milestone';
}

/// Notification action types for navigation
class NotificationActionType {
  static const String openScan = 'open_scan';
  static const String openPlant = 'open_plant';
  static const String navigateScanScreen = 'navigate_scan_screen';
  static const String openChat = 'open_chat';
  static const String openLibrary = 'open_library';
  static const String openHistory = 'open_history';
}
