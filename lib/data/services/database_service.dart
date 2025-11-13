import 'package:fyllens/data/services/supabase_service.dart';

/// Database service
/// Handles CRUD operations with Supabase database
class DatabaseService {
  final SupabaseService _supabaseService = SupabaseService.instance;

  /// Generic method to fetch all records from a table
  Future<List<Map<String, dynamic>>> fetchAll(String tableName) async {
    // TODO: Implement fetch all logic
    final response = await _supabaseService.from(tableName).select();
    return List<Map<String, dynamic>>.from(response);
  }

  /// Generic method to fetch a single record by ID
  Future<Map<String, dynamic>?> fetchById(String tableName, String id) async {
    // TODO: Implement fetch by ID logic
    final response = await _supabaseService
        .from(tableName)
        .select()
        .eq('id', id)
        .maybeSingle();
    return response;
  }

  /// Generic method to insert a record
  Future<Map<String, dynamic>> insert(
    String tableName,
    Map<String, dynamic> data,
  ) async {
    // TODO: Implement insert logic
    final response = await _supabaseService
        .from(tableName)
        .insert(data)
        .select()
        .single();
    return response;
  }

  /// Generic method to update a record
  Future<Map<String, dynamic>> update(
    String tableName,
    String id,
    Map<String, dynamic> data,
  ) async {
    // TODO: Implement update logic
    final response = await _supabaseService
        .from(tableName)
        .update(data)
        .eq('id', id)
        .select()
        .single();
    return response;
  }

  /// Generic method to delete a record
  Future<void> delete(String tableName, String id) async {
    // TODO: Implement delete logic
    await _supabaseService.from(tableName).delete().eq('id', id);
  }

  /// Query with custom filters
  Future<List<Map<String, dynamic>>> query(
    String tableName, {
    String? column,
    dynamic value,
  }) async {
    // TODO: Implement custom query logic
    var query = _supabaseService.from(tableName).select();

    if (column != null && value != null) {
      query = query.eq(column, value);
    }

    final response = await query;
    return List<Map<String, dynamic>>.from(response);
  }
}
