import 'package:intl/intl.dart';
import 'package:fyllens/core/utils/timezone_helper.dart';

/// Unified timestamp formatting utilities
///
/// Provides consistent date/time display across the entire app.
/// All timestamps are displayed in Philippine timezone (Asia/Manila).
///
/// This replaces inconsistent formatting like:
/// - "Jan 15, 2024" (scan_result_card.dart)
/// - "Dec 17, 2025 | 8:11 PM" (history_screen.dart)
/// - Custom relative time in message_bubble.dart
///
/// Usage:
/// ```dart
/// final timeAgo = TimestampFormatter.formatAgo(scanResult.createdAt);
/// final date = TimestampFormatter.formatDate(scanResult.createdAt);
/// final dateTime = TimestampFormatter.formatDateTime(scanResult.createdAt);
/// ```
class TimestampFormatter {
  /// Format timestamp as "time ago" string
  ///
  /// Returns human-readable relative time like:
  /// - "Just now"
  /// - "2 minutes ago"
  /// - "5 hours ago"
  /// - "Yesterday"
  /// - "3 days ago"
  /// - "Jan 15, 2024" (for dates > 7 days old)
  ///
  /// **FIXES "-479m ago" BUG**: Always returns positive durations
  ///
  /// Example:
  /// ```dart
  /// final utc = DateTime.parse('2025-12-17T12:11:39Z'); // UTC from Supabase
  /// final manila = TimezoneHelper.toManilaTime(utc);
  /// final ago = TimestampFormatter.formatAgo(manila);
  /// print(ago); // "2 hours ago" (correct Philippine time)
  /// ```
  static String formatAgo(DateTime dateTime) {
    final now = TimezoneHelper.nowInManila();
    final manilaTime = dateTime; // Assume already converted to Manila

    final difference = now.difference(manilaTime);

    // Handle negative durations (future timestamps - shouldn't happen but handle gracefully)
    if (difference.isNegative) {
      return 'Just now'; // Default to "Just now" instead of showing negative time
    }

    final seconds = difference.inSeconds;
    final minutes = difference.inMinutes;
    final hours = difference.inHours;
    final days = difference.inDays;

    if (seconds < 10) {
      return 'Just now';
    } else if (seconds < 60) {
      return '$seconds seconds ago';
    } else if (minutes == 1) {
      return '1 minute ago';
    } else if (minutes < 60) {
      return '$minutes minutes ago';
    } else if (hours == 1) {
      return '1 hour ago';
    } else if (hours < 24) {
      return '$hours hours ago';
    } else if (days == 1) {
      return 'Yesterday';
    } else if (days < 7) {
      return '$days days ago';
    } else {
      // For dates older than 7 days, show formatted date
      return formatDate(manilaTime);
    }
  }

  /// Format timestamp as date only
  ///
  /// Returns: "Jan 15, 2024"
  ///
  /// Example:
  /// ```dart
  /// final formatted = TimestampFormatter.formatDate(scanResult.createdAt);
  /// print(formatted); // "Dec 17, 2025"
  /// ```
  static String formatDate(DateTime dateTime) {
    return DateFormat('MMM dd, yyyy').format(dateTime);
  }

  /// Format timestamp as date and time
  ///
  /// Returns: "Dec 17, 2025 | 8:11 PM"
  ///
  /// Example:
  /// ```dart
  /// final formatted = TimestampFormatter.formatDateTime(scanResult.createdAt);
  /// print(formatted); // "Dec 17, 2025 | 8:11 PM"
  /// ```
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('MMM dd, yyyy | h:mm a').format(dateTime);
  }

  /// Format timestamp as time only
  ///
  /// Returns: "8:11 PM"
  ///
  /// Example:
  /// ```dart
  /// final formatted = TimestampFormatter.formatTime(message.createdAt);
  /// print(formatted); // "8:11 PM"
  /// ```
  static String formatTime(DateTime dateTime) {
    return DateFormat('h:mm a').format(dateTime);
  }

  /// Format timestamp for chat messages
  ///
  /// Returns context-aware formatting:
  /// - Today: "8:11 PM"
  /// - Yesterday: "Yesterday 8:11 PM"
  /// - This week: "Mon 8:11 PM"
  /// - Older: "Dec 17 8:11 PM"
  ///
  /// Example:
  /// ```dart
  /// final formatted = TimestampFormatter.formatChatTime(message.createdAt);
  /// print(formatted); // "8:11 PM" (if today)
  /// ```
  static String formatChatTime(DateTime dateTime) {
    final now = TimezoneHelper.nowInManila();
    final manilaTime = dateTime;

    // Check if same day
    if (now.year == manilaTime.year &&
        now.month == manilaTime.month &&
        now.day == manilaTime.day) {
      return formatTime(manilaTime);
    }

    // Check if yesterday
    final yesterday = now.subtract(const Duration(days: 1));
    if (yesterday.year == manilaTime.year &&
        yesterday.month == manilaTime.month &&
        yesterday.day == manilaTime.day) {
      return 'Yesterday ${formatTime(manilaTime)}';
    }

    // Check if within last 7 days
    final difference = now.difference(manilaTime);
    if (difference.inDays < 7) {
      return DateFormat('EEE h:mm a').format(manilaTime); // "Mon 8:11 PM"
    }

    // Older than 7 days
    return DateFormat('MMM d h:mm a').format(manilaTime); // "Dec 17 8:11 PM"
  }

  /// Format timestamp for notifications
  ///
  /// Returns: "2 hours ago" or "Dec 17, 2025 | 8:11 PM" for old notifications
  ///
  /// Example:
  /// ```dart
  /// final formatted = TimestampFormatter.formatNotificationTime(notification.createdAt);
  /// print(formatted); // "2 hours ago"
  /// ```
  static String formatNotificationTime(DateTime dateTime) {
    final now = TimezoneHelper.nowInManila();
    final difference = now.difference(dateTime);

    if (difference.inHours < 24) {
      return formatAgo(dateTime);
    } else {
      return formatDateTime(dateTime);
    }
  }

  /// Format duration in readable form
  ///
  /// Returns: "2h 30m", "45m", "30s"
  ///
  /// Example:
  /// ```dart
  /// final duration = Duration(hours: 2, minutes: 30);
  /// final formatted = TimestampFormatter.formatDuration(duration);
  /// print(formatted); // "2h 30m"
  /// ```
  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return minutes > 0 ? '${hours}h ${minutes}m' : '${hours}h';
    } else if (minutes > 0) {
      return '${minutes}m';
    } else {
      return '${seconds}s';
    }
  }
}
