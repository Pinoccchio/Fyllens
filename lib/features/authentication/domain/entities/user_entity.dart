/// User entity (domain layer - pure business object)
/// No external dependencies, no JSON serialization
class UserEntity {
  final String? id;
  final String? email;
  final String? createdAt;
  final String? lastSignInAt;
  final Map<String, dynamic>? userMetadata;

  const UserEntity({
    this.id,
    this.email,
    this.createdAt,
    this.lastSignInAt,
    this.userMetadata,
  });

  /// Copy with method for immutable updates
  UserEntity copyWith({
    String? id,
    String? email,
    String? createdAt,
    String? lastSignInAt,
    Map<String, dynamic>? userMetadata,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
      lastSignInAt: lastSignInAt ?? this.lastSignInAt,
      userMetadata: userMetadata ?? this.userMetadata,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'UserEntity(id: $id, email: $email)';
}
