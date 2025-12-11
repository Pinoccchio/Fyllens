import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

/// Full-screen image viewer dialog with pinch-to-zoom functionality
///
/// Displays an image in full-screen mode with the following features:
/// - Pinch to zoom (0.5x to 4x)
/// - Pan to move around when zoomed
/// - Tap outside or press back to dismiss
/// - Loading indicator while image loads
/// - Error handling for failed image loads
class ImageViewerDialog extends StatefulWidget {
  final String imageUrl;
  final String? heroTag;

  const ImageViewerDialog({super.key, required this.imageUrl, this.heroTag});

  /// Show the image viewer dialog
  ///
  /// Example:
  /// ```dart
  /// ImageViewerDialog.show(
  ///   context: context,
  ///   imageUrl: 'https://example.com/image.jpg',
  /// );
  /// ```
  static Future<void> show({
    required BuildContext context,
    required String imageUrl,
    String? heroTag,
  }) {
    return showDialog(
      context: context,
      barrierColor: Colors.black87,
      barrierDismissible: true,
      useSafeArea: false,
      builder: (context) =>
          ImageViewerDialog(imageUrl: imageUrl, heroTag: heroTag),
    );
  }

  @override
  State<ImageViewerDialog> createState() => _ImageViewerDialogState();
}

class _ImageViewerDialogState extends State<ImageViewerDialog> {
  final TransformationController _transformationController =
      TransformationController();
  bool _isLoading = true;
  bool _hasError = false;
  double _currentScale = 1.0;

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  /// Handle tap on the background to dismiss
  void _handleBackgroundTap() {
    // Only dismiss if not zoomed in
    if (_currentScale <= 1.0) {
      Navigator.of(context).pop();
    }
  }

  /// Handle double tap to zoom in/out
  void _handleDoubleTap(TapDownDetails details) {
    if (_currentScale > 1.0) {
      // Zoom out
      _transformationController.value = Matrix4.identity();
      setState(() {
        _currentScale = 1.0;
      });
    } else {
      // Zoom in to 2x at tap location
      final position = details.localPosition;
      const double scale = 2.0;

      final matrix = Matrix4.identity()
        ..translate(-position.dx * (scale - 1), -position.dy * (scale - 1))
        ..scale(scale);

      _transformationController.value = matrix;
      setState(() {
        _currentScale = scale;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      backgroundColor: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Main image with interactive viewer
          GestureDetector(
            onTap: _handleBackgroundTap,
            onDoubleTapDown: _handleDoubleTap,
            child: Center(
              child: InteractiveViewer(
                transformationController: _transformationController,
                minScale: 0.5,
                maxScale: 4.0,
                onInteractionUpdate: (details) {
                  setState(() {
                    _currentScale = details.scale;
                  });
                },
                child: widget.heroTag != null
                    ? Hero(tag: widget.heroTag!, child: _buildImage())
                    : _buildImage(),
              ),
            ),
          ),

          // Loading indicator
          if (_isLoading && !_hasError)
            const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),

          // Error state
          if (_hasError)
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.white70,
                    size: 64,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Failed to load image',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  OutlinedButton.icon(
                    onPressed: () {
                      setState(() {
                        _hasError = false;
                        _isLoading = true;
                      });
                    },
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    label: const Text(
                      'Retry',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white70),
                    ),
                  ),
                ],
              ),
            ),

          // Close button - Top-Left
          Positioned(
            top: 8,
            left: 8,
            child: SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    borderRadius: BorderRadius.circular(28),
                    child: const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Icon(
                        PhosphorIcons.arrowLeftBold,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Zoom level indicator - Top-Center
          if (_currentScale > 1.0)
            Positioned(
              top: 8,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '${_currentScale.toStringAsFixed(1)}x',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // Bottom hint (only show when not zoomed)
          if (_currentScale <= 1.0 && !_isLoading && !_hasError)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: const Text(
                    'Pinch to zoom • Double tap to zoom • Tap to close',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Build the main image widget
  Widget _buildImage() {
    return Image.network(
      widget.imageUrl,
      fit: BoxFit.contain,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          // Image loaded successfully
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _isLoading = false;
                _hasError = false;
              });
            }
          });
          return child;
        }

        // Show loading progress
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && !_isLoading) {
            setState(() {
              _isLoading = true;
            });
          }
        });

        return const SizedBox.shrink(); // Hide while loading indicator shows
      },
      errorBuilder: (context, error, stackTrace) {
        // Handle error
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _isLoading = false;
              _hasError = true;
            });
          }
        });

        return const SizedBox.shrink(); // Hide while error message shows
      },
    );
  }
}
