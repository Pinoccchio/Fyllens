import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:fyllens/data/repositories/scan_repository.dart';
import 'package:fyllens/data/models/scan_result_model.dart';

/// Scan provider
/// Manages scanning state and operations
class ScanProvider with ChangeNotifier {
  final ScanRepository _scanRepository = ScanRepository();

  bool _isScanning = false;
  ScanResultModel? _currentScanResult;
  String? _errorMessage;

  bool get isScanning => _isScanning;
  ScanResultModel? get currentScanResult => _currentScanResult;
  String? get errorMessage => _errorMessage;

  /// Perform a plant scan
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
      final result = await _scanRepository.performScan(
        imageFile: imageFile,
        plantId: plantId,
        plantName: plantName,
        userId: userId,
      );

      _currentScanResult = result;
      _isScanning = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isScanning = false;
      notifyListeners();
      return false;
    }
  }

  /// Clear current scan result
  void clearCurrentScan() {
    _currentScanResult = null;
    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
