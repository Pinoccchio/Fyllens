/// Scan result model representing plant deficiency scan results
class ScanResult {
  final String id;
  final String userId;
  final String? plantId;
  final String plantName;
  final String imageUrl;
  final String? deficiencyDetected;
  final double? confidence;
  final String? recommendations;
  final DateTime createdAt;

  const ScanResult({
    required this.id,
    required this.userId,
    this.plantId,
    required this.plantName,
    required this.imageUrl,
    this.deficiencyDetected,
    this.confidence,
    this.recommendations,
    required this.createdAt,
  });

  /// Create ScanResult from database JSON
  factory ScanResult.fromJson(Map<String, dynamic> json) {
    return ScanResult(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      plantId: json['plant_id'] as String?,
      plantName: json['plant_name'] as String,
      imageUrl: json['image_url'] as String,
      deficiencyDetected: json['deficiency_detected'] as String?,
      confidence: json['confidence'] != null
          ? (json['confidence'] as num).toDouble()
          : null,
      recommendations: json['recommendations'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  /// Convert ScanResult to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'plant_id': plantId,
      'plant_name': plantName,
      'image_url': imageUrl,
      'deficiency_detected': deficiencyDetected,
      'confidence': confidence,
      'recommendations': recommendations,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Check if scan detected a deficiency
  bool get hasDeficiency => deficiencyDetected != null && deficiencyDetected!.isNotEmpty;

  /// Get confidence as percentage (0-100)
  int? get confidencePercentage => confidence != null ? (confidence! * 100).round() : null;

  @override
  String toString() => 'ScanResult(id: $id, plantName: $plantName, deficiency: $deficiencyDetected)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ScanResult && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
