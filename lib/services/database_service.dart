import 'package:fyllens/services/supabase_service.dart';

/// Database service
/// Handles CRUD operations with Supabase database
class DatabaseService {
  static DatabaseService? _instance;
  final SupabaseService _supabaseService;

  DatabaseService._() : _supabaseService = SupabaseService.instance;

  /// Get singleton instance
  static DatabaseService get instance {
    _instance ??= DatabaseService._();
    return _instance!;
  }

  /// Generic method to fetch all records from a table
  Future<List<Map<String, dynamic>>> fetchAll(String tableName) async {
    final response = await _supabaseService.from(tableName).select();
    return List<Map<String, dynamic>>.from(response);
  }

  /// Generic method to fetch a single record by ID
  Future<Map<String, dynamic>?> fetchById(String tableName, String id) async {
    final response = await _supabaseService
        .from(tableName)
        .select()
        .eq('id', id)
        .maybeSingle();
    return response;
  }

  /// Generic method to insert a record
  Future<Map<String, dynamic>> insert(
    String tableName,
    Map<String, dynamic> data,
  ) async {
    final response = await _supabaseService
        .from(tableName)
        .insert(data)
        .select()
        .single();
    return response;
  }

  /// Generic method to update a record
  Future<Map<String, dynamic>> update(
    String tableName,
    String id,
    Map<String, dynamic> data,
  ) async {
    final response = await _supabaseService
        .from(tableName)
        .update(data)
        .eq('id', id)
        .select()
        .single();
    return response;
  }

  /// Generic method to delete a record
  Future<void> delete(String tableName, String id) async {
    await _supabaseService.from(tableName).delete().eq('id', id);
  }

  /// Query with custom filters
  Future<List<Map<String, dynamic>>> query(
    String tableName, {
    String? column,
    dynamic value,
  }) async {
    var query = _supabaseService.from(tableName).select();

    if (column != null && value != null) {
      query = query.eq(column, value);
    }

    final response = await query;
    return List<Map<String, dynamic>>.from(response);
  }

  // ============================================================================
  // AI CHAT METHODS
  // ============================================================================

  /// Get or create conversation for a user
  ///
  /// Returns existing conversation or creates new one if doesn't exist.
  /// Each user has only one conversation for continuous context.
  ///
  /// Parameters:
  /// - [userId]: The user's ID
  ///
  /// Returns:
  /// - Conversation data as Map
  Future<Map<String, dynamic>> getOrCreateConversation(String userId) async {
    print('\n💬 [DATABASE] Getting or creating conversation for user: $userId');

    try {
      // Try to fetch existing conversation
      final existing = await _supabaseService
          .from('ai_conversations')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      if (existing != null) {
        print('   ✅ [DATABASE] Found existing conversation: ${existing['id']}');
        return existing;
      }

      // Create new conversation
      print('   📝 [DATABASE] Creating new conversation...');
      final newConversation = await _supabaseService
          .from('ai_conversations')
          .insert({
            'user_id': userId,
            'title': 'Chat with Fyllens AI',
          })
          .select()
          .single();

      print('   ✅ [DATABASE] Created new conversation: ${newConversation['id']}');
      return newConversation;
    } catch (e) {
      print('   🚨 [DATABASE] Error getting/creating conversation: $e');
      rethrow;
    }
  }

  /// Fetch messages for a conversation
  ///
  /// Returns messages ordered by creation time (oldest first).
  ///
  /// Parameters:
  /// - [conversationId]: The conversation ID
  /// - [limit]: Maximum number of messages to fetch (default: 100)
  ///
  /// Returns:
  /// - List of message data maps
  Future<List<Map<String, dynamic>>> fetchMessages(
    String conversationId, {
    int limit = 100,
  }) async {
    print('\n💬 [DATABASE] Fetching messages for conversation: $conversationId');

    try {
      final messages = await _supabaseService
          .from('ai_messages')
          .select()
          .eq('conversation_id', conversationId)
          .order('created_at', ascending: true)
          .limit(limit);

      print('   ✅ [DATABASE] Fetched ${messages.length} messages');
      return List<Map<String, dynamic>>.from(messages);
    } catch (e) {
      print('   🚨 [DATABASE] Error fetching messages: $e');
      rethrow;
    }
  }

  /// Insert a new message
  ///
  /// Saves a message to the database (user or AI message).
  ///
  /// Parameters:
  /// - [conversationId]: The conversation ID
  /// - [senderType]: 'user' or 'ai'
  /// - [messageText]: The message content
  /// - [quickReplies]: Optional list of quick reply suggestions
  ///
  /// Returns:
  /// - Inserted message data
  Future<Map<String, dynamic>> insertMessage({
    required String conversationId,
    required String senderType,
    required String messageText,
    List<String>? quickReplies,
  }) async {
    print('\n💬 [DATABASE] Inserting $senderType message...');
    print('   Conversation: $conversationId');
    print('   Message length: ${messageText.length} characters');

    try {
      final messageData = {
        'conversation_id': conversationId,
        'sender_type': senderType,
        'message_text': messageText,
        if (quickReplies != null && quickReplies.isNotEmpty)
          'quick_replies': quickReplies,
      };

      final inserted = await _supabaseService
          .from('ai_messages')
          .insert(messageData)
          .select()
          .single();

      print('   ✅ [DATABASE] Message inserted: ${inserted['id']}');
      return inserted;
    } catch (e) {
      print('   🚨 [DATABASE] Error inserting message: $e');
      rethrow;
    }
  }

  /// Delete all messages in a conversation
  ///
  /// Used for "Clear Conversation" feature.
  ///
  /// Parameters:
  /// - [conversationId]: The conversation ID
  Future<void> clearConversation(String conversationId) async {
    print('\n💬 [DATABASE] Clearing conversation: $conversationId');

    try {
      await _supabaseService
          .from('ai_messages')
          .delete()
          .eq('conversation_id', conversationId);

      // Reset message count
      await _supabaseService
          .from('ai_conversations')
          .update({'message_count': 0})
          .eq('id', conversationId);

      print('   ✅ [DATABASE] Conversation cleared');
    } catch (e) {
      print('   🚨 [DATABASE] Error clearing conversation: $e');
      rethrow;
    }
  }

  /// Search messages in a conversation (Phase 2 feature)
  ///
  /// Uses full-text search to find messages containing query text.
  ///
  /// Parameters:
  /// - [conversationId]: The conversation ID
  /// - [query]: Search query text
  ///
  /// Returns:
  /// - List of matching messages
  Future<List<Map<String, dynamic>>> searchMessages(
    String conversationId,
    String query,
  ) async {
    print('\n💬 [DATABASE] Searching messages for: "$query"');

    try {
      final messages = await _supabaseService
          .from('ai_messages')
          .select()
          .eq('conversation_id', conversationId)
          .textSearch('message_text', query)
          .order('created_at', ascending: true);

      print('   ✅ [DATABASE] Found ${messages.length} matching messages');
      return List<Map<String, dynamic>>.from(messages);
    } catch (e) {
      print('   🚨 [DATABASE] Error searching messages: $e');
      rethrow;
    }
  }

  // ============================================================================
  // NOTIFICATION METHODS
  // ============================================================================

  /// Create a new notification
  Future<Map<String, dynamic>> createNotification({
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
    print('\n🔔 [DATABASE] Creating notification for user: $userId');
    print('   Type: $notificationType');
    print('   Title: $title');

    try {
      final notificationData = {
        'user_id': userId,
        'title': title,
        'body': body,
        'notification_type': notificationType,
        if (scanId != null) 'scan_id': scanId,
        if (plantId != null) 'plant_id': plantId,
        if (plantName != null) 'plant_name': plantName,
        if (scheduledFor != null) 'scheduled_for': scheduledFor.toIso8601String(),
        if (actionType != null) 'action_type': actionType,
        if (actionData != null) 'action_data': actionData,
        'sent_at': DateTime.now().toIso8601String(),
      };

      final notification = await _supabaseService
          .from('notifications')
          .insert(notificationData)
          .select()
          .single();

      print('   ✅ [DATABASE] Notification created: ${notification['id']}');
      return notification;
    } catch (e) {
      print('   🚨 [DATABASE] Error creating notification: $e');
      rethrow;
    }
  }

  /// Fetch notifications for a user
  Future<List<Map<String, dynamic>>> fetchNotifications(
    String userId, {
    int limit = 50,
    bool unreadOnly = false,
  }) async {
    print('\n🔔 [DATABASE] Fetching notifications for user: $userId');
    print('   Limit: $limit');
    print('   Unread only: $unreadOnly');

    try {
      var query = _supabaseService
          .from('notifications')
          .select()
          .eq('user_id', userId);

      if (unreadOnly) {
        query = query.eq('is_read', false);
      }

      final notifications = await query
          .order('created_at', ascending: false)
          .limit(limit);

      print('   ✅ [DATABASE] Fetched ${notifications.length} notifications');
      return List<Map<String, dynamic>>.from(notifications);
    } catch (e) {
      print('   🚨 [DATABASE] Error fetching notifications: $e');
      rethrow;
    }
  }

  /// Get unread notification count
  Future<int> getUnreadNotificationCount(String userId) async {
    print('\n🔔 [DATABASE] Getting unread count for user: $userId');

    try {
      final notifications = await _supabaseService
          .from('notifications')
          .select()
          .eq('user_id', userId)
          .eq('is_read', false);

      final count = notifications.length;
      print('   ✅ [DATABASE] Unread count: $count');
      return count;
    } catch (e) {
      print('   🚨 [DATABASE] Error getting unread count: $e');
      return 0;
    }
  }

  /// Mark notification as read
  Future<Map<String, dynamic>> markNotificationAsRead(String notificationId) async {
    print('\n🔔 [DATABASE] Marking notification as read: $notificationId');

    try {
      final notification = await _supabaseService
          .from('notifications')
          .update({
            'is_read': true,
            'read_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', notificationId)
          .select()
          .single();

      print('   ✅ [DATABASE] Notification marked as read');
      return notification;
    } catch (e) {
      print('   🚨 [DATABASE] Error marking notification as read: $e');
      rethrow;
    }
  }

  /// Mark notification as actioned
  Future<Map<String, dynamic>> markNotificationAsActioned(String notificationId) async {
    print('\n🔔 [DATABASE] Marking notification as actioned: $notificationId');

    try {
      final notification = await _supabaseService
          .from('notifications')
          .update({
            'is_actioned': true,
            'actioned_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', notificationId)
          .select()
          .single();

      print('   ✅ [DATABASE] Notification marked as actioned');
      return notification;
    } catch (e) {
      print('   🚨 [DATABASE] Error marking notification as actioned: $e');
      rethrow;
    }
  }

  /// Delete notification
  Future<void> deleteNotification(String notificationId) async {
    print('\n🔔 [DATABASE] Deleting notification: $notificationId');

    try {
      await _supabaseService
          .from('notifications')
          .delete()
          .eq('id', notificationId);

      print('   ✅ [DATABASE] Notification deleted');
    } catch (e) {
      print('   🚨 [DATABASE] Error deleting notification: $e');
      rethrow;
    }
  }

  /// Get or create notification preferences for user
  Future<Map<String, dynamic>> getOrCreateNotificationPreferences(
    String userId,
  ) async {
    print('\n🔔 [DATABASE] Getting notification preferences for user: $userId');

    try {
      // Try to fetch existing preferences
      final existing = await _supabaseService
          .from('notification_preferences')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      if (existing != null) {
        print('   ✅ [DATABASE] Found existing preferences');
        return existing;
      }

      // Create default preferences
      print('   📝 [DATABASE] Creating default preferences...');
      final newPreferences = await _supabaseService
          .from('notification_preferences')
          .insert({'user_id': userId})
          .select()
          .single();

      print('   ✅ [DATABASE] Created default preferences');
      return newPreferences;
    } catch (e) {
      print('   🚨 [DATABASE] Error getting/creating preferences: $e');
      rethrow;
    }
  }

  /// Update notification preferences
  Future<Map<String, dynamic>> updateNotificationPreferences(
    String userId,
    Map<String, dynamic> updates,
  ) async {
    print('\n🔔 [DATABASE] Updating notification preferences for user: $userId');

    try {
      final preferences = await _supabaseService
          .from('notification_preferences')
          .update({
            ...updates,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('user_id', userId)
          .select()
          .single();

      print('   ✅ [DATABASE] Preferences updated');
      return preferences;
    } catch (e) {
      print('   🚨 [DATABASE] Error updating preferences: $e');
      rethrow;
    }
  }
}
