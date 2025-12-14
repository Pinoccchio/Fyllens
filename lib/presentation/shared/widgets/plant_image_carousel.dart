import 'package:flutter/material.dart';
import 'package:fyllens/core/theme/app_colors.dart';
import 'package:fyllens/core/constants/app_spacing.dart';
import 'package:fyllens/core/theme/app_icons.dart';

/// Plant image carousel widget with swipeable gallery and page indicator
class PlantImageCarousel extends StatefulWidget {
  final List<String> imagePaths;
  final double height;

  const PlantImageCarousel({
    super.key,
    required this.imagePaths,
    this.height = 250,
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
        ),
      ),
    );
  }
}

/// Fullscreen image gallery viewer
class _FullscreenImageGallery extends StatefulWidget {
  final List<String> imagePaths;
  final int initialIndex;

  const _FullscreenImageGallery({
    required this.imagePaths,
    required this.initialIndex,
  });

  @override
  State<_FullscreenImageGallery> createState() =>
      _FullscreenImageGalleryState();
}

class _FullscreenImageGalleryState extends State<_FullscreenImageGallery> {
  late PageController _pageController;
  late int _currentPage;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text('${_currentPage + 1} / ${widget.imagePaths.length}'),
        centerTitle: true,
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
