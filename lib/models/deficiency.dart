/// Deficiency model representing nutrient deficiency information
class Deficiency {
  final String id;
  final String name;
  final String description;
  final List<String> symptoms;
  final String treatment;
  final String? imageUrl;
  final String? scientificName;
  final String? pathogenType;
  final List<String>? environmentalFactors;
  final List<String>? diagnosticFeatures;
  final List<String>? preventionMethods;
  final List<String>? organicTreatments;
  final List<String>? chemicalTreatments;
  final List<String>? severityIndicators;
  final List<String>? affectedPlantParts;
  final List<String>? images;
  final DateTime createdAt;

  const Deficiency({
    required this.id,
    required this.name,
    required this.description,
    required this.symptoms,
    required this.treatment,
    this.imageUrl,
    this.scientificName,
    this.pathogenType,
    this.environmentalFactors,
    this.diagnosticFeatures,
    this.preventionMethods,
    this.organicTreatments,
    this.chemicalTreatments,
    this.severityIndicators,
    this.affectedPlantParts,
    this.images,
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
      scientificName: json['scientific_name'] as String?,
      pathogenType: json['pathogen_type'] as String?,
      environmentalFactors: json['environmental_factors'] != null
          ? List<String>.from(json['environmental_factors'] as List)
          : null,
      diagnosticFeatures: json['diagnostic_features'] != null
          ? List<String>.from(json['diagnostic_features'] as List)
          : null,
      preventionMethods: json['prevention_methods'] != null
          ? List<String>.from(json['prevention_methods'] as List)
          : null,
      organicTreatments: json['organic_treatments'] != null
          ? List<String>.from(json['organic_treatments'] as List)
          : null,
      chemicalTreatments: json['chemical_treatments'] != null
          ? List<String>.from(json['chemical_treatments'] as List)
          : null,
      severityIndicators: json['severity_indicators'] != null
          ? List<String>.from(json['severity_indicators'] as List)
          : null,
      affectedPlantParts: json['affected_plant_parts'] != null
          ? List<String>.from(json['affected_plant_parts'] as List)
          : null,
      images: json['images'] != null
          ? List<String>.from(json['images'] as List)
          : null,
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
      'scientific_name': scientificName,
      'pathogen_type': pathogenType,
      'environmental_factors': environmentalFactors,
      'diagnostic_features': diagnosticFeatures,
      'prevention_methods': preventionMethods,
      'organic_treatments': organicTreatments,
      'chemical_treatments': chemicalTreatments,
      'severity_indicators': severityIndicators,
      'affected_plant_parts': affectedPlantParts,
      'images': images,
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
