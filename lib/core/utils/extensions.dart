import 'package:flutter/material.dart';
import 'package:fyllens/core/utils/timestamp_formatter.dart';
import 'package:fyllens/core/utils/timezone_helper.dart';

/// String extensions
extension StringExtensions on String {
  /// Capitalize first letter
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Check if string is a valid email
  bool get isValidEmail {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(this);
  }
}

/// DateTime extensions
///
/// Provides convenient timestamp formatting using TimestampFormatter.
/// All methods assume the DateTime is already in Philippine timezone (Manila time).
extension DateTimeExtensions on DateTime {
  /// Format as readable date (e.g., "Dec 17, 2025")
  ///
  /// Uses TimestampFormatter for consistent Philippine timezone display
  String toReadableDate() {
    return TimestampFormatter.formatDate(this);
  }

  /// Format as readable time (e.g., "8:11 PM")
  ///
  /// Uses TimestampFormatter for consistent Philippine timezone display
  String toReadableTime() {
    return TimestampFormatter.formatTime(this);
  }

  /// Format as "time ago" string (e.g., "2 hours ago", "Yesterday")
  ///
  /// Uses TimestampFormatter which handles negative durations correctly
  String toTimeAgo() {
    return TimestampFormatter.formatAgo(this);
  }

  /// Format as date and time (e.g., "Dec 17, 2025 | 8:11 PM")
  ///
  /// Uses TimestampFormatter for consistent Philippine timezone display
  String toReadableDateTime() {
    return TimestampFormatter.formatDateTime(this);
  }

  /// Format for chat messages (context-aware)
  ///
  /// Returns: "8:11 PM" (today), "Yesterday 8:11 PM", "Mon 8:11 PM", "Dec 17 8:11 PM"
  String toChatTime() {
    return TimestampFormatter.formatChatTime(this);
  }

  /// Convert Manila DateTime to UTC for Supabase
  ///
  /// Use when sending timestamps to Supabase database
  DateTime toUtcFromManila() {
    return TimezoneHelper.manilaToUtc(this);
  }

  /// Convert UTC DateTime to Manila timezone
  ///
  /// Use when receiving timestamps from Supabase database
  DateTime toManilaTime() {
    return TimezoneHelper.toManilaTime(this);
  }
}

/// BuildContext extensions
extension ContextExtensions on BuildContext {
  /// Get screen width
  double get screenWidth => MediaQuery.of(this).size.width;

  /// Get screen height
  double get screenHeight => MediaQuery.of(this).size.height;

  /// Show snackbar
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  /// Get theme
  ThemeData get theme => Theme.of(this);

  /// Get text theme
  TextTheme get textTheme => Theme.of(this).textTheme;
}
