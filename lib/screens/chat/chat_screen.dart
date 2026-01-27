import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:fyllens/core/theme/app_colors.dart';
import 'package:fyllens/core/theme/app_text_styles.dart';
import 'package:fyllens/core/theme/app_icons.dart';
import 'package:fyllens/core/theme/app_gradients.dart';
import 'package:fyllens/core/constants/app_spacing.dart';
import 'package:fyllens/core/constants/app_routes.dart';
import 'package:fyllens/providers/chat_provider.dart';
import 'package:fyllens/providers/auth_provider.dart';
import 'package:fyllens/screens/chat/widgets/message_bubble.dart';
import 'package:fyllens/screens/chat/widgets/typing_indicator.dart';
import 'package:fyllens/screens/shared/widgets/leaf_loader.dart';

/// Chat Screen - "Organic Luxury" Design
///
/// Premium AI chat experience with:
/// - Forest gradient app bar
/// - Warm gold user message bubbles
/// - AI avatar with subtle glow
/// - Animated leaf typing indicator
/// - Premium input field styling
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeChat();
    });

    _inputFocusNode.addListener(() {
      setState(() {
        _isInputFocused = _inputFocusNode.hasFocus;
      });
    });

    _messageController.addListener(() {
      setState(() {});
    });
  }

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

    if (mounted && chatProvider.errorMessage != null) {
      _showError('Failed to initialize chat: ${chatProvider.errorMessage}');
    }

    if (mounted) {
      _scrollToBottom();
    }
  }

  Future<void> _sendMessage() async {
    final messageText = _messageController.text.trim();
    if (messageText.isEmpty) return;

    final chatProvider = context.read<ChatProvider>();
    _messageController.clear();

    await chatProvider.sendMessage(messageText);

    if (chatProvider.errorMessage != null) {
      _showError(chatProvider.errorMessage!);
    }

    if (chatProvider.quotaExceeded) {
      _showError('Daily message quota exceeded. Please try again tomorrow.');
    }

    _scrollToBottom();
  }

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

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(AppIcons.error, color: Colors.white, size: 20),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: Text(message)),
            ],
          ),
          backgroundColor: AppColors.statusCritical,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          margin: const EdgeInsets.all(AppSpacing.md),
        ),
      );
    }
  }

  Future<void> _showClearConfirmation() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceWarm,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        ),
        title: Text(
          'Clear Conversation?',
          style: AppTextStyles.heading2.copyWith(
            color: AppColors.primaryForest,
          ),
        ),
        content: Text(
          'This will delete all messages in this conversation. This action cannot be undone.',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.statusCritical,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
            ),
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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: AppGradients.forest,
          ),
        ),
        leading: IconButton(
          icon: Icon(AppIcons.arrowBack, color: Colors.white),
          onPressed: () => context.go(AppRoutes.home),
          tooltip: 'Back to home',
        ),
        title: Row(
          children: [
            // AI Avatar with glow
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accentGold.withValues(alpha: 0.4),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  AppIcons.sparkle,
                  size: 22,
                  color: AppColors.accentGold,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Column(
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
                  style: AppTextStyles.labelSmall.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
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
          // Loading state
          if (chatProvider.isLoading) {
            return const Center(child: LeafLoader(size: 60));
          }

          // Error state
          if (chatProvider.errorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.screenPadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: AppColors.statusCritical.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        AppIcons.error,
                        size: 48,
                        color: AppColors.statusCritical,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      chatProvider.errorMessage!,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    ElevatedButton.icon(
                      onPressed: () {
                        chatProvider.clearError();
                        _initializeChat();
                      },
                      icon: Icon(AppIcons.refresh),
                      label: const Text('Retry'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accentGold,
                        foregroundColor: AppColors.textOnGold,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusPill),
                        ),
                      ),
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

              // Quota warning
              if (chatProvider.quotaExceeded)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.statusWarning.withValues(alpha: 0.15),
                    border: Border(
                      top: BorderSide(
                        color: AppColors.statusWarning.withValues(alpha: 0.3),
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        AppIcons.warning,
                        color: AppColors.statusWarning,
                        size: 18,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: Text(
                          'Daily quota exceeded. Try again tomorrow.',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.statusWarning,
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

  Widget _buildMessageList(ChatProvider chatProvider) {
    if (chatProvider.messages.isEmpty) {
      // Use SingleChildScrollView to handle keyboard appearance
      return SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height * 0.5,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // AI avatar with glow
              Container(
                padding: const EdgeInsets.all(AppSpacing.xl),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primarySage.withValues(alpha: 0.15),
                      AppColors.accentGold.withValues(alpha: 0.1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceWarm,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accentGold.withValues(alpha: 0.2),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Icon(
                    AppIcons.sparkle,
                    size: 48,
                    color: AppColors.accentGold,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Start a conversation',
                style: AppTextStyles.heading2.copyWith(
                  color: AppColors.primaryForest,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Ask me anything about plant care,\ndiseases, or nutrient deficiencies!',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),
              // Suggestion chips
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                alignment: WrapAlignment.center,
                children: [
                  _buildSuggestionChip('How to identify deficiencies?'),
                  _buildSuggestionChip('Best fertilizers for rice'),
                  _buildSuggestionChip('Corn disease symptoms'),
                ],
              ),
            ],
          ),
        ),
      );
    }

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
          avatarUrl: message.isUser ? currentUser?.avatarUrl : null,
          displayName: message.isUser ? currentUser?.fullName : null,
        );
      },
    );
  }

  Widget _buildSuggestionChip(String text) {
    return GestureDetector(
      onTap: () {
        _messageController.text = text;
        _sendMessage();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: AppColors.primarySage.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
          border: Border.all(
            color: AppColors.primarySage.withValues(alpha: 0.2),
          ),
        ),
        child: Text(
          text,
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColors.primarySage,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(ChatProvider chatProvider) {
    final canSend = !chatProvider.isSendingMessage &&
        !chatProvider.quotaExceeded &&
        _messageController.text.trim().isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceWarm,
        boxShadow: [
          BoxShadow(
            color: _isInputFocused
                ? AppColors.accentGold.withValues(alpha: 0.15)
                : Colors.black.withValues(alpha: 0.05),
            blurRadius: _isInputFocused ? 16 : 8,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.md,
      ),
      child: SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Text input
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
                  border: Border.all(
                    color: _isInputFocused
                        ? AppColors.accentGold
                        : AppColors.borderLight,
                    width: _isInputFocused ? 2 : 1,
                  ),
                ),
                child: TextField(
                  controller: _messageController,
                  focusNode: _inputFocusNode,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    hintStyle: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textTertiary,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                  ),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 4,
                  minLines: 1,
                  textCapitalization: TextCapitalization.sentences,
                  enabled: !chatProvider.isSendingMessage &&
                      !chatProvider.quotaExceeded,
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),

            const SizedBox(width: AppSpacing.sm),

            // Send button
            AnimatedContainer(
              duration: AppSpacing.animationFast,
              decoration: BoxDecoration(
                gradient: canSend ? AppGradients.gold : null,
                color: canSend ? null : AppColors.borderLight,
                shape: BoxShape.circle,
                boxShadow: canSend
                    ? [
                        BoxShadow(
                          color: AppColors.accentGold.withValues(alpha: 0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: canSend ? _sendMessage : null,
                  customBorder: const CircleBorder(),
                  child: Container(
                    width: 48,
                    height: 48,
                    alignment: Alignment.center,
                    child: chatProvider.isSendingMessage
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: canSend
                                  ? AppColors.textOnGold
                                  : AppColors.textTertiary,
                            ),
                          )
                        : Icon(
                            AppIcons.send,
                            color: canSend
                                ? AppColors.textOnGold
                                : AppColors.textTertiary,
                            size: 22,
                          ),
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
