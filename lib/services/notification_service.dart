import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

/// Notification Service - Handles local push notifications
///
/// Manages notification display, scheduling, and platform-specific configuration.
/// Uses flutter_local_notifications for Android/iOS local notifications.
class NotificationService {
  static final NotificationService instance = NotificationService._internal();
  factory NotificationService() => instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  /// Initialize notification service
  Future<void> initialize() async {
    if (_isInitialized) {
      debugPrint('✅ NotificationService: Already initialized');
      return;
    }

    debugPrint('🔔 NotificationService: Initializing...');

    try {
      // Initialize timezone database for scheduling
      tz.initializeTimeZones();

      // Android initialization settings
      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

      // iOS initialization settings
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      // Initialize with settings
      await _notifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      // Create notification channels (Android)
      await _createNotificationChannels();

      // Request permissions
      await _requestPermissions();

      _isInitialized = true;
      debugPrint('✅ NotificationService: Initialized successfully');
    } catch (e, stackTrace) {
      debugPrint('❌ NotificationService: Initialization failed');
      debugPrint('   Error: $e');
      debugPrint('   Stack trace: $stackTrace');
    }
  }

  /// Create notification channels for Android
  Future<void> _createNotificationChannels() async {
    debugPrint('📱 Creating Android notification channels...');

    // High priority channel for critical health alerts
    const highPriorityChannel = AndroidNotificationChannel(
      'high_priority_channel',
      'Health Alerts',
      description: 'Critical plant health notifications',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    );

    // Default channel for reminders and tips
    const defaultChannel = AndroidNotificationChannel(
      'default_channel',
      'Reminders & Tips',
      description: 'Plant care reminders and tips',
      importance: Importance.defaultImportance,
      playSound: true,
    );

    // Low priority channel for engagement notifications
    const lowPriorityChannel = AndroidNotificationChannel(
      'low_priority_channel',
      'Updates',
      description: 'General updates and engagement',
      importance: Importance.low,
      playSound: false,
    );

    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(highPriorityChannel);

    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(defaultChannel);

    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(lowPriorityChannel);

    debugPrint('✅ Notification channels created');
  }

  /// Request notification permissions (iOS & Android 13+)
  Future<bool> _requestPermissions() async {
    debugPrint('🔐 Requesting notification permissions...');

    // iOS permissions
    final iosPlugin = _notifications.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    final iosGranted = await iosPlugin?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Android 13+ permissions
    final androidPlugin = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    final androidGranted = await androidPlugin?.requestNotificationsPermission();

    final granted = (iosGranted ?? true) && (androidGranted ?? true);
    debugPrint(granted
        ? '✅ Notification permissions granted'
        : '⚠️ Notification permissions denied');

    return granted;
  }

  /// Show immediate notification
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    String channelId = 'default_channel',
  }) async {
    if (!_isInitialized) {
      debugPrint('⚠️ NotificationService not initialized, initializing now...');
      await initialize();
    }

    debugPrint('\n🔔 Showing notification:');
    debugPrint('   ID: $id');
    debugPrint('   Title: $title');
    debugPrint('   Body: $body');
    debugPrint('   Channel: $channelId');

    try {
      await _notifications.show(
        id,
        title,
        body,
        _getNotificationDetails(channelId),
        payload: payload,
      );
      debugPrint('✅ Notification shown successfully');
    } catch (e) {
      debugPrint('❌ Failed to show notification: $e');
    }
  }

  /// Schedule notification for future delivery
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
    String channelId = 'default_channel',
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    debugPrint('\n📅 Scheduling notification:');
    debugPrint('   ID: $id');
    debugPrint('   Title: $title');
    debugPrint('   Scheduled for: $scheduledDate');

    try {
      await _notifications.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledDate, tz.local),
        _getNotificationDetails(channelId),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload,
      );
      debugPrint('✅ Notification scheduled successfully');
    } catch (e) {
      debugPrint('❌ Failed to schedule notification: $e');
    }
  }

  /// Cancel a specific notification
  Future<void> cancelNotification(int id) async {
    debugPrint('🚫 Canceling notification: $id');
    await _notifications.cancel(id);
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    debugPrint('🚫 Canceling all notifications');
    await _notifications.cancelAll();
  }

  /// Get notification details based on channel
  NotificationDetails _getNotificationDetails(String channelId) {
    // Determine priority based on channel
    final importance = channelId == 'high_priority_channel'
        ? Importance.high
        : (channelId == 'low_priority_channel'
            ? Importance.low
            : Importance.defaultImportance);

    final priority = channelId == 'high_priority_channel'
        ? Priority.high
        : (channelId == 'low_priority_channel'
            ? Priority.low
            : Priority.defaultPriority);

    return NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        channelId == 'high_priority_channel'
            ? 'Health Alerts'
            : (channelId == 'low_priority_channel'
                ? 'Updates'
                : 'Reminders & Tips'),
        channelDescription: channelId == 'high_priority_channel'
            ? 'Critical plant health notifications'
            : (channelId == 'low_priority_channel'
                ? 'General updates and engagement'
                : 'Plant care reminders and tips'),
        importance: importance,
        priority: priority,
        playSound: channelId != 'low_priority_channel',
        enableVibration: channelId == 'high_priority_channel',
        icon: '@mipmap/ic_launcher',
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: channelId != 'low_priority_channel',
        interruptionLevel: channelId == 'high_priority_channel'
            ? InterruptionLevel.critical
            : InterruptionLevel.active,
      ),
    );
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    debugPrint('\n👆 Notification tapped:');
    debugPrint('   ID: ${response.id}');
    debugPrint('   Payload: ${response.payload}');

    // Payload will be handled by NotificationProvider
    // which will navigate to appropriate screen
  }

  /// Get channel ID for notification type
  String getChannelForType(String notificationType) {
    switch (notificationType) {
      case 'deficiency_alert':
        return 'high_priority_channel';
      case 'rescan_reminder':
      case 'treatment_reminder':
      case 'care_tip':
        return 'default_channel';
      case 'deficiency_resolved':
      case 'healthy_celebration':
      case 'progress_update':
      case 'streak_milestone':
      case 'new_plant_added':
        return 'low_priority_channel';
      default:
        return 'default_channel';
    }
  }
}
