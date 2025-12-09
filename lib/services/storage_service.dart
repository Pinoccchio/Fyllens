import 'dart:io';
import 'package:fyllens/services/supabase_service.dart';

/// Storage service
/// Handles file uploads and downloads using Supabase Storage
class StorageService {
  static StorageService? _instance;
  final SupabaseService _supabaseService;

  StorageService._() : _supabaseService = SupabaseService.instance;

  /// Get singleton instance
  static StorageService get instance {
    _instance ??= StorageService._();
    return _instance!;
  }

  /// Upload an image file
  Future<String> uploadImage({
    required File file,
    required String bucket,
    required String path,
  }) async {
    // TODO: Implement image upload logic
    final bytes = await file.readAsBytes();
    await _supabaseService.storage.from(bucket).uploadBinary(path, bytes);

    // Get public URL
    final url = _supabaseService.storage.from(bucket).getPublicUrl(path);
    return url;
  }

  /// Download a file
  Future<List<int>> downloadFile({
    required String bucket,
    required String path,
  }) async {
    // TODO: Implement file download logic
    final response = await _supabaseService.storage.from(bucket).download(path);
    return response;
  }

  /// Delete a file
  Future<void> deleteFile({
    required String bucket,
    required String path,
  }) async {
    // TODO: Implement file deletion logic
    await _supabaseService.storage.from(bucket).remove([path]);
  }

  /// Get public URL for a file
  String getPublicUrl({
    required String bucket,
    required String path,
  }) {
    return _supabaseService.storage.from(bucket).getPublicUrl(path);
  }

  /// List files in a bucket path
  Future<List> listFiles({
    required String bucket,
    String? path,
  }) async {
    // TODO: Implement list files logic
    final response = await _supabaseService.storage.from(bucket).list(
      path: path,
    );
    return response;
  }
}
