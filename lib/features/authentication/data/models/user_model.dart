import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../../domain/entities/user_entity.dart';

/// User model (data layer - extends entity with JSON serialization)
/// Handles conversion between Supabase User and domain UserEntity
class UserModel extends UserEntity {
  const UserModel({
    super.id,
    super.email,
    super.createdAt,
    super.lastSignInAt,
    super.userMetadata,
  });

  /// Create UserModel from Supabase User
  factory UserModel.fromSupabaseUser(supabase.User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      createdAt: user.createdAt,
      lastSignInAt: user.lastSignInAt,
      userMetadata: user.userMetadata,
    );
  }

  /// Create UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String?,
      email: json['email'] as String?,
      createdAt: json['created_at'] as String?,
      lastSignInAt: json['last_sign_in_at'] as String?,
      userMetadata: json['user_metadata'] as Map<String, dynamic>?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    final data = {
      'id': id,
      'email': email,
      'created_at': createdAt,
      'last_sign_in_at': lastSignInAt,
      'user_metadata': userMetadata,
    };
    // Remove null values
    data.removeWhere((key, value) => value == null);
    return data;
  }

  /// Copy with method that returns UserModel
  @override
  UserModel copyWith({
    String? id,
    String? email,
    String? createdAt,
    String? lastSignInAt,
    Map<String, dynamic>? userMetadata,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
      lastSignInAt: lastSignInAt ?? this.lastSignInAt,
      userMetadata: userMetadata ?? this.userMetadata,
    );
  }
}
