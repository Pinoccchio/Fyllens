import 'dart:convert';
import 'package:fyllens/core/utils/timezone_helper.dart';

/// Message Sender Type
///
/// Identifies whether a message was sent by the user or the AI assistant
enum MessageSender {
  user('user'),
  ai('ai');

  final String value;
  const MessageSender(this.value);

  /// Create MessageSender from string value
  static MessageSender fromString(String value) {
    switch (value.toLowerCase()) {
      case 'user':
        return MessageSender.user;
      case 'ai':
        return MessageSender.ai;
      default:
        throw ArgumentError('Invalid sender type: $value');
    }
  }
}

/// AI Message Model
///
/// Represents a single message in a conversation between user and Fyllens AI.
/// Messages can be from either the user or the AI assistant.
class AIMessage {
  final String id;
  final String conversationId;
  final MessageSender senderType;
  final String messageText;
  final DateTime createdAt;
  final List<String>? quickReplies;
  final Map<String, dynamic>? metadata;

  const AIMessage({
    required this.id,
    required this.conversationId,
    required this.senderType,
    required this.messageText,
    required this.createdAt,
    this.quickReplies,
    this.metadata,
  });

  /// Create AIMessage from Supabase JSON
  factory AIMessage.fromJson(Map<String, dynamic> json) {
    // Parse quick_replies if present
    List<String>? quickReplies;
    if (json['quick_replies'] != null) {
      if (json['quick_replies'] is String) {
        // If stored as JSON string, decode it
        final decoded = jsonDecode(json['quick_replies'] as String);
        quickReplies = (decoded as List).map((e) => e.toString()).toList();
      } else if (json['quick_replies'] is List) {
        // If already a list
        quickReplies =
            (json['quick_replies'] as List).map((e) => e.toString()).toList();
      }
    }

    // Parse metadata if present
    Map<String, dynamic>? metadata;
    if (json['metadata'] != null) {
      if (json['metadata'] is String) {
        metadata =
            jsonDecode(json['metadata'] as String) as Map<String, dynamic>;
      } else if (json['metadata'] is Map) {
        metadata = Map<String, dynamic>.from(json['metadata'] as Map);
      }
    }

    return AIMessage(
      id: json['id'] as String,
      conversationId: json['conversation_id'] as String,
      senderType: MessageSender.fromString(json['sender_type'] as String),
      messageText: json['message_text'] as String,
      // Parse UTC timestamp from Supabase and convert to Manila time
      createdAt: TimezoneHelper.parseUtcToManila(json['created_at'] as String),
      quickReplies: quickReplies,
      metadata: metadata,
    );
  }

  /// Convert AIMessage to Supabase JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversation_id': conversationId,
      'sender_type': senderType.value,
      'message_text': messageText,
      'created_at': createdAt.toIso8601String(),
      if (quickReplies != null) 'quick_replies': jsonEncode(quickReplies),
      if (metadata != null) 'metadata': jsonEncode(metadata),
    };
  }

  /// Create a copy with updated fields
  AIMessage copyWith({
    String? id,
    String? conversationId,
    MessageSender? senderType,
    String? messageText,
    DateTime? createdAt,
    List<String>? quickReplies,
    Map<String, dynamic>? metadata,
  }) {
    return AIMessage(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      senderType: senderType ?? this.senderType,
      messageText: messageText ?? this.messageText,
      createdAt: createdAt ?? this.createdAt,
      quickReplies: quickReplies ?? this.quickReplies,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Check if this is a user message
  bool get isUser => senderType == MessageSender.user;

  /// Check if this is an AI message
  bool get isAI => senderType == MessageSender.ai;

  @override
  String toString() {
    return 'AIMessage(id: $id, sender: ${senderType.value}, text: ${messageText.length > 50 ? '${messageText.substring(0, 50)}...' : messageText})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AIMessage && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
