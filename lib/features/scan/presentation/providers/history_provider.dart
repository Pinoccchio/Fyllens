import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/scan_result_entity.dart';
import '../../domain/usecases/get_user_scans_usecase.dart';
import '../../domain/usecases/delete_scan_usecase.dart';

@injectable
class HistoryProvider with ChangeNotifier {
  final GetUserScansUseCase _getUserScansUseCase;
  final DeleteScanUseCase _deleteScanUseCase;

  HistoryProvider(
    this._getUserScansUseCase,
    this._deleteScanUseCase,
  );

  List<ScanResultEntity> _scanHistory = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ScanResultEntity> get scanHistory => _scanHistory;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasHistory => _scanHistory.isNotEmpty;

  Future<void> loadHistory(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final history = await _getUserScansUseCase.execute(userId);
      _scanHistory = history;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = _extractErrorMessage(e);
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshHistory(String userId) async {
    await loadHistory(userId);
  }

  Future<bool> deleteScan(String scanId) async {
    try {
      await _deleteScanUseCase.execute(scanId);
      _scanHistory.removeWhere((scan) => scan.id == scanId);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = _extractErrorMessage(e);
      notifyListeners();
      return false;
    }
  }

  ScanResultEntity? getScanById(String scanId) {
    try {
      return _scanHistory.firstWhere((scan) => scan.id == scanId);
    } catch (e) {
      return null;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearHistory() {
    _scanHistory = [];
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
