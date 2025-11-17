import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/scan_result_entity.dart';
import '../../domain/usecases/perform_scan_usecase.dart';

@injectable
class ScanProvider with ChangeNotifier {
  final PerformScanUseCase _performScanUseCase;

  ScanProvider(this._performScanUseCase);

  bool _isScanning = false;
  ScanResultEntity? _currentScanResult;
  String? _errorMessage;

  bool get isScanning => _isScanning;
  ScanResultEntity? get currentScanResult => _currentScanResult;
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
      final result = await _performScanUseCase.execute(
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
