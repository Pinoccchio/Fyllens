import 'package:flutter/foundation.dart';
import 'package:fyllens/models/ai_conversation.dart';
import 'package:fyllens/models/ai_message.dart';
import 'package:fyllens/services/database_service.dart';
import 'package:fyllens/services/gemini_ai_service.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

/// Chat Provider
///
/// Manages the state for the messenger-style chat interface.
/// Handles conversation initialization, message sending/receiving,
/// optimistic updates, and error states.
class ChatProvider extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService.instance;
  final GeminiAIService _geminiService = GeminiAIService.instance;

  // ============================================================================
  // STATE VARIABLES
  // ============================================================================

  /// Current conversation
  AIConversation? _conversation;
  AIConversation? get conversation => _conversation;

  /// Messages in the current conversation
  List<AIMessage> _messages = [];
  List<AIMessage> get messages => List.unmodifiable(_messages);

  /// Active Gemini chat session
  ChatSession? _chatSession;

  /// Loading states
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isSendingMessage = false;
  bool get isSendingMessage => _isSendingMessage;

  bool _isTyping = false;
  bool get isTyping => _isTyping;

  /// Error state
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// Quota exceeded flag
  bool _quotaExceeded = false;
  bool get quotaExceeded => _quotaExceeded;

  // ============================================================================
  // INITIALIZATION
  // ============================================================================

  /// Initialize chat for a user
  ///
  /// Loads or creates the user's conversation and fetches message history.
  ///
  /// Parameters:
  /// - [userId]: The user's ID
  Future<void> initialize(String userId) async {
    print('\n💬 [CHAT_PROVIDER] Initializing chat for user: $userId');

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Get or create conversation
      final conversationData =
          await _databaseService.getOrCreateConversation(userId);
      _conversation = AIConversation.fromJson(conversationData);

      print('   ✅ [CHAT_PROVIDER] Conversation loaded: ${_conversation!.id}');

      // Fetch messages
      await _loadMessages();

      // Start Gemini chat session with history
      await _startChatSession();

      print(
          '   ✅ [CHAT_PROVIDER] Chat initialized with ${_messages.length} messages');
    } catch (e) {
      print('   🚨 [CHAT_PROVIDER] Error initializing chat: $e');
      _errorMessage = 'Failed to initialize chat. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load messages from database
  Future<void> _loadMessages() async {
    if (_conversation == null) return;

    try {
      final messagesData =
          await _databaseService.fetchMessages(_conversation!.id);

      _messages = messagesData
          .map((data) => AIMessage.fromJson(data))
          .toList();

      print('   📨 [CHAT_PROVIDER] Loaded ${_messages.length} messages');
    } catch (e) {
      print('   🚨 [CHAT_PROVIDER] Error loading messages: $e');
      rethrow;
    }
  }

  /// Start Gemini chat session with conversation history
  Future<void> _startChatSession() async {
    try {
      // Build chat history from messages
      final history = _geminiService.buildChatHistory(
        _messages.map((m) => {
          'sender_type': m.senderType.value,
          'message_text': m.messageText,
        }).toList(),
      );

      // Start chat session
      _chatSession = await _geminiService.startConversation(history: history);

      print('   🤖 [CHAT_PROVIDER] Gemini chat session started');
    } catch (e) {
      print('   🚨 [CHAT_PROVIDER] Error starting chat session: $e');
      rethrow;
    }
  }

  // ============================================================================
  // MESSAGE SENDING
  // ============================================================================

  /// Send a message from the user
  ///
  /// Performs optimistic update (shows user message immediately),
  /// sends to Gemini AI, and updates database.
  ///
  /// Parameters:
  /// - [messageText]: The user's message
  Future<void> sendMessage(String messageText) async {
    if (messageText.trim().isEmpty) {
      print('   ⚠️ [CHAT_PROVIDER] Empty message, skipping');
      return;
    }

    if (_conversation == null || _chatSession == null) {
      print('   🚨 [CHAT_PROVIDER] Chat not initialized');
      _errorMessage = 'Chat not initialized. Please try again.';
      notifyListeners();
      return;
    }

    print('\n💬 [CHAT_PROVIDER] Sending message: ${messageText.substring(0, messageText.length > 50 ? 50 : messageText.length)}...');

    _isSendingMessage = true;
    _errorMessage = null;
    _quotaExceeded = false;
    notifyListeners();

    try {
      // 1. Optimistic update: Add user message to UI immediately
      final tempUserMessage = AIMessage(
        id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
        conversationId: _conversation!.id,
        senderType: MessageSender.user,
        messageText: messageText.trim(),
        createdAt: DateTime.now(),
      );

      _messages.add(tempUserMessage);
      notifyListeners();

      // 2. Save user message to database
      final userMessageData = await _databaseService.insertMessage(
        conversationId: _conversation!.id,
        senderType: 'user',
        messageText: messageText.trim(),
      );

      // Replace temp message with real message from DB
      _messages.removeLast();
      _messages.add(AIMessage.fromJson(userMessageData));
      notifyListeners();

      print('   ✅ [CHAT_PROVIDER] User message saved');

      // 3. Show typing indicator
      _isTyping = true;
      notifyListeners();

      // 4. Send to Gemini and get response
      final aiResponse = await _geminiService.sendChatMessage(
        chatSession: _chatSession!,
        message: messageText.trim(),
      );

      print('   🤖 [CHAT_PROVIDER] Received AI response: ${aiResponse.substring(0, aiResponse.length > 50 ? 50 : aiResponse.length)}...');

      // 5. Hide typing indicator
      _isTyping = false;
      notifyListeners();

      // 6. Save AI response to database
      final aiMessageData = await _databaseService.insertMessage(
        conversationId: _conversation!.id,
        senderType: 'ai',
        messageText: aiResponse,
      );

      // 7. Add AI message to UI
      _messages.add(AIMessage.fromJson(aiMessageData));

      print('   ✅ [CHAT_PROVIDER] AI message saved and displayed');
    } on GenerativeAIException catch (e) {
      print('   🚨 [CHAT_PROVIDER] Gemini API error: $e');

      // Check if quota exceeded
      if (e.message.toLowerCase().contains('quota') ||
          e.message.toLowerCase().contains('resource exhausted')) {
        _quotaExceeded = true;
        _errorMessage =
            'Daily quota exceeded. Please try again tomorrow or upgrade your Gemini API plan.';
      } else {
        _errorMessage = 'AI service error: ${e.message}';
      }

      _isTyping = false;
    } catch (e) {
      print('   🚨 [CHAT_PROVIDER] Error sending message: $e');
      _errorMessage = 'Failed to send message. Please try again.';
      _isTyping = false;
    } finally {
      _isSendingMessage = false;
      notifyListeners();
    }
  }

  // ============================================================================
  // CONVERSATION MANAGEMENT
  // ============================================================================

  /// Clear the conversation (delete all messages)
  Future<void> clearConversation() async {
    if (_conversation == null) {
      print('   🚨 [CHAT_PROVIDER] No conversation to clear');
      return;
    }

    print('\n💬 [CHAT_PROVIDER] Clearing conversation: ${_conversation!.id}');

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Delete all messages from database
      await _databaseService.clearConversation(_conversation!.id);

      // Clear local messages
      _messages.clear();

      // Restart chat session with empty history
      await _startChatSession();

      print('   ✅ [CHAT_PROVIDER] Conversation cleared');
    } catch (e) {
      print('   🚨 [CHAT_PROVIDER] Error clearing conversation: $e');
      _errorMessage = 'Failed to clear conversation. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load more messages (for pagination)
  ///
  /// Phase 2 feature: Implement lazy loading for long conversations
  Future<void> loadMoreMessages() async {
    // TODO: Implement pagination if needed
    // For now, we load all messages on initialization (limit 100)
    print('   ℹ️ [CHAT_PROVIDER] loadMoreMessages not yet implemented');
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    _quotaExceeded = false;
    notifyListeners();
  }

  // ============================================================================
  // LIFECYCLE
  // ============================================================================

  @override
  void dispose() {
    print('\n💬 [CHAT_PROVIDER] Disposing chat provider');
    _chatSession = null;
    super.dispose();
  }
}
