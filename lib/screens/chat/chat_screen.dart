import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:fyllens/core/theme/app_colors.dart';
import 'package:fyllens/core/theme/app_text_styles.dart';
import 'package:fyllens/core/theme/app_icons.dart';
import 'package:fyllens/core/constants/app_spacing.dart';
import 'package:fyllens/core/constants/app_routes.dart';
import 'package:fyllens/providers/chat_provider.dart';
import 'package:fyllens/providers/auth_provider.dart';
import 'package:fyllens/screens/chat/widgets/message_bubble.dart';
import 'package:fyllens/screens/chat/widgets/typing_indicator.dart';

/// Chat Screen
///
/// Messenger-style chat interface for conversational AI interaction.
/// Features:
/// - Message bubbles for user and AI messages
/// - Text input field with send button
/// - Typing indicator while waiting for AI response
/// - Conversation persistence via Supabase
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _inputFocusNode = FocusNode();
  bool _isInputFocused = false;

  @override
  void initState() {
    super.initState();
    // Initialize chat on first load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeChat();
    });

    // Track focus state for shadow effect
    _inputFocusNode.addListener(() {
      setState(() {
        _isInputFocused = _inputFocusNode.hasFocus;
      });
    });

    // Track text changes to update send button state
    _messageController.addListener(() {
      setState(() {
        // Rebuild to update send button enabled/disabled state
      });
    });
  }

  /// Initialize chat for current user
  Future<void> _initializeChat() async {
    final authProvider = context.read<AuthProvider>();
    final chatProvider = context.read<ChatProvider>();

    final userId = authProvider.currentUser?.id;
    if (userId == null) {
      debugPrint('⚠️  [CHAT] User not authenticated');
      _showError('You must be logged in to use chat');
      return;
    }

    debugPrint('💬 [CHAT] Initializing chat for user: $userId');
    await chatProvider.initialize(userId);

    // Scroll to bottom after messages load
    if (mounted) {
      _scrollToBottom();
    }
  }

  /// Send message to AI
  Future<void> _sendMessage() async {
    final messageText = _messageController.text.trim();
    if (messageText.isEmpty) return;

    final chatProvider = context.read<ChatProvider>();

    // Clear input field immediately
    _messageController.clear();

    // Send message
    await chatProvider.sendMessage(messageText);

    // Scroll to bottom to show new messages
    _scrollToBottom();
  }

  /// Scroll to bottom of message list
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  /// Show error message
  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  /// Show clear conversation confirmation
  Future<void> _showClearConfirmation() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Conversation?'),
        content: const Text(
          'This will delete all messages in this conversation. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
            child: const Text('Clear'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final chatProvider = context.read<ChatProvider>();
      await chatProvider.clearConversation();
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _inputFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(AppIcons.arrowBack, color: Colors.white),
          onPressed: () => context.go(AppRoutes.home),
          tooltip: 'Back to home',
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Fyllens AI',
              style: AppTextStyles.heading3.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Plant Care Assistant',
              style: AppTextStyles.caption.copyWith(
                color: Colors.white70,
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.primaryGreenModern,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(AppIcons.delete, color: Colors.white),
            onPressed: _showClearConfirmation,
            tooltip: 'Clear conversation',
          ),
        ],
      ),
      body: Consumer<ChatProvider>(
        builder: (context, chatProvider, child) {
          // Show loading on initialization
          if (chatProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryGreenModern,
              ),
            );
          }

          // Show error state
          if (chatProvider.errorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      AppIcons.error,
                      size: 64,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      chatProvider.errorMessage!,
                      style: AppTextStyles.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    ElevatedButton(
                      onPressed: () {
                        chatProvider.clearError();
                        _initializeChat();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreenModern,
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          return Column(
            children: [
              // Message list
              Expanded(
                child: _buildMessageList(chatProvider),
              ),

              // Typing indicator
              if (chatProvider.isTyping) const TypingIndicator(),

              // Quota exceeded warning
              if (chatProvider.quotaExceeded)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  color: Colors.orange.shade100,
                  child: Row(
                    children: [
                      Icon(AppIcons.warning, color: Colors.orange, size: 20),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: Text(
                          'Daily quota exceeded. Try again tomorrow.',
                          style: AppTextStyles.caption.copyWith(
                            color: Colors.orange.shade900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Input field
              _buildInputField(chatProvider),
            ],
          );
        },
      ),
    );
  }

  /// Build message list
  Widget _buildMessageList(ChatProvider chatProvider) {
    if (chatProvider.messages.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Modern gradient container for icon
              Container(
                padding: const EdgeInsets.all(AppSpacing.xl),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryGreenModern.withValues(alpha: 0.1),
                      AppColors.accentMint.withValues(alpha: 0.1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Icon(
                  AppIcons.chat,
                  size: 64,
                  color: AppColors.primaryGreenModern,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Start a conversation',
                style: AppTextStyles.heading3.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Ask me anything about plant care, diseases, or nutrient deficiencies!',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    // Get current user data for avatar display
    final authProvider = context.watch<AuthProvider>();
    final currentUser = authProvider.currentUser;

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: chatProvider.messages.length,
      itemBuilder: (context, index) {
        final message = chatProvider.messages[index];
        return MessageBubble(
          message: message,
          isConsecutive: index > 0 &&
              chatProvider.messages[index - 1].senderType ==
                  message.senderType,
          // Pass user profile data for avatar display (only for user messages)
          avatarUrl: message.isUser ? currentUser?.avatarUrl : null,
          displayName: message.isUser ? currentUser?.fullName : null,
        );
      },
    );
  }

  /// Build input field
  Widget _buildInputField(ChatProvider chatProvider) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: _isInputFocused
            ? [
                // Green shadow on focus (modern style)
                BoxShadow(
                  color: AppColors.primaryGreenModern.withValues(alpha: 0.15),
                  blurRadius: 12,
                  offset: const Offset(0, -4),
                ),
              ]
            : [
                // Default shadow when not focused
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Text input
            Expanded(
              child: TextField(
                controller: _messageController,
                focusNode: _inputFocusNode,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(
                      color: AppColors.textSecondary.withOpacity(0.3),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(
                      color: AppColors.textSecondary.withOpacity(0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(
                      color: AppColors.primaryGreenModern,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                ),
                maxLines: 4,
                minLines: 1,
                textCapitalization: TextCapitalization.sentences,
                enabled: !chatProvider.isSendingMessage &&
                    !chatProvider.quotaExceeded,
                onSubmitted: (_) => _sendMessage(),
              ),
            ),

            const SizedBox(width: AppSpacing.sm),

            // Send button
            Material(
              color: chatProvider.isSendingMessage ||
                      chatProvider.quotaExceeded ||
                      _messageController.text.trim().isEmpty
                  ? AppColors.textSecondary.withOpacity(0.3)
                  : AppColors.primaryGreenModern,
              borderRadius: BorderRadius.circular(24),
              child: InkWell(
                onTap: chatProvider.isSendingMessage ||
                        chatProvider.quotaExceeded ||
                        _messageController.text.trim().isEmpty
                    ? null
                    : _sendMessage,
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  width: 48,
                  height: 48,
                  alignment: Alignment.center,
                  child: chatProvider.isSendingMessage
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Icon(
                          AppIcons.send,
                          color: Colors.white,
                          size: 20,
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
