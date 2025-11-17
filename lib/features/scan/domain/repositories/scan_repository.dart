import 'dart:io';
import '../entities/scan_result_entity.dart';

/// Scan repository interface (domain layer)
abstract class ScanRepository {
  /// Perform plant scan
  Future<ScanResultEntity> performScan({
    required File imageFile,
    required String plantId,
    required String plantName,
    required String userId,
  });

  /// Get user's scan history
  Future<List<ScanResultEntity>> getUserScans(String userId);

  /// Get scan by ID
  Future<ScanResultEntity?> getScanById(String scanId);

  /// Delete scan
  Future<void> deleteScan(String scanId);
}
