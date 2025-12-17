import 'package:timezone/timezone.dart' as tz;

/// Timezone helper utilities for Philippine timezone (Asia/Manila)
///
/// Handles conversion between UTC and Philippine Time (PHT = UTC+8)
/// All timestamps from Supabase are in UTC and need conversion for display.
///
/// Usage:
/// ```dart
/// // Convert UTC DateTime to Manila time
/// final manilaTime = TimezoneHelper.toManilaTime(utcDateTime);
///
/// // Get current Manila time
/// final now = TimezoneHelper.nowInManila();
///
/// // Parse UTC string to Manila DateTime
/// final dt = TimezoneHelper.parseUtcToManila('2025-12-17 12:11:39.092908+00');
/// ```
class TimezoneHelper {
  /// Philippine timezone identifier
  static const String MANILA_TIMEZONE = 'Asia/Manila';

  /// UTC timezone identifier
  static const String UTC_TIMEZONE = 'UTC';

  /// Get TZDateTime location for Manila
  static tz.Location get manilaLocation => tz.getLocation(MANILA_TIMEZONE);

  /// Get TZDateTime location for UTC
  static tz.Location get utcLocation => tz.getLocation(UTC_TIMEZONE);

  /// Convert UTC DateTime to Manila timezone
  ///
  /// Takes a UTC DateTime and returns the equivalent time in Manila timezone.
  /// Manila is UTC+8 (no DST).
  ///
  /// Example:
  /// ```dart
  /// // Input:  2025-12-17 12:11:39 UTC
  /// // Output: 2025-12-17 20:11:39 PHT (8 hours ahead)
  /// final utc = DateTime.parse('2025-12-17 12:11:39Z');
  /// final manila = TimezoneHelper.toManilaTime(utc);
  /// print(manila); // 2025-12-17 20:11:39.000 (Manila time)
  /// ```
  static DateTime toManilaTime(DateTime utcDateTime) {
    // Ensure the input is treated as UTC
    final utc = utcDateTime.toUtc();

    // Convert to Manila TZDateTime
    final manilaTime = tz.TZDateTime.from(utc, manilaLocation);

    // Return as regular DateTime (preserves Manila offset)
    return DateTime(
      manilaTime.year,
      manilaTime.month,
      manilaTime.day,
      manilaTime.hour,
      manilaTime.minute,
      manilaTime.second,
      manilaTime.millisecond,
      manilaTime.microsecond,
    );
  }

  /// Get current time in Manila timezone
  ///
  /// Returns the current moment in Philippine Time.
  ///
  /// **CRITICAL FIX:** Gets UTC time from system, then converts to Manila (UTC+8)
  ///
  /// Example:
  /// ```dart
  /// final now = TimezoneHelper.nowInManila();
  /// print(now); // 2025-12-17 20:15:00.000 (current Manila time)
  /// ```
  static DateTime nowInManila() {
    // Get actual UTC time first, then convert to Manila using timezone package
    // DateTime.now().toUtc() is reliable across all device timezones
    final utcNow = DateTime.now().toUtc();
    final manilaTime = tz.TZDateTime.from(utcNow, manilaLocation);

    return DateTime(
      manilaTime.year,
      manilaTime.month,
      manilaTime.day,
      manilaTime.hour,
      manilaTime.minute,
      manilaTime.second,
      manilaTime.millisecond,
      manilaTime.microsecond,
    );
  }

  /// Parse UTC timestamp string to Manila DateTime
  ///
  /// Takes an ISO 8601 timestamp string (from Supabase) and converts it to Manila time.
  ///
  /// Example:
  /// ```dart
  /// // Supabase returns: "2025-12-17T12:11:39.092908+00:00"
  /// final manila = TimezoneHelper.parseUtcToManila(supabaseTimestamp);
  /// print(manila); // 2025-12-17 20:11:39.092908 (Manila time)
  /// ```
  static DateTime parseUtcToManila(String utcTimestampString) {
    final utc = DateTime.parse(utcTimestampString).toUtc();
    return toManilaTime(utc);
  }

  /// Convert Manila DateTime to UTC
  ///
  /// Takes a DateTime in Manila timezone and converts it to UTC.
  /// Useful when sending timestamps to Supabase.
  ///
  /// Example:
  /// ```dart
  /// // Manila: 2025-12-17 20:11:39
  /// // UTC:    2025-12-17 12:11:39
  /// final utc = TimezoneHelper.manilaToUtc(manilaDateTime);
  /// ```
  static DateTime manilaToUtc(DateTime manilaDateTime) {
    // Create TZDateTime in Manila timezone
    final manila = tz.TZDateTime(
      manilaLocation,
      manilaDateTime.year,
      manilaDateTime.month,
      manilaDateTime.day,
      manilaDateTime.hour,
      manilaDateTime.minute,
      manilaDateTime.second,
      manilaDateTime.millisecond,
      manilaDateTime.microsecond,
    );

    // Convert to UTC
    return manila.toUtc();
  }

  /// Get Manila timezone offset in hours
  ///
  /// Returns: 8 (UTC+8)
  static int getManilaOffsetHours() {
    final manila = tz.TZDateTime.now(manilaLocation);
    return manila.timeZoneOffset.inHours;
  }

  /// Check if timezone database is initialized
  ///
  /// Returns true if timezone data has been loaded.
  /// Call `tz.initializeTimeZones()` in main.dart if false.
  static bool isInitialized() {
    try {
      tz.getLocation(MANILA_TIMEZONE);
      return true;
    } catch (e) {
      return false;
    }
  }
}
