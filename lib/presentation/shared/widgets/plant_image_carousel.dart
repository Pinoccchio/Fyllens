import 'package:flutter/material.dart';
import 'package:fyllens/core/theme/app_colors.dart';
import 'package:fyllens/core/constants/app_spacing.dart';
import 'package:fyllens/core/theme/app_icons.dart';
import 'package:fyllens/services/image_download_service.dart';

/// Plant image carousel widget with swipeable gallery and page indicator
class PlantImageCarousel extends StatefulWidget {
  final List<String> imagePaths;
  final double height;
  final String? plantName;

  const PlantImageCarousel({
    super.key,
    required this.imagePaths,
    this.height = 250,
    this.plantName,
  });

  @override
  State<PlantImageCarousel> createState() => _PlantImageCarouselState();
}

class _PlantImageCarouselState extends State<PlantImageCarousel> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Handle empty images
    if (widget.imagePaths.isEmpty) {
      return _buildPlaceholder();
    }

    return Column(
      children: [
        // Image carousel
        SizedBox(
          height: widget.height,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: widget.imagePaths.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  // Optional: Show fullscreen image
                  _showFullscreenImage(context, index);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  child: Image.asset(
                    widget.imagePaths[index],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        _buildPlaceholder(),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.sm),

        // Page indicator dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.imagePaths.length,
            (index) => _buildDotIndicator(index == _currentPage),
          ),
        ),
      ],
    );
  }

  Widget _buildDotIndicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.primaryGreenModern
            : AppColors.textSecondary.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: AppColors.primaryGreenModern.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Center(
        child: Icon(
          AppIcons.flower,
          size: 64,
          color: AppColors.primaryGreenModern,
        ),
      ),
    );
  }

  void _showFullscreenImage(BuildContext context, int initialIndex) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _FullscreenImageGallery(
          imagePaths: widget.imagePaths,
          initialIndex: initialIndex,
          plantName: widget.plantName,
        ),
      ),
    );
  }
}

/// Fullscreen image gallery viewer with download functionality
class _FullscreenImageGallery extends StatefulWidget {
  final List<String> imagePaths;
  final int initialIndex;
  final String? plantName;

  const _FullscreenImageGallery({
    required this.imagePaths,
    required this.initialIndex,
    this.plantName,
  });

  @override
  State<_FullscreenImageGallery> createState() =>
      _FullscreenImageGalleryState();
}

class _FullscreenImageGalleryState extends State<_FullscreenImageGallery> {
  late PageController _pageController;
  late int _currentPage;
  bool _isDownloading = false;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _downloadCurrentImage() async {
    if (_isDownloading) return;

    setState(() {
      _isDownloading = true;
    });

    final service = ImageDownloadService.instance;
    final assetPath = widget.imagePaths[_currentPage];
    final plantName = widget.plantName ?? 'plant';
    final fileName = service.generateFileName(plantName, _currentPage);

    final result = await service.saveAssetImage(assetPath, fileName);

    if (!mounted) return;

    setState(() {
      _isDownloading = false;
    });

    // Show result snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              result.success ? Icons.check_circle : Icons.error,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(result.message)),
          ],
        ),
        backgroundColor: result.success
            ? AppColors.primaryGreenModern
            : AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text('${_currentPage + 1} / ${widget.imagePaths.length}'),
        centerTitle: true,
        actions: [
          // Download button
          _isDownloading
              ? const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                )
              : IconButton(
                  icon: const Icon(Icons.download),
                  onPressed: _downloadCurrentImage,
                  tooltip: 'Save to Gallery',
                ),
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        itemCount: widget.imagePaths.length,
        itemBuilder: (context, index) {
          return InteractiveViewer(
            child: Center(
              child: Image.asset(
                widget.imagePaths[index],
                fit: BoxFit.contain,
              ),
            ),
          );
        },
      ),
    );
  }
}
