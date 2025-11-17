/// Scan result entity (domain layer - pure business object)
class ScanResultEntity {
  final String? id;
  final String? userId;
  final String? plantId;
  final String? plantName;
  final String? imageUrl;
  final String? deficiencyDetected;
  final double? confidence;
  final String? recommendations;
  final DateTime? createdAt;

  const ScanResultEntity({
    this.id,
    this.userId,
    this.plantId,
    this.plantName,
    this.imageUrl,
    this.deficiencyDetected,
    this.confidence,
    this.recommendations,
    this.createdAt,
  });

  /// Check if scan detected a deficiency
  bool get hasDeficiency => deficiencyDetected != null && deficiencyDetected!.isNotEmpty;

  /// Get confidence as percentage
  String get confidencePercentage =>
      confidence != null ? '${(confidence! * 100).toStringAsFixed(1)}%' : 'N/A';

  ScanResultEntity copyWith({
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
    return ScanResultEntity(
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ScanResultEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
