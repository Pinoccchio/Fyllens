import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:fyllens/core/utils/timezone_helper.dart';

/// User model representing authenticated users
class User {
  final String id;
  final String email;
  final String? fullName;
  final String? avatarUrl;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const User({
    required this.id,
    required this.email,
    this.fullName,
    this.avatarUrl,
    required this.createdAt,
    this.updatedAt,
  });

  /// Create User from Supabase auth response
  factory User.fromAuthUser(supabase.User authUser) {
    return User(
      id: authUser.id,
      email: authUser.email!,
      fullName: authUser.userMetadata?['full_name'] as String?,
      avatarUrl: authUser.userMetadata?['avatar_url'] as String?,
      // Parse UTC timestamps from Supabase and convert to Manila time
      createdAt: TimezoneHelper.parseUtcToManila(authUser.createdAt),
      updatedAt: authUser.updatedAt != null
          ? TimezoneHelper.parseUtcToManila(authUser.updatedAt!)
          : null,
    );
  }

  /// Create User from database JSON (user_profiles table)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['full_name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      // Parse UTC timestamps from Supabase and convert to Manila time
      createdAt: TimezoneHelper.parseUtcToManila(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? TimezoneHelper.parseUtcToManila(json['updated_at'] as String)
          : null,
    );
  }

  /// Convert User to JSON for database operations
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'avatar_url': avatarUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Create a copy with updated fields
  User copyWith({
    String? id,
    String? email,
    String? fullName,
    String? avatarUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() => 'User(id: $id, email: $email, fullName: $fullName)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
