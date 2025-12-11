import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

/// Machine Learning service
/// Handles ML model integration for plant deficiency detection using TensorFlow Lite
class MLService {
  static MLService? _instance;

  // Model interpreters (cached by plant species)
  final Map<String, Interpreter?> _interpreters = {};
  final Map<String, List<String>> _classNames = {};

  MLService._();

  /// Get singleton instance
  static MLService get instance {
    _instance ??= MLService._();
    return _instance!;
  }

  /// Model paths mapping
  static const Map<String, String> _modelPaths = {
    'Rice': 'assets/models/RICE/20251206_113308',
    'Corn': 'assets/models/CORN/20251206_113459',
    'Okra': 'assets/models/OKRA/20251206_113706',
    'Cucumber': 'assets/models/CUCUMBER/20251206_113852',
  };

  /// Analyze plant image for deficiencies
  Future<Map<String, dynamic>> analyzePlantImage({
    required File imageFile,
    required String plantSpecies,
  }) async {
    print('\n🤖 [ML SERVICE] analyzePlantImage() called');
    print('   Parameters:');
    print('      - Plant Species: $plantSpecies');
    print('      - Image Path: ${imageFile.path}');
    print('      - Image Exists: ${await imageFile.exists()}');

    try {
      // Load model and class names if not already loaded
      print('   📦 [ML SERVICE] Step 1: Ensuring model is loaded...');
      await _ensureModelLoaded(plantSpecies);

      final interpreter = _interpreters[plantSpecies];
      final classNames = _classNames[plantSpecies];

      if (interpreter == null || classNames == null) {
        print('   ❌ [ML SERVICE] ERROR: Model not loaded!');
        print('      - Interpreter: ${interpreter == null ? "NULL" : "OK"}');
        print('      - Class Names: ${classNames == null ? "NULL" : "OK"}');
        throw Exception('Model not loaded for $plantSpecies');
      }

      print('   ✅ [ML SERVICE] Model loaded successfully!');
      print('      - Number of classes: ${classNames.length}');
      print('      - Classes: ${classNames.join(", ")}');

      // Preprocess image
      print('   🖼️  [ML SERVICE] Step 2: Preprocessing image...');
      final input = await _preprocessImage(imageFile);
      print('   ✅ [ML SERVICE] Image preprocessed to 224x224');

      // Prepare output buffer
      final outputShape = interpreter.getOutputTensor(0).shape;
      final output = List.filled(outputShape[1], 0.0).reshape([1, outputShape[1]]);

      print('   🔬 [ML SERVICE] Step 3: Running inference...');
      print('      - Output Shape: $outputShape');

      // Run inference
      interpreter.run(input, output);

      // Get predictions
      final probabilities = output[0] as List<double>;

      print('   ✅ [ML SERVICE] Inference completed!');
      print('      - Raw Probabilities:');
      for (int i = 0; i < probabilities.length; i++) {
        print('         ${classNames[i]}: ${(probabilities[i] * 100).toStringAsFixed(2)}%');
      }

      // Find class with highest confidence
      double maxConfidence = 0.0;
      int maxIndex = 0;

      for (int i = 0; i < probabilities.length; i++) {
        if (probabilities[i] > maxConfidence) {
          maxConfidence = probabilities[i];
          maxIndex = i;
        }
      }

      // Get deficiency name
      final deficiency = classNames[maxIndex];
      final isHealthy = deficiency.toLowerCase() == 'healthy';

      print('   📊 [ML SERVICE] Step 4: Processing results...');
      print('      - Predicted Class: $deficiency');
      print('      - Confidence: ${(maxConfidence * 100).toStringAsFixed(2)}%');
      print('      - Is Healthy: $isHealthy');
      print('      - Confidence Threshold: ${(confidenceThreshold * 100)}%');

      final result = {
        'deficiency': deficiency.replaceAll('_', ' '),
        'confidence': maxConfidence,
        'recommendations': isHealthy
            ? 'Your plant looks healthy! Continue your current care routine.'
            : _getRecommendations(deficiency),
        'isHealthy': isHealthy,
        'allProbabilities': Map.fromIterables(
          classNames,
          probabilities,
        ),
      };

      print('   🎉 [ML SERVICE] analyzePlantImage() completed successfully!\n');
      return result;
    } catch (e, stackTrace) {
      print('   🚨 [ML SERVICE] Error in analyzePlantImage()!');
      print('      - Plant Species: $plantSpecies');
      print('      - Image Path: ${imageFile.path}');
      print('      - Exception: $e');
      print('      - Stack Trace: $stackTrace');
      rethrow;
    }
  }

  /// Ensure model and class names are loaded for the specified plant
  Future<void> _ensureModelLoaded(String plantSpecies) async {
    if (_interpreters.containsKey(plantSpecies) && _interpreters[plantSpecies] != null) {
      return; // Already loaded
    }

    await loadModel(plantSpecies);
  }

  /// Load ML model for specific plant species
  Future<void> loadModel(String plantSpecies) async {
    print('   📥 [ML SERVICE] loadModel() called for $plantSpecies');

    try {
      final modelPath = _modelPaths[plantSpecies];
      if (modelPath == null) {
        print('   ❌ [ML SERVICE] ERROR: No model path for $plantSpecies');
        print('      - Available species: ${_modelPaths.keys.join(", ")}');
        throw Exception('No model available for $plantSpecies');
      }

      print('      - Model Path: $modelPath');

      // Load TFLite model
      final modelFile = '$modelPath/${plantSpecies.toLowerCase()}_model.tflite';
      print('      - Loading TFLite model: $modelFile');
      final interpreter = await Interpreter.fromAsset(modelFile);
      print('      ✅ TFLite model loaded');

      // Load class names
      final classNamesFile = '$modelPath/class_names.json';
      print('      - Loading class names: $classNamesFile');
      final classNamesJson = await rootBundle.loadString(classNamesFile);
      final classNamesList = (jsonDecode(classNamesJson) as List)
          .map((e) => e.toString())
          .toList();
      print('      ✅ Class names loaded: ${classNamesList.length} classes');

      // Cache the interpreter and class names
      _interpreters[plantSpecies] = interpreter;
      _classNames[plantSpecies] = classNamesList;

      print('   ✅ [ML SERVICE] Model cached successfully for $plantSpecies');
    } catch (e, stackTrace) {
      print('   🚨 [ML SERVICE] Error loading model for $plantSpecies!');
      print('      - Exception: $e');
      print('      - Stack Trace: $stackTrace');
      rethrow;
    }
  }

  /// Preprocess image for ML model
  /// Resizes to 224x224 and normalizes pixel values
  Future<List<List<List<List<double>>>>> _preprocessImage(File imageFile) async {
    try {
      // Read image file
      print('         - Reading image bytes...');
      final bytes = await imageFile.readAsBytes();
      print('         - Image size: ${bytes.length} bytes');

      print('         - Decoding image...');
      img.Image? image = img.decodeImage(Uint8List.fromList(bytes));

      if (image == null) {
        print('         ❌ Failed to decode image');
        throw Exception('Failed to decode image');
      }

      print('         - Original dimensions: ${image.width}x${image.height}');

      // Resize to 224x224 (model input size)
      print('         - Resizing to 224x224...');
      final resized = img.copyResize(
        image,
        width: 224,
        height: 224,
        interpolation: img.Interpolation.cubic,
      );

      // Convert to 4D array [1, 224, 224, 3] with normalized values
      print('         - Converting to normalized 4D array...');
      final input = List.generate(
        1,
        (_) => List.generate(
          224,
          (y) => List.generate(
            224,
            (x) {
              final pixel = resized.getPixel(x, y);
              // Extract RGB from packed integer (ARGB format)
              final r = (pixel >> 16) & 0xFF;
              final g = (pixel >> 8) & 0xFF;
              final b = pixel & 0xFF;
              // Normalize to [0, 1] range
              return [
                r / 255.0,
                g / 255.0,
                b / 255.0,
              ];
            },
          ),
        ),
      );

      print('         ✅ Preprocessing complete');
      return input;
    } catch (e, stackTrace) {
      print('         🚨 Error preprocessing image!');
      print('         - Exception: $e');
      print('         - Stack Trace: $stackTrace');
      rethrow;
    }
  }

  /// Get treatment recommendations based on detected deficiency
  String _getRecommendations(String deficiency) {
    final deficiencyLower = deficiency.toLowerCase().replaceAll('_', ' ');

    // General recommendations mapping
    final recommendations = {
      'nitrogen deficiency': 'Apply nitrogen-rich fertilizer (e.g., urea, ammonium sulfate). Consider adding compost or well-rotted manure.',
      'phosphorus deficiency': 'Use phosphorus-rich fertilizer (e.g., bone meal, rock phosphate). Ensure soil pH is between 6-7 for optimal absorption.',
      'potassium deficiency': 'Apply potassium-rich fertilizer (e.g., potash, wood ash). Mulch with organic matter to improve soil quality.',
      'magnesium deficiency': 'Apply Epsom salt (magnesium sulfate) as foliar spray or soil amendment. Add dolomitic limestone to acidic soils.',
      'iron deficiency': 'Apply chelated iron fertilizer. Adjust soil pH to 6-7. Improve drainage if soil is waterlogged.',
      'calcium deficiency': 'Add calcium-rich amendments (e.g., gypsum, lime). Ensure consistent watering to prevent blossom end rot.',
      'sulfur deficiency': 'Apply sulfur-containing fertilizer (e.g., ammonium sulfate, elemental sulfur). Add organic compost.',
      'zinc deficiency': 'Apply zinc sulfate as foliar spray or soil amendment. Improve soil drainage and reduce phosphorus levels.',

      // Disease-specific recommendations
      'blight': 'Remove and destroy infected leaves. Apply copper-based fungicide. Improve air circulation and avoid overhead watering.',
      'common rust': 'Remove infected leaves early. Apply fungicide containing mancozeb or chlorothalonil. Plant resistant varieties.',
      'gray leaf spot': 'Practice crop rotation. Remove crop residue. Apply fungicide if severe. Improve soil drainage.',
      'bacterial leaf spot': 'Remove infected leaves. Apply copper-based bactericide. Avoid overhead watering. Use disease-free seeds.',
      'leaf curl': 'Apply neem oil or insecticidal soap. Remove heavily infected leaves. Control aphids and other pests.',
      'mosaic': 'Remove and destroy infected plants immediately. Control aphids. Use virus-free planting material. No chemical cure available.',
    };

    // Try to find a match
    for (final entry in recommendations.entries) {
      if (deficiencyLower.contains(entry.key)) {
        return entry.value;
      }
    }

    // Default recommendation
    return 'Consult with a local agricultural extension service for specific treatment recommendations. Consider soil testing for accurate diagnosis.';
  }

  /// Get confidence threshold for results
  double get confidenceThreshold => 0.6;

  /// Dispose resources when done
  void dispose() {
    for (final interpreter in _interpreters.values) {
      interpreter?.close();
    }
    _interpreters.clear();
    _classNames.clear();
  }
}
