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
}
