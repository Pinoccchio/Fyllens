import 'package:fyllens/core/utils/timezone_helper.dart';

/// AI Conversation Model
///
/// Represents a chat conversation thread between a user and Fyllens AI.
/// Each user has one persistent conversation for continuous context.
class AIConversation {
  final String id;
  final String userId;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int messageCount;

  const AIConversation({
    required this.id,
    required this.userId,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    required this.messageCount,
  });

  /// Create AIConversation from Supabase JSON
  factory AIConversation.fromJson(Map<String, dynamic> json) {
    return AIConversation(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String? ?? 'Chat with Fyllens AI',
      // Parse UTC timestamps from Supabase and convert to Manila time
      createdAt: TimezoneHelper.parseUtcToManila(json['created_at'] as String),
      updatedAt: TimezoneHelper.parseUtcToManila(json['updated_at'] as String),
      messageCount: json['message_count'] as int? ?? 0,
    );
  }

  /// Convert AIConversation to Supabase JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'message_count': messageCount,
    };
  }

  /// Create a copy with updated fields
  AIConversation copyWith({
    String? id,
    String? userId,
    String? title,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? messageCount,
  }) {
    return AIConversation(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      messageCount: messageCount ?? this.messageCount,
    );
  }

  @override
  String toString() {
    return 'AIConversation(id: $id, userId: $userId, title: $title, messageCount: $messageCount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AIConversation && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
