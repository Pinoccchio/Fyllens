import 'package:flutter/foundation.dart';
import 'package:fyllens/models/scan_result.dart';
import 'package:fyllens/services/database_service.dart';

/// History provider - manages scan history
class HistoryProvider with ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService.instance;

  List<ScanResult> _scans = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ScanResult> get scans => _scans;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Load user's scan history
  Future<void> loadHistory(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await _databaseService.query(
        'scan_results',
        column: 'user_id',
        value: userId,
      );

      _scans = results.map((json) => ScanResult.fromJson(json)).toList();
      // Sort by date descending (newest first)
      _scans.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = _extractErrorMessage(e);
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Refresh history
  Future<void> refresh(String userId) async {
    await loadHistory(userId);
  }

  /// Delete a scan
  Future<bool> deleteScan(String scanId) async {
    try {
      await _databaseService.delete('scan_results', scanId);
      _scans.removeWhere((scan) => scan.id == scanId);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = _extractErrorMessage(e);
      notifyListeners();
      return false;
    }
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
