import 'package:fyllens/data/services/database_service.dart';
import 'package:fyllens/data/models/plant_model.dart';
import 'package:fyllens/data/models/deficiency_model.dart';

/// Plant repository
/// Handles plant and deficiency data operations
class PlantRepository {
  final DatabaseService _databaseService = DatabaseService();

  /// Get all plants
  Future<List<PlantModel>> getAllPlants() async {
    try {
      final results = await _databaseService.fetchAll('plants');
      return results.map((json) => PlantModel.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Get plant by ID
  Future<PlantModel?> getPlantById(String plantId) async {
    try {
      final result = await _databaseService.fetchById('plants', plantId);
      return result != null ? PlantModel.fromJson(result) : null;
    } catch (e) {
      rethrow;
    }
  }

  /// Get plant by species name
  Future<PlantModel?> getPlantBySpecies(String species) async {
    try {
      final results = await _databaseService.query(
        'plants',
        column: 'species',
        value: species,
      );
      return results.isNotEmpty ? PlantModel.fromJson(results.first) : null;
    } catch (e) {
      rethrow;
    }
  }

  /// Get all deficiencies
  Future<List<DeficiencyModel>> getAllDeficiencies() async {
    try {
      final results = await _databaseService.fetchAll('deficiencies');
      return results.map((json) => DeficiencyModel.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Get deficiency by ID
  Future<DeficiencyModel?> getDeficiencyById(String deficiencyId) async {
    try {
      final result = await _databaseService.fetchById('deficiencies', deficiencyId);
      return result != null ? DeficiencyModel.fromJson(result) : null;
    } catch (e) {
      rethrow;
    }
  }

  /// Get deficiency by name
  Future<DeficiencyModel?> getDeficiencyByName(String name) async {
    try {
      final results = await _databaseService.query(
        'deficiencies',
        column: 'name',
        value: name,
      );
      return results.isNotEmpty ? DeficiencyModel.fromJson(results.first) : null;
    } catch (e) {
      rethrow;
    }
  }
}
