/// Deficiency model
/// Represents a plant nutrient deficiency with symptoms and treatment
class DeficiencyModel {
  final String id;
  final String name;
  final String description;
  final List<String> symptoms;
  final String treatment;
  final String? imageUrl;
  final DateTime createdAt;

  DeficiencyModel({
    required this.id,
    required this.name,
    required this.description,
    required this.symptoms,
    required this.treatment,
    this.imageUrl,
    required this.createdAt,
  });

  /// Create from JSON
  factory DeficiencyModel.fromJson(Map<String, dynamic> json) {
    return DeficiencyModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      symptoms: List<String>.from(json['symptoms'] as List),
      treatment: json['treatment'] as String,
      imageUrl: json['image_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  /// Convert to JSON
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
}
