/// Deficiency model representing nutrient deficiency information
class Deficiency {
  final String id;
  final String name;
  final String description;
  final List<String> symptoms;
  final String treatment;
  final String? imageUrl;
  final DateTime createdAt;

  const Deficiency({
    required this.id,
    required this.name,
    required this.description,
    required this.symptoms,
    required this.treatment,
    this.imageUrl,
    required this.createdAt,
  });

  /// Create Deficiency from database JSON
  factory Deficiency.fromJson(Map<String, dynamic> json) {
    return Deficiency(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      symptoms: List<String>.from(json['symptoms'] as List),
      treatment: json['treatment'] as String,
      imageUrl: json['image_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  /// Convert Deficiency to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'symptoms': symptoms,
      'treatment': treatment,
      'image_url': imageUrl,
      'created_at': createdAt.toIso8601String(),
    };
  }

  @override
  String toString() => 'Deficiency(id: $id, name: $name)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Deficiency && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
