/// Plant model representing plant species in the database
class Plant {
  final String id;
  final String name;
  final String species;
  final String? scientificName;
  final String? family;
  final String description;
  final String? optimalConditions;
  final List<String>? growthStages;
  final String? imageUrl;
  final List<String>? images;
  final List<String>? commonDeficiencies;
  final String? healthyDescription;
  final DateTime createdAt;

  const Plant({
    required this.id,
    required this.name,
    required this.species,
    this.scientificName,
    this.family,
    required this.description,
    this.optimalConditions,
    this.growthStages,
    this.imageUrl,
    this.images,
    this.commonDeficiencies,
    this.healthyDescription,
    required this.createdAt,
  });

  /// Create Plant from database JSON
  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      id: json['id'] as String,
      name: json['name'] as String,
      species: json['species'] as String,
      scientificName: json['scientific_name'] as String?,
      family: json['family'] as String?,
      description: json['description'] as String,
      optimalConditions: json['optimal_conditions'] as String?,
      growthStages: json['growth_stages'] != null
          ? List<String>.from(json['growth_stages'] as List)
          : null,
      imageUrl: json['image_url'] as String?,
      images: json['images'] != null
          ? List<String>.from(json['images'] as List)
          : null,
      commonDeficiencies: json['common_deficiencies'] != null
          ? List<String>.from(json['common_deficiencies'] as List)
          : null,
      healthyDescription: json['healthy_description'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  /// Convert Plant to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'species': species,
      'scientific_name': scientificName,
      'family': family,
      'description': description,
      'optimal_conditions': optimalConditions,
      'growth_stages': growthStages,
      'image_url': imageUrl,
      'images': images,
      'common_deficiencies': commonDeficiencies,
      'healthy_description': healthyDescription,
      'created_at': createdAt.toIso8601String(),
    };
  }

  @override
  String toString() => 'Plant(id: $id, name: $name, species: $species)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Plant && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
