import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:fyllens/models/scan_result.dart';
import 'package:fyllens/models/deficiency.dart';
import 'package:fyllens/services/database_service.dart';
import 'package:fyllens/services/ml_service.dart';
import 'package:fyllens/services/storage_service.dart';
import 'package:fyllens/services/gemini_ai_service.dart';
import 'package:fyllens/services/supabase_service.dart';

/// Scan provider - manages plant scan operations
class ScanProvider with ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService.instance;
  final MLService _mlService = MLService.instance;
  final StorageService _storageService = StorageService.instance;
  final GeminiAIService _geminiService = GeminiAIService.instance;
  final _supabase = SupabaseService.instance.client;

  bool _isScanning = false;
  ScanResult? _currentScanResult;
  String? _errorMessage;
  String? _preselectedPlant;

  bool get isScanning => _isScanning;
  ScanResult? get currentScanResult => _currentScanResult;
  String? get errorMessage => _errorMessage;
  String? get preselectedPlant => _preselectedPlant;

  Future<bool> performScan({
    required File imageFile,
    String? plantId,
    required String plantName,
    required String userId,
  }) async {
    print('\n🔬 [SCAN PROVIDER] performScan() called');
    print('   Parameters:');
    print('      - Plant Name: $plantName');
    print('      - User ID: $userId');
    print('      - Plant ID: $plantId');
    print('      - Image Path: ${imageFile.path}');

    _isScanning = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Analyze with ML model
      print('   🤖 [SCAN PROVIDER] Step 1: Starting ML analysis...');
      final mlResult = await _mlService.analyzePlantImage(
        imageFile: imageFile,
        plantSpecies: plantName,
      );

      print('   ✅ [SCAN PROVIDER] ML Analysis completed!');
      print('      - Deficiency: ${mlResult['deficiency']}');
      print('      - Confidence: ${mlResult['confidence']}');
      print('      - Is Healthy: ${mlResult['isHealthy']}');

      // Lookup deficiency information from library database
      print('   📚 [SCAN PROVIDER] Step 1.5: Looking up deficiency info from database...');
      Deficiency? deficiencyFromDB;

      try {
        final deficiencyResponse = await _supabase
            .from('deficiencies')
            .select()
            .ilike('name', mlResult['deficiency'] ?? 'Unknown')
            .maybeSingle();

        if (deficiencyResponse != null) {
          deficiencyFromDB = Deficiency.fromJson(deficiencyResponse);
          print('   ✅ [SCAN PROVIDER] Found deficiency in database!');
          print('      - Name: ${deficiencyFromDB.name}');
          print('      - Scientific Name: ${deficiencyFromDB.scientificName}');
          print('      - Pathogen Type: ${deficiencyFromDB.pathogenType}');
          print('      - Has ${deficiencyFromDB.symptoms.length} symptoms');
          print('      - Has ${deficiencyFromDB.preventionMethods?.length ?? 0} prevention methods');
        } else {
          print('   ⚠️  [SCAN PROVIDER] Deficiency not found in database, will use ML+Gemini data only');
        }
      } catch (e) {
        print('   ⚠️  [SCAN PROVIDER] Error looking up deficiency: $e');
        print('      - Will use ML+Gemini data only');
      }

      // Upload image to storage
      final path = '$userId/${DateTime.now().millisecondsSinceEpoch}.jpg';
      print('   ☁️  [SCAN PROVIDER] Step 2: Uploading image to storage...');
      print('      - Bucket: scan-images');
      print('      - Path: $path');

      final imageUrl = await _storageService.uploadImage(
        file: imageFile,
        bucket: 'scan-images',
        path: path,
      );

      print('   ✅ [SCAN PROVIDER] Image uploaded successfully!');
      print('      - Image URL: $imageUrl');

      // Detect if plant is healthy based on ML result
      final deficiency = mlResult['deficiency'] ?? 'Unknown';
      final isHealthy = deficiency.toLowerCase() == 'healthy' ||
          deficiency.toLowerCase() == 'no deficiency detected' ||
          deficiency.toLowerCase() == 'no deficiency';

      print('   🏥 [SCAN PROVIDER] Health Status: ${isHealthy ? 'HEALTHY' : 'DEFICIENT'}');

      // Generate enhanced info with Gemini AI (care tips or treatment)
      print('   🌟 [SCAN PROVIDER] Step 3: Generating enhanced ${isHealthy ? 'care' : 'treatment'} info with Gemini AI...');
      Map<String, dynamic> geminiInfo = {};

      try {
        geminiInfo = await _geminiService.generateDeficiencyInfo(
          plantName: plantName,
          deficiencyName: deficiency,
          confidence: (mlResult['confidence'] as num?)?.toDouble() ?? 0.0,
          isHealthy: isHealthy, // Pass health status to Gemini
        );

        if (isHealthy) {
          print('   ✅ [SCAN PROVIDER] Gemini AI care info generated successfully!');
          print('      - Care Tips: ${(geminiInfo['careTips'] as List?)?.length ?? 0}');
          print('      - Preventive Care: ${(geminiInfo['preventiveCare'] as List?)?.length ?? 0}');
          print('      - Growth Optimization: ${(geminiInfo['growthOptimization'] as List?)?.length ?? 0}');
        } else {
          print('   ✅ [SCAN PROVIDER] Gemini AI treatment info generated successfully!');
          print('      - Severity: ${geminiInfo['severity']}');
          print('      - Symptoms count: ${(geminiInfo['symptoms'] as List?)?.length ?? 0}');
          print('      - Treatments count: ${(geminiInfo['treatments'] as List?)?.length ?? 0}');
        }
      } catch (e) {
        print('   ⚠️  [SCAN PROVIDER] Gemini AI failed, using fallback data: $e');
        // Continue with fallback data if Gemini fails
        if (isHealthy) {
          geminiInfo = {
            'careTips': ['Continue current care routine'],
            'preventiveCare': ['Monitor plant regularly'],
            'growthOptimization': ['Maintain consistent care'],
          };
        } else {
          geminiInfo = {
            'severity': 'Unknown',
            'symptoms': [],
            'treatments': [],
            'prevention': [],
          };
        }
      }

      // Save scan result to database
      print('   💾 [SCAN PROVIDER] Step 4: Saving scan result to database...');
      final scanData = {
        'user_id': userId,
        'plant_id': plantId,
        'plant_name': plantName,
        'image_url': imageUrl,
        'deficiency_detected': mlResult['deficiency'],
        'confidence': mlResult['confidence'],
        'recommendations': mlResult['recommendations'],
        // Conditional severity (null for healthy plants)
        'severity': isHealthy ? null : (geminiInfo['severity'] ?? 'Unknown'),
        // Deficient plant fields (null for healthy)
        'symptoms': isHealthy ? null : jsonEncode(geminiInfo['symptoms'] ?? []),
        'gemini_treatments': isHealthy ? null : jsonEncode(geminiInfo['treatments'] ?? []),
        'prevention_tips': isHealthy ? null : jsonEncode(geminiInfo['prevention'] ?? []),
        // Healthy plant fields (null for deficient)
        'care_tips': isHealthy ? jsonEncode(geminiInfo['careTips'] ?? []) : null,
        'preventive_care': isHealthy ? jsonEncode(geminiInfo['preventiveCare'] ?? []) : null,
        'growth_optimization': isHealthy ? jsonEncode(geminiInfo['growthOptimization'] ?? []) : null,
        'created_at': DateTime.now().toIso8601String(),
      };

      print('      - Scan Data: $scanData');

      final result = await _databaseService.insert('scan_results', scanData);

      print('   ✅ [SCAN PROVIDER] Database insert successful!');
      print('      - Result: $result');

      print('   📦 [SCAN PROVIDER] Step 5: Creating ScanResult object...');
      _currentScanResult = ScanResult.fromJson(result);

      print('   ✅ [SCAN PROVIDER] ScanResult created successfully!');
      print('      - Scan ID: ${_currentScanResult!.id}');
      print('      - Deficiency: ${_currentScanResult!.deficiencyDetected}');

      _isScanning = false;
      notifyListeners();

      print('   🎉 [SCAN PROVIDER] performScan() completed successfully!\n');
      return true;
    } catch (e, stackTrace) {
      print('   🚨 [SCAN PROVIDER] Error in performScan()!');
      print('      - Exception: $e');
      print('      - Stack Trace: $stackTrace');

      _errorMessage = _extractErrorMessage(e);
      print('      - Error Message: $_errorMessage');

      _isScanning = false;
      notifyListeners();

      print('   ❌ [SCAN PROVIDER] performScan() failed!\n');
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

  /// Pre-select a plant for scanning (used when navigating from plant detail screen)
  void preselectPlant(String plantName) {
    print('🌱 [SCAN PROVIDER] Pre-selecting plant: $plantName');
    _preselectedPlant = plantName;
    notifyListeners();
  }

  /// Clear preselection after it has been applied
  void clearPreselection() {
    print('🧹 [SCAN PROVIDER] Clearing plant preselection');
    _preselectedPlant = null;
    notifyListeners();
  }

  String _extractErrorMessage(Object error) {
    final errorStr = error.toString();
    if (errorStr.startsWith('Exception: ')) {
      return errorStr.substring(11);
    }
    return errorStr;
  }

  @override
  void dispose() {
    // Dispose ML service resources to prevent memory leaks
    _mlService.dispose();
    super.dispose();
  }
}
