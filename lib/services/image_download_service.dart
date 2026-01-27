import 'dart:io';
import 'package:flutter/services.dart';
import 'package:gal/gal.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:logger/logger.dart';

/// Result of an image download operation
class DownloadResult {
  final bool success;
  final String message;
  final String? filePath;

  const DownloadResult({
    required this.success,
    required this.message,
    this.filePath,
  });

  factory DownloadResult.success(String message, [String? filePath]) {
    return DownloadResult(success: true, message: message, filePath: filePath);
  }

  factory DownloadResult.failure(String message) {
    return DownloadResult(success: false, message: message);
  }
}

/// Service for downloading images to device gallery
class ImageDownloadService {
  static ImageDownloadService? _instance;
  static ImageDownloadService get instance =>
      _instance ??= ImageDownloadService._();

  ImageDownloadService._();

  final _logger = Logger(
    printer: PrettyPrinter(methodCount: 0),
  );

  /// Request storage/photo library permissions based on platform
  Future<bool> requestPermissions() async {
    if (Platform.isAndroid) {
      return await _requestAndroidPermissions();
    } else if (Platform.isIOS) {
      return await _requestIOSPermissions();
    }
    return true;
  }

  /// Request Android storage permissions (handles Android 13+ separately)
  Future<bool> _requestAndroidPermissions() async {
    // Check if we have permission to add to gallery
    final hasAccess = await Gal.hasAccess(toAlbum: true);
    if (hasAccess) {
      _logger.i('Gallery access already granted');
      return true;
    }

    // Request access
    final granted = await Gal.requestAccess(toAlbum: true);
    if (granted) {
      _logger.i('Gallery access granted');
      return true;
    }

    _logger.w('Gallery access denied');
    return false;
  }

  /// Request iOS photo library permissions
  Future<bool> _requestIOSPermissions() async {
    final hasAccess = await Gal.hasAccess(toAlbum: true);
    if (hasAccess) {
      _logger.i('Photo library access already granted');
      return true;
    }

    final granted = await Gal.requestAccess(toAlbum: true);
    if (granted) {
      _logger.i('Photo library access granted');
      return true;
    }

    _logger.w('Photo library access denied');
    return false;
  }

  /// Check if permissions are already granted
  Future<bool> hasPermissions() async {
    return await Gal.hasAccess(toAlbum: true);
  }

  /// Save a single image from asset path to device gallery
  Future<DownloadResult> saveAssetImage(
      String assetPath, String fileName) async {
    try {
      _logger.i('Saving asset image: $assetPath');

      // Request permissions if needed
      final hasPerms = await hasPermissions();
      if (!hasPerms) {
        final granted = await requestPermissions();
        if (!granted) {
          return DownloadResult.failure(
            'Storage permission denied. Please enable it in Settings.',
          );
        }
      }

      // Load image from assets
      final ByteData data = await rootBundle.load(assetPath);
      final Uint8List bytes = data.buffer.asUint8List();

      // Get temp directory to save file temporarily
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/$fileName.jpg');
      await tempFile.writeAsBytes(bytes);

      // Save to gallery using Gal
      await Gal.putImage(tempFile.path, album: 'Fyllens');

      // Clean up temp file
      if (await tempFile.exists()) {
        await tempFile.delete();
      }

      _logger.i('Image saved successfully to gallery');
      return DownloadResult.success('Image saved to gallery');
    } on GalException catch (e) {
      _logger.e('Gal error saving image: ${e.type}');
      String message;
      switch (e.type) {
        case GalExceptionType.accessDenied:
          message = 'Storage permission denied. Please enable it in Settings.';
          break;
        case GalExceptionType.notSupportedFormat:
          message = 'Image format not supported';
          break;
        case GalExceptionType.notEnoughSpace:
          message = 'Not enough storage space';
          break;
        default:
          message = 'Failed to save image: ${e.type}';
      }
      return DownloadResult.failure(message);
    } on PlatformException catch (e) {
      _logger.e('Platform error saving image: ${e.message}');
      return DownloadResult.failure('Platform error: ${e.message}');
    } catch (e) {
      _logger.e('Error saving image: $e');
      return DownloadResult.failure('Error saving image: $e');
    }
  }

  /// Save multiple images from asset paths to device gallery
  Future<List<DownloadResult>> saveMultipleAssetImages(
    List<String> assetPaths,
    String plantName, {
    void Function(int current, int total)? onProgress,
  }) async {
    final results = <DownloadResult>[];

    // Request permissions once at the start
    final hasPerms = await hasPermissions();
    if (!hasPerms) {
      final granted = await requestPermissions();
      if (!granted) {
        return [
          DownloadResult.failure(
            'Storage permission denied. Please enable it in Settings.',
          )
        ];
      }
    }

    for (int i = 0; i < assetPaths.length; i++) {
      onProgress?.call(i + 1, assetPaths.length);

      final assetPath = assetPaths[i];
      final fileName = generateFileName(plantName, i);

      final result = await saveAssetImage(assetPath, fileName);
      results.add(result);

      // Small delay between saves to avoid overwhelming the system
      if (i < assetPaths.length - 1) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
    }

    return results;
  }

  /// Generate a clean filename from plant name and index
  String generateFileName(String plantName, int index) {
    final cleanName = plantName
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]'), '_')
        .replaceAll(RegExp(r'_+'), '_');
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'fyllens_${cleanName}_${index + 1}_$timestamp';
  }

  /// Open app settings for the user to manually grant permissions
  Future<bool> openSettings() async {
    return await openAppSettings();
  }
}
