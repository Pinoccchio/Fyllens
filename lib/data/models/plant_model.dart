/// Plant model
/// Represents plant species data from database
class PlantModel {
  final String id;
  final String name;
  final String species;
  final String description;
  final String? imageUrl;
  final List<String>? commonDeficiencies;
  final DateTime createdAt;

  PlantModel({
    required this.id,
    required this.name,
    required this.species,
    required this.description,
    this.imageUrl,
    this.commonDeficiencies,
    required this.createdAt,
  });

  /// Create from JSON
  factory PlantModel.fromJson(Map<String, dynamic> json) {
    return PlantModel(
      id: json['id'] as String,
      name: json['name'] as String,
      species: json['species'] as String,
      description: json['description'] as String,
      imageUrl: json['image_url'] as String?,
      commonDeficiencies: json['common_deficiencies'] != null
          ? List<String>.from(json['common_deficiencies'] as List)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'species': species,
      'description': description,
      'image_url': imageUrl,
      'common_deficiencies': commonDeficiencies,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
