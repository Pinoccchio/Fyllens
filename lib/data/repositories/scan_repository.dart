import 'dart:io';
import 'package:fyllens/data/services/database_service.dart';
import 'package:fyllens/data/services/storage_service.dart';
import 'package:fyllens/data/services/ml_service.dart';
import 'package:fyllens/data/models/scan_result_model.dart';

/// Scan repository
/// Handles scan-related business logic
class ScanRepository {
  final DatabaseService _databaseService = DatabaseService();
  final StorageService _storageService = StorageService();
  final MLService _mlService = MLService();

  /// Perform a plant scan
  Future<ScanResultModel> performScan({
    required File imageFile,
    required String plantId,
    required String plantName,
    required String userId,
  }) async {
    try {
      // TODO: Implement complete scan logic
      // 1. Upload image to storage
      // 2. Analyze with ML model
      // 3. Save scan result to database

      // Placeholder implementation
      final mlResult = await _mlService.analyzePlantImage(
        imageFile: imageFile,
        plantSpecies: plantName,
      );

      final scanData = {
        'user_id': userId,
        'plant_id': plantId,
        'plant_name': plantName,
        'image_url': '', // TODO: Upload image and get URL
        'deficiency_detected': mlResult['deficiency'],
        'confidence': mlResult['confidence'],
        'recommendations': mlResult['recommendations'],
        'created_at': DateTime.now().toIso8601String(),
      };

      final result = await _databaseService.insert('scan_results', scanData);
      return ScanResultModel.fromJson(result);
    } catch (e) {
      rethrow;
    }
  }

  /// Get all scan results for a user
  Future<List<ScanResultModel>> getUserScans(String userId) async {
    try {
      final results = await _databaseService.query(
        'scan_results',
        column: 'user_id',
        value: userId,
      );

      return results.map((json) => ScanResultModel.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Get a single scan result
  Future<ScanResultModel?> getScanById(String scanId) async {
    try {
      final result = await _databaseService.fetchById('scan_results', scanId);
      return result != null ? ScanResultModel.fromJson(result) : null;
    } catch (e) {
      rethrow;
    }
  }

  /// Delete a scan result
  Future<void> deleteScan(String scanId) async {
    try {
      await _databaseService.delete('scan_results', scanId);
    } catch (e) {
      rethrow;
    }
  }
}
