import 'dart:convert';

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
  final String? severity;
  final List<String>? symptoms;
  final List<Map<String, dynamic>>? geminiTreatments;
  final List<String>? preventionTips;

  // Fields for healthy plants (from Gemini AI)
  final List<String>? careTips;
  final List<String>? preventiveCare;
  final List<String>? growthOptimization;

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
    this.severity,
    this.symptoms,
    this.geminiTreatments,
    this.preventionTips,
    this.careTips,
    this.preventiveCare,
    this.growthOptimization,
    required this.createdAt,
  });

  /// Create ScanResult from database JSON
  factory ScanResult.fromJson(Map<String, dynamic> json) {
    // Parse JSON arrays for Gemini-enhanced fields
    List<String>? parseSymptoms() {
      final symptomsStr = json['symptoms'];
      if (symptomsStr == null || symptomsStr.toString().isEmpty) return null;
      try {
        final decoded = jsonDecode(symptomsStr);
        return (decoded as List).map((e) => e.toString()).toList();
      } catch (e) {
        return null;
      }
    }

    List<Map<String, dynamic>>? parseTreatments() {
      final treatmentsStr = json['gemini_treatments'];
      if (treatmentsStr == null || treatmentsStr.toString().isEmpty) return null;
      try {
        final decoded = jsonDecode(treatmentsStr);
        return (decoded as List).map((e) => e as Map<String, dynamic>).toList();
      } catch (e) {
        return null;
      }
    }

    List<String>? parsePrevention() {
      final preventionStr = json['prevention_tips'];
      if (preventionStr == null || preventionStr.toString().isEmpty) return null;
      try {
        final decoded = jsonDecode(preventionStr);
        return (decoded as List).map((e) => e.toString()).toList();
      } catch (e) {
        return null;
      }
    }

    List<String>? parseCareTips() {
      final careTipsStr = json['care_tips'];
      if (careTipsStr == null || careTipsStr.toString().isEmpty) return null;
      try {
        final decoded = jsonDecode(careTipsStr);
        return (decoded as List).map((e) => e.toString()).toList();
      } catch (e) {
        return null;
      }
    }

    List<String>? parsePreventiveCare() {
      final preventiveCareStr = json['preventive_care'];
      if (preventiveCareStr == null || preventiveCareStr.toString().isEmpty) {
        return null;
      }
      try {
        final decoded = jsonDecode(preventiveCareStr);
        return (decoded as List).map((e) => e.toString()).toList();
      } catch (e) {
        return null;
      }
    }

    List<String>? parseGrowthOptimization() {
      final growthOptStr = json['growth_optimization'];
      if (growthOptStr == null || growthOptStr.toString().isEmpty) return null;
      try {
        final decoded = jsonDecode(growthOptStr);
        return (decoded as List).map((e) => e.toString()).toList();
      } catch (e) {
        return null;
      }
    }

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
      severity: json['severity'] as String?,
      symptoms: parseSymptoms(),
      geminiTreatments: parseTreatments(),
      preventionTips: parsePrevention(),
      careTips: parseCareTips(),
      preventiveCare: parsePreventiveCare(),
      growthOptimization: parseGrowthOptimization(),
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
      'severity': severity,
      'symptoms': symptoms != null ? jsonEncode(symptoms) : null,
      'gemini_treatments':
          geminiTreatments != null ? jsonEncode(geminiTreatments) : null,
      'prevention_tips':
          preventionTips != null ? jsonEncode(preventionTips) : null,
      'care_tips': careTips != null ? jsonEncode(careTips) : null,
      'preventive_care':
          preventiveCare != null ? jsonEncode(preventiveCare) : null,
      'growth_optimization':
          growthOptimization != null ? jsonEncode(growthOptimization) : null,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Check if plant is healthy (no deficiency)
  bool get isHealthy =>
      deficiencyDetected?.toLowerCase() == 'healthy' ||
      deficiencyDetected?.toLowerCase() == 'no deficiency detected' ||
      deficiencyDetected?.toLowerCase() == 'no deficiency';

  /// Check if scan detected a deficiency (opposite of healthy)
  bool get hasDeficiency =>
      !isHealthy && deficiencyDetected != null && deficiencyDetected!.isNotEmpty;

  /// Get confidence as percentage (0-100)
  int? get confidencePercentage =>
      confidence != null ? (confidence! * 100).round() : null;

  @override
  String toString() =>
      'ScanResult(id: $id, plantName: $plantName, deficiency: $deficiencyDetected)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ScanResult && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
