/// User profile entity (domain layer - pure business object)
/// No external dependencies, no JSON serialization
class UserProfileEntity {
  final String? id;
  final String? email;
  final String? displayName;
  final String? avatarUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserProfileEntity({
    this.id,
    this.email,
    this.displayName,
    this.avatarUrl,
    this.createdAt,
    this.updatedAt,
  });

  /// Copy with method for immutable updates
  UserProfileEntity copyWith({
    String? id,
    String? email,
    String? displayName,
    String? avatarUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfileEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserProfileEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'UserProfileEntity(id: $id, email: $email, displayName: $displayName)';
}
