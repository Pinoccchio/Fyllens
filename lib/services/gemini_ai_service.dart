import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

/// Service for Google Gemini AI integration
///
/// Generates enhanced plant deficiency information including:
/// - Detailed symptoms descriptions
/// - Treatment recommendations
/// - Prevention tips
/// - Severity assessment
class GeminiAIService {
  static final GeminiAIService _instance = GeminiAIService._internal();
  static GeminiAIService get instance => _instance;

  late final GenerativeModel _model;
  bool _isInitialized = false;

  GeminiAIService._internal();

  /// Initialize Gemini AI model
  Future<void> initialize() async {
    if (_isInitialized) return;

    print('\n🤖 [GEMINI AI] Initializing Gemini AI service...');

    try {
      final apiKey = dotenv.env['GOOGLE_GEMINI_API_KEY'];

      if (apiKey == null || apiKey.isEmpty) {
        throw Exception('GOOGLE_GEMINI_API_KEY not found in .env file');
      }

      print('   ✅ [GEMINI AI] API key loaded from environment');

      // Initialize Gemini model
      // Using gemini-2.5-flash-lite for lower quota usage and faster responses
      _model = GenerativeModel(
        model: 'gemini-2.5-flash-lite',
        apiKey: apiKey,
        generationConfig: GenerationConfig(
          temperature: 0.7,
          topK: 40,
          topP: 0.95,
          maxOutputTokens: 1024,
        ),
      );

      _isInitialized = true;
      print('   ✅ [GEMINI AI] Gemini AI service initialized successfully\n');
    } catch (e, stackTrace) {
      print('   🚨 [GEMINI AI] Initialization error: $e');
      print('   Stack Trace: $stackTrace');
      rethrow;
    }
  }

  /// Generate enhanced plant deficiency information
  ///
  /// Parameters:
  /// - [plantName]: Name of the plant species
  /// - [deficiencyName]: Name of detected deficiency (or "Healthy")
  /// - [confidence]: ML model confidence score (0.0 - 1.0)
  /// - [isHealthy]: Whether the plant is healthy (changes prompt behavior)
  ///
  /// Returns Map containing:
  /// For DEFICIENT plants:
  /// - severity: String (Mild, Moderate, Severe)
  /// - symptoms: List<String> - Detailed symptom descriptions
  /// - treatments: List<Map<String, String>> - Treatment recommendations
  /// - prevention: List<String> - Prevention tips
  ///
  /// For HEALTHY plants:
  /// - careTips: List<String> - General care recommendations
  /// - preventiveCare: List<String> - How to keep plant healthy
  /// - growthOptimization: List<String> - Tips to maximize growth
  Future<Map<String, dynamic>> generateDeficiencyInfo({
    required String plantName,
    required String deficiencyName,
    required double confidence,
    bool isHealthy = false,
  }) async {
    print('\n🌟 [GEMINI AI] Generating enhanced ${isHealthy ? 'care' : 'deficiency'} info...');
    print('   Plant: $plantName');
    print('   Status: ${isHealthy ? 'Healthy' : 'Deficient'}');
    print('   ${isHealthy ? 'Health' : 'Deficiency'}: $deficiencyName');
    print('   Confidence: ${(confidence * 100).toStringAsFixed(2)}%');

    if (!_isInitialized) {
      await initialize();
    }

    try {
      // Create prompt based on plant health status
      final String prompt;

      if (isHealthy) {
        // Healthy plant prompt - focus on care and optimization
        prompt = '''
You are an expert agricultural scientist specializing in plant care and cultivation.

A plant health detection system has confirmed the following:
- Plant Species: $plantName
- Health Status: HEALTHY (Excellent condition)
- Confidence: ${(confidence * 100).toStringAsFixed(1)}%

Please provide care recommendations in the following JSON format:

{
  "careTips": [
    "Specific care tip 1 for maintaining $plantName health",
    "Specific care tip 2 (watering, sunlight, soil, etc.)",
    "Specific care tip 3"
  ],
  "preventiveCare": [
    "Prevention tip 1 to avoid future deficiencies",
    "Prevention tip 2 for common issues in $plantName",
    "Prevention tip 3"
  ],
  "growthOptimization": [
    "Growth optimization tip 1 for better yield/vigor",
    "Growth optimization tip 2",
    "Growth optimization tip 3"
  ]
}

Guidelines:
1. Provide 3-5 specific, actionable care tips for $plantName
2. Include 3-5 preventive measures to keep the plant healthy
3. Suggest 3-5 ways to optimize growth, yield, or plant vigor
4. Be specific to $plantName species and common cultivation practices
5. Use professional but accessible language
6. Only output valid JSON, no additional text

Response:''';
      } else {
        // Deficient plant prompt - focus on treatment
        prompt = '''
You are an expert agricultural scientist specializing in plant diseases and nutrient deficiencies.

A plant disease detection system has identified the following:
- Plant Species: $plantName
- Detected Disease/Deficiency: $deficiencyName
- Detection Confidence: ${(confidence * 100).toStringAsFixed(1)}%

Please provide detailed information in the following JSON format:

{
  "severity": "Mild/Moderate/Severe",
  "symptoms": [
    "Detailed symptom 1 specific to $deficiencyName in $plantName",
    "Detailed symptom 2",
    "Detailed symptom 3"
  ],
  "treatments": [
    {
      "title": "Treatment method name",
      "description": "Detailed step-by-step treatment instructions",
      "icon": "fertilizer/organic/spray"
    }
  ],
  "prevention": [
    "Prevention tip 1",
    "Prevention tip 2",
    "Prevention tip 3"
  ]
}

Guidelines:
1. Base severity assessment on the confidence level and typical progression of this disease
2. List 3-5 specific, observable symptoms for this exact disease in this plant
3. Provide 2-4 practical treatment methods with clear instructions
4. Include 3-5 actionable prevention strategies
5. Be specific to $plantName and $deficiencyName
6. Use professional but accessible language
7. Only output valid JSON, no additional text

Response:''';
      }

      print('   📝 [GEMINI AI] Sending ${isHealthy ? 'care' : 'treatment'} prompt to Gemini API...');

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      print('   ✅ [GEMINI AI] Received response from Gemini API');

      if (response.text == null || response.text!.isEmpty) {
        throw Exception('Empty response from Gemini API');
      }

      // Extract JSON from response (may contain markdown code blocks)
      String jsonText = response.text!.trim();

      // Remove markdown code blocks if present
      if (jsonText.startsWith('```json')) {
        jsonText = jsonText.substring(7);
      } else if (jsonText.startsWith('```')) {
        jsonText = jsonText.substring(3);
      }

      if (jsonText.endsWith('```')) {
        jsonText = jsonText.substring(0, jsonText.length - 3);
      }

      jsonText = jsonText.trim();

      print('   📊 [GEMINI AI] Parsing JSON response...');
      print('   Response length: ${jsonText.length} characters');

      // Parse JSON response using dart:convert
      try {
        // Decode JSON string to Map
        final Map<String, dynamic> decoded =
            jsonDecode(jsonText) as Map<String, dynamic>;

        // Validate and extract fields based on plant health status
        final Map<String, dynamic> result;

        if (isHealthy) {
          // Parse healthy plant response (care tips)
          result = {
            'careTips':
                (decoded['careTips'] as List<dynamic>?)
                    ?.map((e) => e.toString())
                    .toList() ??
                ['Continue current care routine'],
            'preventiveCare':
                (decoded['preventiveCare'] as List<dynamic>?)
                    ?.map((e) => e.toString())
                    .toList() ??
                ['Monitor plant regularly'],
            'growthOptimization':
                (decoded['growthOptimization'] as List<dynamic>?)
                    ?.map((e) => e.toString())
                    .toList() ??
                ['Maintain consistent care'],
          };

          print('   ✅ [GEMINI AI] Successfully parsed healthy plant response');
          print('      - Care Tips: ${(result['careTips'] as List).length} items');
          print('      - Preventive Care: ${(result['preventiveCare'] as List).length} items');
          print('      - Growth Optimization: ${(result['growthOptimization'] as List).length} items');
        } else {
          // Parse deficient plant response (treatments)
          result = {
            'severity':
                decoded['severity']?.toString() ?? _calculateSeverity(confidence),
            'symptoms':
                (decoded['symptoms'] as List<dynamic>?)
                    ?.map((e) => e.toString())
                    .toList() ??
                ['No specific symptoms provided'],
            'treatments':
                (decoded['treatments'] as List<dynamic>?)?.map((treatment) {
                  final Map<String, dynamic> t =
                      treatment as Map<String, dynamic>;
                  return {
                    'title': t['title']?.toString() ?? 'Treatment',
                    'description':
                        t['description']?.toString() ??
                        'Apply appropriate treatment',
                    'icon': t['icon']?.toString() ?? 'fertilizer',
                  };
                }).toList() ??
                [],
            'prevention':
                (decoded['prevention'] as List<dynamic>?)
                    ?.map((e) => e.toString())
                    .toList() ??
                ['Regular monitoring recommended'],
          };

          print('   ✅ [GEMINI AI] Successfully parsed deficient plant response');
          print('      - Severity: ${result['severity']}');
          print('      - Symptoms: ${(result['symptoms'] as List).length} items');
          print('      - Treatments: ${(result['treatments'] as List).length} items');
          print('      - Prevention: ${(result['prevention'] as List).length} items');
        }

        return result;
      } catch (parseError) {
        print(
          '   ⚠️  [GEMINI AI] JSON parsing failed, using fallback: $parseError',
        );

        // Fallback: Use basic deficiency info
        return _getFallbackDeficiencyInfo(
          plantName: plantName,
          deficiencyName: deficiencyName,
          confidence: confidence,
          isHealthy: isHealthy,
        );
      }
    } catch (e, stackTrace) {
      print('   🚨 [GEMINI AI] Error generating deficiency info: $e');
      print('   Stack Trace: $stackTrace');

      // Return fallback data instead of failing
      return _getFallbackDeficiencyInfo(
        plantName: plantName,
        deficiencyName: deficiencyName,
        confidence: confidence,
        isHealthy: isHealthy,
      );
    }
  }

  /// Calculate severity based on confidence level
  String _calculateSeverity(double confidence) {
    if (confidence >= 0.8) return 'Severe';
    if (confidence >= 0.6) return 'Moderate';
    return 'Mild';
  }

  /// Fallback deficiency information when API fails
  Map<String, dynamic> _getFallbackDeficiencyInfo({
    required String plantName,
    required String deficiencyName,
    required double confidence,
    required bool isHealthy,
  }) {
    print('   ℹ️  [GEMINI AI] Using fallback ${isHealthy ? 'care' : 'deficiency'} information');

    if (isHealthy) {
      // Fallback for healthy plants
      return {
        'careTips': [
          'Maintain regular watering schedule for $plantName',
          'Ensure adequate sunlight exposure',
          'Apply balanced fertilizer as needed',
        ],
        'preventiveCare': [
          'Monitor for early signs of stress or deficiency',
          'Maintain proper soil conditions and drainage',
          'Practice good plant hygiene and sanitation',
        ],
        'growthOptimization': [
          'Optimize nutrient levels for better growth',
          'Consider pruning for improved air circulation',
          'Monitor and adjust care based on plant response',
        ],
      };
    } else {
      // Fallback for deficient plants
      return {
        'severity': _calculateSeverity(confidence),
        'symptoms': [
          'Visual signs of $deficiencyName in $plantName',
          'Discoloration or spotting on plant tissue',
          'Changes in growth patterns or leaf appearance',
        ],
        'treatments': [
          {
            'title': 'Immediate Treatment',
            'description': 'Apply appropriate remedies for $deficiencyName',
            'icon': 'fertilizer',
          },
          {
            'title': 'Long-term Management',
            'description': 'Improve soil conditions and plant care practices',
            'icon': 'organic',
          },
        ],
        'prevention': [
          'Regular monitoring and early detection',
          'Proper nutrition and soil management',
          'Good cultural practices and sanitation',
        ],
      };
    }
  }

  /// Dispose resources
  void dispose() {
    print('🗑️  [GEMINI AI] Disposing Gemini AI service');
    _isInitialized = false;
  }
}
