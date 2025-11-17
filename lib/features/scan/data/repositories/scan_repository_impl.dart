import 'dart:io';
import 'package:injectable/injectable.dart';
import '../../domain/entities/scan_result_entity.dart';
import '../../domain/repositories/scan_repository.dart';
import '../../../../data/services/database_service.dart';
import '../../../../data/services/storage_service.dart';
import '../../../../data/services/ml_service.dart';
import '../models/scan_result_model.dart';

@LazySingleton(as: ScanRepository)
class ScanRepositoryImpl implements ScanRepository {
  final DatabaseService _databaseService;
  final StorageService _storageService;
  final MLService _mlService;

  ScanRepositoryImpl(
    this._databaseService,
    this._storageService,
    this._mlService,
  );

  @override
  Future<ScanResultEntity> performScan({
    required File imageFile,
    required String plantId,
    required String plantName,
    required String userId,
  }) async {
    try {
      // Analyze with ML model
      final mlResult = await _mlService.analyzePlantImage(
        imageFile: imageFile,
        plantSpecies: plantName,
      );

      // TODO: Upload image to storage and get URL
      // final imageUrl = await _storageService.uploadImage(...);

      final scanData = {
        'user_id': userId,
        'plant_id': plantId,
        'plant_name': plantName,
        'image_url': '', // TODO: Replace with actual uploaded image URL
        'deficiency_detected': mlResult['deficiency'],
        'confidence': mlResult['confidence'],
        'recommendations': mlResult['recommendations'],
        'created_at': DateTime.now().toIso8601String(),
      };

      final result = await _databaseService.insert('scan_results', scanData);
      return ScanResultModel.fromJson(result);
    } catch (e) {
      throw Exception('Perform scan error: ${e.toString()}');
    }
  }

  @override
  Future<List<ScanResultEntity>> getUserScans(String userId) async {
    try {
      final results = await _databaseService.query(
        'scan_results',
        column: 'user_id',
        value: userId,
      );

      return results.map((json) => ScanResultModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Get user scans error: ${e.toString()}');
    }
  }

  @override
  Future<ScanResultEntity?> getScanById(String scanId) async {
    try {
      final result = await _databaseService.fetchById('scan_results', scanId);
      if (result == null) return null;
      return ScanResultModel.fromJson(result);
    } catch (e) {
      throw Exception('Get scan by ID error: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteScan(String scanId) async {
    try {
      await _databaseService.delete('scan_results', scanId);
    } catch (e) {
      throw Exception('Delete scan error: ${e.toString()}');
    }
  }
}
