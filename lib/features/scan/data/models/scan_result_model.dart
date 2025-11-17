import '../../domain/entities/scan_result_entity.dart';

/// Scan result model (data layer - extends entity with JSON serialization)
class ScanResultModel extends ScanResultEntity {
  const ScanResultModel({
    super.id,
    super.userId,
    super.plantId,
    super.plantName,
    super.imageUrl,
    super.deficiencyDetected,
    super.confidence,
    super.recommendations,
    super.createdAt,
  });

  factory ScanResultModel.fromJson(Map<String, dynamic> json) {
    return ScanResultModel(
      id: json['id'] as String?,
      userId: json['user_id'] as String?,
      plantId: json['plant_id'] as String?,
      plantName: json['plant_name'] as String?,
      imageUrl: json['image_url'] as String?,
      deficiencyDetected: json['deficiency_detected'] as String?,
      confidence: json['confidence'] != null
          ? (json['confidence'] as num).toDouble()
          : null,
      recommendations: json['recommendations'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final data = {
      'id': id,
      'user_id': userId,
      'plant_id': plantId,
      'plant_name': plantName,
      'image_url': imageUrl,
      'deficiency_detected': deficiencyDetected,
      'confidence': confidence,
      'recommendations': recommendations,
      'created_at': createdAt?.toIso8601String(),
    };
    data.removeWhere((key, value) => value == null);
    return data;
  }

  @override
  ScanResultModel copyWith({
    String? id,
    String? userId,
    String? plantId,
    String? plantName,
    String? imageUrl,
    String? deficiencyDetected,
    double? confidence,
    String? recommendations,
    DateTime? createdAt,
  }) {
    return ScanResultModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      plantId: plantId ?? this.plantId,
      plantName: plantName ?? this.plantName,
      imageUrl: imageUrl ?? this.imageUrl,
      deficiencyDetected: deficiencyDetected ?? this.deficiencyDetected,
      confidence: confidence ?? this.confidence,
      recommendations: recommendations ?? this.recommendations,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
