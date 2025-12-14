import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for Google Gemini AI integration with caching and quota handling
///
/// Generates enhanced plant deficiency information including:
/// - Detailed symptoms descriptions
/// - Treatment recommendations
/// - Prevention tips
/// - Severity assessment
///
/// Features:
/// - Local response caching (30-day TTL)
/// - Quota exceeded detection and graceful fallback
/// - Exponential backoff retry logic
/// - Offline support via cached responses
class GeminiAIService {
  static final GeminiAIService _instance = GeminiAIService._internal();
  static GeminiAIService get instance => _instance;

  late final GenerativeModel _model;
  late final SharedPreferences _prefs;
  bool _isInitialized = false;

  // Cache configuration
  static const String _cachePrefix = 'gemini_cache_';
  static const Duration _cacheTTL = Duration(days: 30);

  GeminiAIService._internal();

  /// Initialize Gemini AI model and cache system
  Future<void> initialize() async {
    if (_isInitialized) return;

    print('\n🤖 [GEMINI AI] Initializing Gemini AI service...');

    try {
      final apiKey = dotenv.env['GOOGLE_GEMINI_API_KEY'];

      if (apiKey == null || apiKey.isEmpty) {
        throw Exception('GOOGLE_GEMINI_API_KEY not found in .env file');
      }

      print('   ✅ [GEMINI AI] API key loaded from environment');

      // Initialize SharedPreferences for caching
      _prefs = await SharedPreferences.getInstance();
      print('   ✅ [GEMINI AI] Cache system initialized');

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

  /// Generate cache key for plant/deficiency combination
  String _getCacheKey(String plantName, String deficiencyName) {
    return '$_cachePrefix${plantName}_$deficiencyName'.toLowerCase().replaceAll(' ', '_');
  }

  /// Cache a Gemini API response
  Future<void> _cacheResult(
    String plantName,
    String deficiencyName,
    Map<String, dynamic> result,
  ) async {
    try {
      final key = _getCacheKey(plantName, deficiencyName);
      final cacheData = {
        'result': result,
        'timestamp': DateTime.now().toIso8601String(),
      };
      await _prefs.setString(key, jsonEncode(cacheData));
      print('   💾 [GEMINI AI] Response cached for $plantName - $deficiencyName');
    } catch (e) {
      print('   ⚠️  [GEMINI AI] Failed to cache response: $e');
    }
  }

  /// Retrieve cached Gemini API response
  Future<Map<String, dynamic>?> _getCachedResult(
    String plantName,
    String deficiencyName,
  ) async {
    try {
      final key = _getCacheKey(plantName, deficiencyName);
      final cached = _prefs.getString(key);

      if (cached == null) return null;

      final cacheData = jsonDecode(cached) as Map<String, dynamic>;
      final timestamp = DateTime.parse(cacheData['timestamp'] as String);

      // Check if cache is still valid
      if (DateTime.now().difference(timestamp) > _cacheTTL) {
        await _prefs.remove(key);
        print('   🗑️  [GEMINI AI] Cache expired for $plantName - $deficiencyName');
        return null;
      }

      print('   ✅ [GEMINI AI] Cache hit for $plantName - $deficiencyName');
      return cacheData['result'] as Map<String, dynamic>;
    } catch (e) {
      print('   ⚠️  [GEMINI AI] Failed to retrieve cached response: $e');
      return null;
    }
  }

  /// Generate enhanced plant deficiency information with caching and quota handling
  ///
  /// Parameters:
  /// - [plantName]: Name of the plant species
  /// - [deficiencyName]: Name of detected deficiency (or "Healthy")
  /// - [confidence]: ML model confidence score (0.0 - 1.0)
  /// - [isHealthy]: Whether the plant is healthy (changes prompt behavior)
  /// - [retryCount]: Internal retry counter for exponential backoff (do not set manually)
  /// - [maxRetries]: Maximum number of retry attempts (default: 3)
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
  ///
  /// Features:
  /// - Checks cache first (30-day TTL)
  /// - Quota exceeded detection with fallback
  /// - Exponential backoff retry (2s, 4s, 8s)
  /// - Caches successful responses
  Future<Map<String, dynamic>> generateDeficiencyInfo({
    required String plantName,
    required String deficiencyName,
    required double confidence,
    bool isHealthy = false,
    int retryCount = 0,
    int maxRetries = 3,
  }) async {
    print('\n🌟 [GEMINI AI] Generating enhanced ${isHealthy ? 'care' : 'deficiency'} info...');
    print('   Plant: $plantName');
    print('   Status: ${isHealthy ? 'Healthy' : 'Deficient'}');
    print('   ${isHealthy ? 'Health' : 'Deficiency'}: $deficiencyName');
    print('   Confidence: ${(confidence * 100).toStringAsFixed(2)}%');

    if (!_isInitialized) {
      await initialize();
    }

    // Check cache first
    final cached = await _getCachedResult(plantName, deficiencyName);
    if (cached != null) {
      print('   ⚡ [GEMINI AI] Returning cached response (instant)');
      return cached;
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

        // Cache the successful response
        await _cacheResult(plantName, deficiencyName, result);

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
      final errorStr = e.toString().toLowerCase();

      // Check if this is a quota exceeded error
      if (errorStr.contains('quota') ||
          errorStr.contains('429') ||
          errorStr.contains('exceeded') ||
          errorStr.contains('rate limit')) {

        print('   ⚠️  [GEMINI AI] Quota exceeded detected!');
        print('   💡 [GEMINI AI] Using fallback data (quota-limited mode)');

        // Return fallback with quota marker
        return _getFallbackDeficiencyInfo(
          plantName: plantName,
          deficiencyName: deficiencyName,
          confidence: confidence,
          isHealthy: isHealthy,
          isQuotaExceeded: true,
        );
      }

      // For other transient errors, implement exponential backoff retry
      if (retryCount < maxRetries) {
        final delaySeconds = 2 << retryCount; // 2^(retryCount+1): 2s, 4s, 8s
        print('   ⏳ [GEMINI AI] Temporary error, retrying in ${delaySeconds}s...');
        print('      Attempt ${retryCount + 1}/$maxRetries');
        print('      Error: $e');

        await Future.delayed(Duration(seconds: delaySeconds));

        return generateDeficiencyInfo(
          plantName: plantName,
          deficiencyName: deficiencyName,
          confidence: confidence,
          isHealthy: isHealthy,
          retryCount: retryCount + 1,
          maxRetries: maxRetries,
        );
      }

      // All retries failed
      print('   🚨 [GEMINI AI] All retry attempts failed');
      print('   Error: $e');
      print('   Stack Trace: $stackTrace');
      print('   💡 [GEMINI AI] Using fallback data');

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

  /// Fallback deficiency information when API fails or quota exceeded
  Map<String, dynamic> _getFallbackDeficiencyInfo({
    required String plantName,
    required String deficiencyName,
    required double confidence,
    required bool isHealthy,
    bool isQuotaExceeded = false,
  }) {
    if (isQuotaExceeded) {
      print('   ℹ️  [GEMINI AI] Using fallback (Quota Exceeded Mode)');
      print('   📊 [GEMINI AI] Free tier limit: 20 requests/day reached');
      print('   💡 [GEMINI AI] Tip: Enable billing or wait for quota reset');
    } else {
      print('   ℹ️  [GEMINI AI] Using fallback ${isHealthy ? 'care' : 'deficiency'} information');
    }

    final Map<String, dynamic> result;

    if (isHealthy) {
      // Plant-specific fallback for healthy plants
      result = _getPlantSpecificHealthyFallback(plantName);
    } else {
      // Deficiency-specific fallback for deficient plants
      result = _getDeficiencySpecificFallback(
        plantName,
        deficiencyName,
        confidence,
      );
    }

    // Add quota marker if applicable
    if (isQuotaExceeded) {
      result['_isQuotaExceeded'] = true;
      result['_quotaMessage'] = 'Daily AI limit reached. Showing default information.';
    }

    return result;
  }

  /// Get plant-specific care tips for healthy plants
  Map<String, dynamic> _getPlantSpecificHealthyFallback(String plantName) {
    final plant = plantName.toLowerCase();

    if (plant.contains('rice')) {
      return {
        'careTips': [
          'Maintain 2-5 inches of standing water in the field during vegetative growth',
          'Apply nitrogen fertilizer in 3 splits: at transplanting, active tillering, and panicle initiation stages',
          'Ensure 6-8 hours of direct sunlight daily for optimal photosynthesis',
          'Monitor water pH and keep it between 5.5-6.5 for best nutrient uptake',
          'Check for pest activity weekly, especially stem borers and leaf folders',
        ],
        'preventiveCare': [
          'Practice crop rotation with legumes to naturally improve soil nitrogen',
          'Remove crop residues after harvest to reduce disease carryover',
          'Maintain proper plant spacing (20x20 cm) for air circulation',
          'Apply silicon fertilizers to strengthen stems and improve lodging resistance',
          'Scout for early signs of nutrient deficiency or disease every 3-4 days',
        ],
        'growthOptimization': [
          'Use certified disease-resistant rice varieties suited to your region',
          'Apply phosphorus and potassium at land preparation stage',
          'Implement alternate wetting and drying (AWD) irrigation to save water and promote root growth',
          'Apply zinc sulfate if soil is deficient to prevent stunted growth',
          'Maintain 2-3 healthy tillers per plant by removing weak or diseased tillers',
          'Top-dress with potassium during grain filling for better yield quality',
        ],
      };
    } else if (plant.contains('corn')) {
      return {
        'careTips': [
          'Water deeply 1-2 times per week, providing 1-1.5 inches of water each time',
          'Side-dress with nitrogen fertilizer when plants reach knee-high (V6 stage)',
          'Ensure plants receive at least 8 hours of full sunlight daily',
          'Maintain soil pH between 6.0-6.8 for optimal nutrient availability',
          'Monitor for corn borers, armyworms, and aphids weekly during growing season',
        ],
        'preventiveCare': [
          'Practice 2-3 year crop rotation to prevent soil-borne diseases',
          'Plant in blocks rather than single rows to ensure better pollination',
          'Remove and destroy diseased plants immediately to prevent spread',
          'Apply mulch around plants to conserve moisture and suppress weeds',
          'Scout for signs of nitrogen, phosphorus, or potassium deficiency every week',
        ],
        'growthOptimization': [
          'Use hybrid varieties resistant to common local diseases',
          'Apply starter fertilizer (low nitrogen, high phosphorus) at planting',
          'Thin seedlings to 8-12 inches apart for optimal spacing',
          'Apply additional potassium during silking and grain fill stages',
          'Control weeds early - corn is most competitive after V6 stage',
          'Monitor soil moisture during tasseling and silking (critical stages)',
        ],
      };
    } else if (plant.contains('okra')) {
      return {
        'careTips': [
          'Water consistently, providing 1 inch of water per week through drip or soaker hose',
          'Apply balanced NPK fertilizer (10-10-10) every 3-4 weeks during production',
          'Ensure 6-8 hours of full sun daily for maximum pod production',
          'Maintain soil pH between 6.5-7.0 for healthy growth',
          'Harvest pods when 2-4 inches long (every 2-3 days) to encourage continuous production',
        ],
        'preventiveCare': [
          'Mulch around plants with 2-3 inches of organic matter to retain moisture',
          'Inspect plants weekly for aphids, spider mites, and stink bugs',
          'Remove any yellowing or diseased leaves promptly',
          'Avoid overhead watering to reduce fungal disease risk',
          'Practice crop rotation - do not plant okra in same spot for 2-3 years',
        ],
        'growthOptimization': [
          'Use disease-resistant varieties like "Clemson Spineless" or "Annie Oakley"',
          'Space plants 12-18 inches apart in rows 3-4 feet apart',
          'Side-dress with compost or aged manure mid-season for sustained nutrients',
          'Prune lower leaves once pods begin forming to improve air circulation',
          'Apply foliar spray of seaweed extract for micronutrient boost',
          'Keep soil consistently moist but not waterlogged - okra is drought-tolerant but produces better with regular water',
        ],
      };
    } else if (plant.contains('cucumber')) {
      return {
        'careTips': [
          'Water deeply 1-2 times per week, providing 1-2 inches of water at soil level',
          'Apply balanced fertilizer every 2-3 weeks during fruiting season',
          'Provide 6-8 hours of direct sunlight with some afternoon shade in hot climates',
          'Maintain soil pH between 6.0-6.8 for optimal nutrient uptake',
          'Check plants daily for pests like cucumber beetles and aphids',
        ],
        'preventiveCare': [
          'Use trellis or cage support to keep fruits off ground and improve air circulation',
          'Mulch with straw or wood chips to maintain moisture and prevent soil splash',
          'Remove overripe or diseased fruits immediately to prevent disease spread',
          'Practice 3-year crop rotation to avoid soil-borne diseases',
          'Inspect undersides of leaves weekly for powdery mildew or downy mildew',
        ],
        'growthOptimization': [
          'Choose disease-resistant varieties like "Marketmore 76" or "Diva"',
          'Plant in raised beds or mounds with excellent drainage',
          'Apply calcium-rich amendments to prevent blossom end rot',
          'Pinch off first flowers to encourage stronger root and vine development',
          'Side-dress with compost when vines begin to run',
          'Harvest cucumbers when 6-8 inches long for best quality and continued production',
        ],
      };
    }

    // Generic fallback for unknown plants
    return {
      'careTips': [
        'Maintain regular watering schedule appropriate for $plantName',
        'Provide adequate sunlight based on plant requirements (usually 6-8 hours)',
        'Apply balanced NPK fertilizer every 2-4 weeks during active growth',
        'Monitor soil moisture - keep consistently moist but avoid waterlogging',
        'Inspect plants weekly for pests, diseases, and nutrient deficiency signs',
      ],
      'preventiveCare': [
        'Practice crop rotation to prevent soil depletion and disease buildup',
        'Maintain proper plant spacing for good air circulation',
        'Remove diseased plant material promptly to prevent spread',
        'Use mulch to conserve soil moisture and suppress weeds',
        'Keep garden tools clean and sanitized between uses',
      ],
      'growthOptimization': [
        'Use certified seeds or disease-resistant varieties when available',
        'Test soil pH and adjust to optimal range for $plantName',
        'Apply organic matter or compost to improve soil structure',
        'Implement integrated pest management (IPM) strategies',
        'Monitor plant growth stages and adjust care accordingly',
        'Maintain detailed records of fertilization and pest/disease incidents',
      ],
    };
  }

  /// Get deficiency-specific treatment information
  Map<String, dynamic> _getDeficiencySpecificFallback(
    String plantName,
    String deficiencyName,
    double confidence,
  ) {
    final deficiency = deficiencyName.toLowerCase();

    // Nitrogen Deficiency
    if (deficiency.contains('nitrogen')) {
      return {
        'severity': _calculateSeverity(confidence),
        'symptoms': [
          'Yellowing (chlorosis) of older leaves, starting from leaf tips and moving inward',
          'Stunted plant growth with reduced overall vigor and height',
          'Pale green to yellow coloration across the entire plant',
          'Reduced tillering in rice or fewer side shoots in other crops',
          'Lower leaves may brown and fall off prematurely',
        ],
        'treatments': [
          {
            'title': 'Quick Nitrogen Boost',
            'description': 'Apply urea (46-0-0) at 20-30 kg/ha or ammonium sulfate at 40-50 kg/ha. For small gardens, use 1 tablespoon per plant. Water immediately after application.',
            'icon': 'fertilizer',
          },
          {
            'title': 'Foliar Spray (Fast Acting)',
            'description': 'Mix 2% urea solution (20g urea per liter water) and spray on leaves early morning or late evening. Repeat every 7-10 days until symptoms improve.',
            'icon': 'spray',
          },
          {
            'title': 'Organic Amendment',
            'description': 'Incorporate well-composted manure (2-3 tons/ha) or apply fish emulsion (diluted 1:10 with water) weekly. Blood meal is also effective for organic growers.',
            'icon': 'organic',
          },
        ],
        'prevention': [
          'Split nitrogen application into 2-3 doses throughout growing season instead of single application',
          'Incorporate green manure crops or cover crops (legumes) to naturally fix nitrogen',
          'Use slow-release nitrogen fertilizers to minimize leaching losses',
          'Avoid over-irrigation which causes nitrogen to leach beyond root zone',
          'Test soil nitrogen levels before planting and adjust application rates',
          'Apply organic matter regularly to improve soil nitrogen retention',
        ],
      };
    }

    // Bacterial Leaf Blight
    if (deficiency.contains('bacterial') && deficiency.contains('blight')) {
      return {
        'severity': _calculateSeverity(confidence),
        'symptoms': [
          'Water-soaked lesions on leaves that turn yellow to white with wavy margins',
          'Bacterial ooze (milky or opaque droplets) visible on lesions in early morning',
          'Lesions may coalesce and cause entire leaves to wilt and die',
          'Systemic infection can cause wilting of entire plant (kresek phase in rice)',
          'Symptoms worsen during warm, humid weather with heavy dew or rain',
        ],
        'treatments': [
          {
            'title': 'Copper-Based Bactericide',
            'description': 'Apply copper hydroxide or copper oxychloride spray at 2-3 g/L. Spray every 7-10 days, especially after rain. Best used as preventive measure.',
            'icon': 'spray',
          },
          {
            'title': 'Remove Infected Material',
            'description': 'Cut and destroy severely infected leaves and plants. Burn or bury deeply - do NOT compost. Disinfect tools with 10% bleach solution between cuts.',
            'icon': 'cut',
          },
          {
            'title': 'Improve Drainage',
            'description': 'Reduce standing water in fields and improve drainage to lower humidity around plants. Allow fields to dry between irrigations if possible.',
            'icon': 'water_drop',
          },
          {
            'title': 'Boost Plant Resistance',
            'description': 'Apply potassium fertilizers to strengthen cell walls. Avoid excessive nitrogen which promotes lush growth susceptible to infection.',
            'icon': 'shield',
          },
        ],
        'prevention': [
          'Use certified disease-free seeds and resistant rice varieties',
          'Practice balanced fertilization - avoid excessive nitrogen',
          'Maintain proper plant spacing (20x20 cm for rice) for air circulation',
          'Remove crop residues after harvest and practice field sanitation',
          'Avoid working in wet fields to prevent spreading bacteria',
          'Implement crop rotation where possible',
          'Apply prophylactic copper sprays during monsoon season',
        ],
      };
    }

    // Rice Blast
    if (deficiency.contains('blast')) {
      return {
        'severity': 'Severe',
        'symptoms': [
          'Diamond or spindle-shaped lesions with gray-white centers and brown margins on leaves',
          'Lesions start small (1-2mm) and expand rapidly under favorable conditions',
          'Neck rot causing panicles to break and droop (panicle blast)',
          'White to gray fungal growth visible on lesions during high humidity',
          'Severely infected leaves may die completely, reducing photosynthesis',
        ],
        'treatments': [
          {
            'title': 'Systemic Fungicide Application',
            'description': 'Apply tricyclazole 75% WP at 0.6g/L or azoxystrobin at labeled rate. Spray at early signs and repeat every 10-14 days. Mix with sticker for better adhesion.',
            'icon': 'spray',
          },
          {
            'title': 'Remove Severely Infected Plants',
            'description': 'Cut and destroy plants with neck rot or >50% leaf infection. Remove from field immediately - do not leave in field or compost pile.',
            'icon': 'cut',
          },
          {
            'title': 'Adjust Water Management',
            'description': 'Drain fields temporarily to reduce humidity if blast is severe. Use intermittent irrigation instead of continuous flooding.',
            'icon': 'water_drop',
          },
          {
            'title': 'Silicon Supplementation',
            'description': 'Apply silicon fertilizer (calcium silicate) at 200-400 kg/ha to strengthen plant cell walls and improve disease resistance.',
            'icon': 'fertilizer',
          },
        ],
        'prevention': [
          'Use blast-resistant rice varieties adapted to your region',
          'Avoid excessive nitrogen application which promotes lush, susceptible growth',
          'Apply nitrogen in splits rather than single large dose',
          'Maintain proper spacing and avoid dense planting',
          'Remove volunteer rice plants and weed hosts from field margins',
          'Treat seeds with fungicide before planting',
          'Apply prophylactic fungicide before rainy season if blast is historically problematic',
          'Practice field sanitation - plow under residues after harvest',
        ],
      };
    }

    // Brown Spot
    if (deficiency.contains('brown') && deficiency.contains('spot')) {
      return {
        'severity': _calculateSeverity(confidence),
        'symptoms': [
          'Small circular to oval brown spots with yellow halos on leaves',
          'Spots may have dark brown margins and lighter centers',
          'Lesions can appear on leaf sheaths, panicles, and grains',
          'Severely infected leaves turn brown and dry up',
          'Disease more severe in nutrient-deficient fields',
        ],
        'treatments': [
          {
            'title': 'Fungicide Spray',
            'description': 'Apply mancozeb 75% WP at 2g/L or chlorothalonil at recommended rate. Spray at 7-10 day intervals until symptoms stop spreading.',
            'icon': 'spray',
          },
          {
            'title': 'Improve Soil Fertility',
            'description': 'Brown spot thrives in nutrient-poor soil. Apply balanced NPK fertilizer and correct any silicon, zinc, or potassium deficiencies immediately.',
            'icon': 'fertilizer',
          },
          {
            'title': 'Foliar Nutrition',
            'description': 'Apply foliar spray containing zinc (0.5% ZnSO4), potassium, and micronutrients to boost plant immunity and recover from stress.',
            'icon': 'leaf',
          },
        ],
        'prevention': [
          'Maintain balanced soil fertility - brown spot is more severe in poor soil',
          'Use resistant varieties when available',
          'Treat seeds with fungicide (thiram or carbendazim) before planting',
          'Avoid water stress - maintain adequate soil moisture',
          'Practice crop rotation and proper field sanitation',
          'Apply silicon and zinc fertilizers to strengthen plant defenses',
        ],
      };
    }

    // Potassium Deficiency
    if (deficiency.contains('potassium')) {
      return {
        'severity': _calculateSeverity(confidence),
        'symptoms': [
          'Yellowing and browning of leaf margins and tips (scorching)',
          'Older leaves affected first, progressing to younger leaves',
          'Weak stems prone to lodging (falling over)',
          'Poor root development and reduced drought tolerance',
          'Reduced fruit or grain quality and size',
        ],
        'treatments': [
          {
            'title': 'Potassium Fertilizer Application',
            'description': 'Apply muriate of potash (KCl 60% K2O) at 30-40 kg/ha or potassium sulfate for sulfur-sensitive crops. Water in thoroughly after application.',
            'icon': 'fertilizer',
          },
          {
            'title': 'Foliar Potassium Spray',
            'description': 'Spray 1-2% potassium sulfate or potassium nitrate solution on leaves for quick uptake. Repeat weekly for 3-4 weeks.',
            'icon': 'spray',
          },
          {
            'title': 'Organic Potassium Sources',
            'description': 'Apply wood ash (5% K), kelp meal, or greensand. Compost and aged manure also provide slow-release potassium.',
            'icon': 'organic',
          },
        ],
        'prevention': [
          'Test soil potassium levels annually and maintain optimal levels',
          'Apply potassium in split doses during vegetative and reproductive stages',
          'Avoid excessive calcium or magnesium which can reduce potassium uptake',
          'Improve soil organic matter to increase potassium retention',
          'Use balanced NPK fertilizers rather than high-nitrogen formulations alone',
        ],
      };
    }

    // Generic fallback for unknown deficiencies
    return {
      'severity': _calculateSeverity(confidence),
      'symptoms': [
        'Visual symptoms of $deficiencyName observed on $plantName',
        'Changes in leaf color, texture, or shape indicating stress',
        'Abnormal growth patterns or reduced plant vigor',
        'Possible discoloration, lesions, or spotting on plant tissue',
        'Symptoms may vary in severity depending on environmental conditions',
      ],
      'treatments': [
        {
          'title': 'Consult Agricultural Expert',
          'description': 'Contact your local agricultural extension office or plant pathologist for specific diagnosis and treatment for $deficiencyName in $plantName.',
          'icon': 'help',
        },
        {
          'title': 'Maintain Plant Health',
          'description': 'Ensure proper watering, balanced nutrition, and good field sanitation while seeking professional advice for specific treatment.',
          'icon': 'care',
        },
        {
          'title': 'Isolate Affected Plants',
          'description': 'If disease is suspected, isolate affected plants to prevent potential spread. Remove severely affected plants if necessary.',
          'icon': 'warning',
        },
      ],
      'prevention': [
        'Regular monitoring and early detection of plant health issues',
        'Maintain balanced soil nutrition with proper pH levels (6.0-7.0)',
        'Practice good field hygiene and sanitation',
        'Use certified disease-free seeds and resistant varieties',
        'Implement integrated pest and disease management practices',
        'Maintain detailed crop health records for pattern identification',
      ],
    };
  }

  /// Ask a general agricultural question to Gemini AI
  ///
  /// This method is used for FAQ-style questions and conversational queries
  /// about plant care, deficiencies, treatments, etc.
  ///
  /// Parameters:
  /// - [question]: The question or prompt to ask Gemini
  ///
  /// Returns:
  /// - A plain text answer from Gemini AI
  ///
  /// Features:
  /// - Uses same caching system as deficiency info (30-day TTL)
  /// - Quota handling with graceful fallback
  /// - Optimized for concise, actionable agricultural advice
  Future<String> askGeneralQuestion(String question) async {
    print('\n💬 [GEMINI AI] Asking general question to Gemini...');
    print('   Question: $question');

    if (!_isInitialized) {
      await initialize();
    }

    // Create simple cache key for general questions
    final cacheKey = '$_cachePrefix${'general_${question.hashCode}'}'.toLowerCase();

    // Check cache first
    try {
      final cached = _prefs.getString(cacheKey);
      if (cached != null) {
        final cacheData = jsonDecode(cached) as Map<String, dynamic>;
        final timestamp = DateTime.parse(cacheData['timestamp'] as String);

        // Check if cache is still valid
        if (DateTime.now().difference(timestamp) <= _cacheTTL) {
          print('   ✅ [GEMINI AI] Cache hit for general question');
          return cacheData['answer'] as String;
        } else {
          await _prefs.remove(cacheKey);
          print('   🗑️  [GEMINI AI] Cache expired for general question');
        }
      }
    } catch (e) {
      print('   ⚠️  [GEMINI AI] Cache read error: $e');
    }

    try {
      // Create prompt for general agricultural questions
      final prompt = '''
You are an expert agricultural scientist and plant pathologist.

Answer the following question with practical, actionable advice:

$question

Guidelines:
1. Be specific and concise (2-3 paragraphs maximum)
2. Provide actionable steps when applicable
3. Use professional but accessible language
4. Focus on practical farming advice
5. If mentioning products/chemicals, include application rates
6. Prioritize organic and sustainable methods when relevant

Response:''';

      print('   📝 [GEMINI AI] Sending question to Gemini API...');

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      print('   ✅ [GEMINI AI] Received response from Gemini API');

      if (response.text == null || response.text!.isEmpty) {
        throw Exception('Empty response from Gemini API');
      }

      final answer = response.text!.trim();

      // Cache the response
      try {
        final cacheData = {
          'answer': answer,
          'timestamp': DateTime.now().toIso8601String(),
        };
        await _prefs.setString(cacheKey, jsonEncode(cacheData));
        print('   💾 [GEMINI AI] Response cached for general question');
      } catch (e) {
        print('   ⚠️  [GEMINI AI] Failed to cache response: $e');
      }

      return answer;
    } catch (e) {
      final errorStr = e.toString().toLowerCase();

      // Check if this is a quota exceeded error
      if (errorStr.contains('quota') ||
          errorStr.contains('429') ||
          errorStr.contains('exceeded') ||
          errorStr.contains('rate limit')) {
        print('   ⚠️  [GEMINI AI] Quota exceeded for general question!');
        print('   💡 [GEMINI AI] Using fallback response');

        return '''I apologize, but I've reached my daily AI request limit.

However, I can provide some general advice:

For plant health questions, ensure your plants receive:
- Adequate water (1-2 inches per week for most crops)
- Full sunlight (6-8 hours daily)
- Balanced NPK fertilizer every 2-4 weeks
- Regular monitoring for pests and diseases

For specific deficiency or disease questions, please:
1. Use the Scan feature to analyze your plant
2. Consult your local agricultural extension office
3. Visit the Library tab for detailed plant care guides

The AI will be available again tomorrow!''';
      }

      // Other errors - provide generic fallback
      print('   🚨 [GEMINI AI] Error asking general question: $e');
      print('   💡 [GEMINI AI] Using fallback response');

      return '''I encountered an error processing your question. Here's some general guidance:

For plant care questions:
- Maintain consistent watering and fertilization schedules
- Monitor plants regularly for signs of stress or disease
- Use the Scan feature to diagnose specific plant issues
- Check the Library tab for detailed plant information

For specific agricultural advice, please:
1. Consult your local agricultural extension office
2. Contact plant pathology experts in your region
3. Try asking the question again later

I apologize for the inconvenience!''';
    }
  }

  /// Start a conversational chat session with history
  ///
  /// Creates a ChatSession that maintains conversation context.
  /// Used for messenger-style chat where AI remembers previous messages.
  ///
  /// Parameters:
  /// - [history]: List of previous messages (Content objects with role and text)
  ///
  /// Returns:
  /// - ChatSession that can send/receive messages with context
  ///
  /// Example:
  /// ```dart
  /// final history = await loadConversationHistory(conversationId);
  /// final chat = await startConversation(history: history);
  /// final response = await chat.sendMessage(Content.text('Your question'));
  /// ```
  Future<ChatSession> startConversation({
    List<Content> history = const [],
  }) async {
    print('\n💬 [GEMINI AI CHAT] Starting conversational chat session...');
    print('   History messages: ${history.length}');

    if (!_isInitialized) {
      await initialize();
    }

    // Truncate history if too long (keep last 40 messages to stay within token limits)
    final truncatedHistory = _truncateHistory(history, maxMessages: 40);
    if (truncatedHistory.length < history.length) {
      print('   ✂️  [GEMINI AI CHAT] Truncated history from ${history.length} to ${truncatedHistory.length} messages');
    }

    // Create chat session with history
    final chatSession = _model.startChat(
      history: truncatedHistory,
      generationConfig: GenerationConfig(
        temperature: 0.8, // Slightly higher for natural conversation
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 512, // Shorter responses for chat
      ),
    );

    print('   ✅ [GEMINI AI CHAT] Chat session started successfully');
    return chatSession;
  }

  /// Send a message in an existing chat session
  ///
  /// Sends user message and gets AI response with full conversation context.
  ///
  /// Parameters:
  /// - [chatSession]: The active chat session
  /// - [message]: User's message text
  ///
  /// Returns:
  /// - AI's response text
  ///
  /// Throws:
  /// - Exception if quota exceeded or API error
  Future<String> sendChatMessage({
    required ChatSession chatSession,
    required String message,
  }) async {
    print('\n💬 [GEMINI AI CHAT] Sending message...');
    print('   Message: ${message.length > 100 ? '${message.substring(0, 100)}...' : message}');

    try {
      final response = await chatSession.sendMessage(Content.text(message));

      if (response.text == null || response.text!.isEmpty) {
        throw Exception('Empty response from Gemini AI');
      }

      print('   ✅ [GEMINI AI CHAT] Received response');
      print('   Response length: ${response.text!.length} characters');

      return response.text!.trim();
    } catch (e) {
      final errorStr = e.toString().toLowerCase();

      // Check for quota exceeded
      if (errorStr.contains('quota') ||
          errorStr.contains('429') ||
          errorStr.contains('exceeded') ||
          errorStr.contains('rate limit')) {
        print('   ⚠️  [GEMINI AI CHAT] Quota exceeded!');
        throw Exception('QUOTA_EXCEEDED');
      }

      print('   🚨 [GEMINI AI CHAT] Error sending message: $e');
      rethrow;
    }
  }

  /// Load conversation history from database
  ///
  /// Converts AIMessage objects to Gemini Content format for chat context.
  ///
  /// Parameters:
  /// - [messages]: List of AIMessage objects from database
  ///
  /// Returns:
  /// - List of Content objects for Gemini chat history
  List<Content> buildChatHistory(List<dynamic> messages) {
    print('\n📚 [GEMINI AI CHAT] Building chat history...');
    print('   Total messages: ${messages.length}');

    final history = <Content>[];

    for (final msg in messages) {
      try {
        final senderType = msg['sender_type'] as String;
        final messageText = msg['message_text'] as String;

        // Map sender_type to Gemini role
        final role = senderType == 'user' ? 'user' : 'model';

        history.add(Content(role, [TextPart(messageText)]));
      } catch (e) {
        print('   ⚠️  [GEMINI AI CHAT] Error parsing message: $e');
      }
    }

    print('   ✅ [GEMINI AI CHAT] Chat history built: ${history.length} messages');
    return history;
  }

  /// Truncate conversation history to stay within token limits
  ///
  /// Keeps only the most recent N messages to avoid exceeding
  /// Gemini's context window (~8k tokens).
  ///
  /// Parameters:
  /// - [history]: Full conversation history
  /// - [maxMessages]: Maximum number of messages to keep (default: 40)
  ///
  /// Returns:
  /// - Truncated history (most recent messages)
  List<Content> _truncateHistory(List<Content> history, {int maxMessages = 40}) {
    if (history.length <= maxMessages) {
      return history;
    }

    // Keep most recent messages
    return history.sublist(history.length - maxMessages);
  }

  /// Dispose resources
  void dispose() {
    print('🗑️  [GEMINI AI] Disposing Gemini AI service');
    _isInitialized = false;
  }
}
