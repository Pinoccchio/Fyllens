/// Scan result model
/// Represents a plant scan result with deficiency detection
class ScanResultModel {
  final String id;
  final String userId;
  final String plantId;
  final String plantName;
  final String imageUrl;
  final String? deficiencyDetected;
  final double? confidence;
  final String? recommendations;
  final DateTime createdAt;

  ScanResultModel({
    required this.id,
    required this.userId,
    required this.plantId,
    required this.plantName,
    required this.imageUrl,
    this.deficiencyDetected,
    this.confidence,
    this.recommendations,
    required this.createdAt,
  });

  /// Create from JSON
  factory ScanResultModel.fromJson(Map<String, dynamic> json) {
    return ScanResultModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      plantId: json['plant_id'] as String,
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

  /// Convert to JSON
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
  bool get hasDeficiency => deficiencyDetected != null;

  /// Get confidence as percentage
  String get confidencePercentage =>
      confidence != null ? '${(confidence! * 100).toStringAsFixed(1)}%' : 'N/A';
}
