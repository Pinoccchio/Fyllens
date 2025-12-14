import 'package:flutter/foundation.dart';
import 'package:fyllens/models/plant.dart';
import 'package:fyllens/models/deficiency.dart';
import 'package:fyllens/services/supabase_service.dart';

/// Library provider - manages plant library and deficiency data
class LibraryProvider with ChangeNotifier {
  final _supabase = SupabaseService.instance.client;

  // State for library screen
  List<Plant> _plants = [];
  List<Plant> _filteredPlants = [];
  bool _isLoadingPlants = false;
  String? _plantsError;
  String _searchQuery = '';

  // State for plant detail screen
  Plant? _currentPlant;
  List<Deficiency> _currentDeficiencies = [];
  bool _isLoadingDetail = false;
  String? _detailError;

  // Getters for library screen
  List<Plant> get plants => _filteredPlants;
  bool get isLoadingPlants => _isLoadingPlants;
  String? get plantsError => _plantsError;
  String get searchQuery => _searchQuery;
  bool get hasError => _plantsError != null;
  bool get isEmpty => _filteredPlants.isEmpty && !_isLoadingPlants;

  // Getters for plant detail screen
  Plant? get currentPlant => _currentPlant;
  List<Deficiency> get currentDeficiencies => _currentDeficiencies;
  bool get isLoadingDetail => _isLoadingDetail;
  String? get detailError => _detailError;
  bool get hasDetailError => _detailError != null;
  bool get hasPlantData => _currentPlant != null;

  /// Load all plants from Supabase
  Future<void> loadPlants() async {
    _isLoadingPlants = true;
    _plantsError = null;
    notifyListeners();

    try {
      final response = await _supabase
          .from('plants')
          .select()
          .order('name', ascending: true);

      _plants = (response as List)
          .map((json) => Plant.fromJson(json))
          .toList();

      _filteredPlants = _plants;
      _isLoadingPlants = false;
      notifyListeners();
    } catch (e) {
      _plantsError = 'Failed to load plants: $e';
      _isLoadingPlants = false;
      notifyListeners();
    }
  }

  /// Search plants by name
  Future<void> searchPlants(String query) async {
    _searchQuery = query;

    // If query is empty, show all plants
    if (query.trim().isEmpty) {
      _filteredPlants = _plants;
      notifyListeners();
      return;
    }

    _isLoadingPlants = true;
    _plantsError = null;
    notifyListeners();

    try {
      final response = await _supabase
          .from('plants')
          .select()
          .ilike('name', '%$query%')
          .order('name', ascending: true);

      _filteredPlants = (response as List)
          .map((json) => Plant.fromJson(json))
          .toList();

      _isLoadingPlants = false;
      notifyListeners();
    } catch (e) {
      _plantsError = 'Failed to search plants: $e';
      _isLoadingPlants = false;
      notifyListeners();
    }
  }

  /// Clear search and show all plants
  void clearSearch() {
    _searchQuery = '';
    _filteredPlants = _plants;
    notifyListeners();
  }

  /// Refresh plant list (pull-to-refresh)
  Future<void> refresh() async {
    await loadPlants();
  }

  /// Load plant detail with deficiencies
  Future<void> loadPlantDetail(String plantId) async {
    _isLoadingDetail = true;
    _detailError = null;
    notifyListeners();

    try {
      // Fetch plant
      final plantResponse = await _supabase
          .from('plants')
          .select()
          .eq('id', plantId)
          .single();

      _currentPlant = Plant.fromJson(plantResponse);

      // Fetch deficiencies for this plant via junction table
      final defResponse = await _supabase
          .from('plant_deficiencies')
          .select('deficiencies(*)')
          .eq('plant_id', plantId);

      _currentDeficiencies = (defResponse as List)
          .map((item) {
            final defJson = item['deficiencies'] as Map<String, dynamic>;
            return Deficiency.fromJson(defJson);
          })
          .toList();

      _isLoadingDetail = false;
      notifyListeners();
    } catch (e) {
      _detailError = 'Failed to load plant details: $e';
      _isLoadingDetail = false;
      notifyListeners();
    }
  }

  /// Clear current plant detail
  void clearPlantDetail() {
    _currentPlant = null;
    _currentDeficiencies = [];
    _detailError = null;
    notifyListeners();
  }

  /// Retry loading plants after error
  Future<void> retryPlants() async {
    await loadPlants();
  }

  /// Retry loading plant detail after error
  Future<void> retryDetail(String plantId) async {
    await loadPlantDetail(plantId);
  }
}
