import 'package:flutter/foundation.dart';
import 'package:fyllens/data/repositories/scan_repository.dart';
import 'package:fyllens/data/models/scan_result_model.dart';

/// History provider
/// Manages scan history state
class HistoryProvider with ChangeNotifier {
  final ScanRepository _scanRepository = ScanRepository();

  List<ScanResultModel> _scanHistory = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ScanResultModel> get scanHistory => _scanHistory;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasHistory => _scanHistory.isNotEmpty;

  /// Load scan history for a user
  Future<void> loadHistory(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final history = await _scanRepository.getUserScans(userId);
      _scanHistory = history;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Refresh history
  Future<void> refreshHistory(String userId) async {
    await loadHistory(userId);
  }

  /// Delete a scan from history
  Future<bool> deleteScan(String scanId) async {
    try {
      await _scanRepository.deleteScan(scanId);
      _scanHistory.removeWhere((scan) => scan.id == scanId);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Get scan by ID
  ScanResultModel? getScanById(String scanId) {
    try {
      return _scanHistory.firstWhere((scan) => scan.id == scanId);
    } catch (e) {
      return null;
    }
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Clear history
  void clearHistory() {
    _scanHistory = [];
    notifyListeners();
  }
}
