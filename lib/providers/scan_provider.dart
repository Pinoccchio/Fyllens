import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:fyllens/models/scan_result.dart';
import 'package:fyllens/services/database_service.dart';
import 'package:fyllens/services/ml_service.dart';
import 'package:fyllens/services/storage_service.dart';

/// Scan provider - manages plant scan operations
class ScanProvider with ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService.instance;
  final MLService _mlService = MLService.instance;
  final StorageService _storageService = StorageService.instance;

  bool _isScanning = false;
  ScanResult? _currentScanResult;
  String? _errorMessage;

  bool get isScanning => _isScanning;
  ScanResult? get currentScanResult => _currentScanResult;
  String? get errorMessage => _errorMessage;

  Future<bool> performScan({
    required File imageFile,
    required String plantId,
    required String plantName,
    required String userId,
  }) async {
    _isScanning = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Analyze with ML model
      final mlResult = await _mlService.analyzePlantImage(
        imageFile: imageFile,
        plantSpecies: plantName,
      );

      // Upload image to storage
      final path = '$userId/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final imageUrl = await _storageService.uploadImage(
        file: imageFile,
        bucket: 'scan-images',
        path: path,
      );

      // Save scan result to database
      final scanData = {
        'user_id': userId,
        'plant_id': plantId,
        'plant_name': plantName,
        'image_url': imageUrl,
        'deficiency_detected': mlResult['deficiency'],
        'confidence': mlResult['confidence'],
        'recommendations': mlResult['recommendations'],
        'created_at': DateTime.now().toIso8601String(),
      };

      final result = await _databaseService.insert('scan_results', scanData);
      _currentScanResult = ScanResult.fromJson(result);
      _isScanning = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = _extractErrorMessage(e);
      _isScanning = false;
      notifyListeners();
      return false;
    }
  }

  void clearCurrentScan() {
    _currentScanResult = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  String _extractErrorMessage(Object error) {
    final errorStr = error.toString();
    if (errorStr.startsWith('Exception: ')) {
      return errorStr.substring(11);
    }
    return errorStr;
  }
}
