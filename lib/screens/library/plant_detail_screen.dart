import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fyllens/core/theme/app_colors.dart';
import 'package:fyllens/core/theme/app_text_styles.dart';
import 'package:fyllens/core/constants/app_spacing.dart';
import 'package:fyllens/core/theme/app_icons.dart';
import 'package:fyllens/providers/library_provider.dart';
import 'package:fyllens/providers/scan_provider.dart';
import 'package:fyllens/providers/tab_provider.dart';
import 'package:fyllens/presentation/shared/widgets/plant_image_carousel.dart';
import 'package:fyllens/services/image_download_service.dart';

/// Plant detail page showing comprehensive plant information from Supabase
class PlantDetailScreen extends StatefulWidget {
  final String plantId;

  const PlantDetailScreen({
    super.key,
    required this.plantId,
  });

  @override
  State<PlantDetailScreen> createState() => _PlantDetailScreenState();
}

class _PlantDetailScreenState extends State<PlantDetailScreen> {
  bool _isDownloadingAll = false;
  int _downloadProgress = 0;
  int _downloadTotal = 0;

  @override
  void initState() {
    super.initState();
    // Load plant data when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LibraryProvider>().loadPlantDetail(widget.plantId);
    });
  }

  @override
  void dispose() {
    // Clear plant detail when leaving screen
    context.read<LibraryProvider>().clearPlantDetail();
    super.dispose();
  }

  Future<void> _downloadAllImages(List<String> imagePaths, String plantName) async {
    if (_isDownloadingAll || imagePaths.isEmpty) return;

    setState(() {
      _isDownloadingAll = true;
      _downloadProgress = 0;
      _downloadTotal = imagePaths.length;
    });

    final service = ImageDownloadService.instance;
    final results = await service.saveMultipleAssetImages(
      imagePaths,
      plantName,
      onProgress: (current, total) {
        if (mounted) {
          setState(() {
            _downloadProgress = current;
            _downloadTotal = total;
          });
        }
      },
    );

    if (!mounted) return;

    setState(() {
      _isDownloadingAll = false;
    });

    // Count successes and failures
    final successCount = results.where((r) => r.success).length;
    final failCount = results.length - successCount;

    String message;
    bool isSuccess;

    if (failCount == 0) {
      message = '$successCount image${successCount > 1 ? 's' : ''} saved to gallery';
      isSuccess = true;
    } else if (successCount == 0) {
      message = 'Failed to save images. Check storage permissions.';
      isSuccess = false;
    } else {
      message = '$successCount saved, $failCount failed';
      isSuccess = true;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isSuccess ? Icons.check_circle : Icons.error,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: isSuccess
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
      backgroundColor: AppColors.backgroundSoft,
      body: Consumer<LibraryProvider>(
        builder: (context, provider, child) {
          // Loading state
          if (provider.isLoadingDetail) {
            return _buildLoadingState();
          }

          // Error state
          if (provider.hasDetailError) {
            return _buildErrorState(provider.detailError!);
          }

          // No data state
          if (!provider.hasPlantData) {
            return _buildNoDataState();
          }

          final plant = provider.currentPlant!;
          final deficiencies = provider.currentDeficiencies;

          return SafeArea(
            child: Column(
              children: [
                // Header with back button and plant name
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(AppIcons.arrowBack),
                        onPressed: () => Navigator.pop(context),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              plant.name,
                              style: AppTextStyles.heading2,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              plant.scientificName ?? plant.species,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                                fontStyle: FontStyle.italic,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            if (plant.family != null) ...[
                              const SizedBox(height: 2),
                              Text(
                                plant.family!,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: 11,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: 40), // Balance for back button
                    ],
                  ),
                ),

                // Scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Plant image carousel
                        if (plant.images != null && plant.images!.isNotEmpty)
                          PlantImageCarousel(
                            imagePaths: plant.images!,
                            height: 250,
                            plantName: plant.name,
                          )
                        else if (plant.imageUrl != null)
                          _buildSingleImage(plant.imageUrl!)
                        else
                          _buildPlaceholder(),

                        // Save for Offline button (only show if there are images)
                        if ((plant.images != null && plant.images!.isNotEmpty) ||
                            plant.imageUrl != null) ...[
                          const SizedBox(height: AppSpacing.md),
                          _buildDownloadAllButton(
                            plant.images ?? [plant.imageUrl!],
                            plant.name,
                          ),
                        ],

                        const SizedBox(height: AppSpacing.lg),

                        // Overview section
                        _buildCard(
                          title: 'Overview',
                          content: plant.description,
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Common Deficiencies section
                        if (deficiencies.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                AppSpacing.radiusMd,
                              ),
                              border: Border.all(
                                color: AppColors.textSecondary
                                    .withValues(alpha: 0.2),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Common Deficiencies & Diseases',
                                  style: AppTextStyles.heading3,
                                ),
                                const SizedBox(height: AppSpacing.md),
                                ...deficiencies.asMap().entries.map((entry) {
                                  final index = entry.key;
                                  final deficiency = entry.value;
                                  final isLast = index == deficiencies.length - 1;

                                  return Column(
                                    children: [
                                      _buildDeficiencyItem(
                                        deficiency.name,
                                        deficiency.pathogenType ?? 'Unknown',
                                      ),
                                      if (!isLast)
                                        const Divider(height: AppSpacing.md),
                                    ],
                                  );
                                }),
                              ],
                            ),
                          ),
                        const SizedBox(height: AppSpacing.md),

                        // Ideal Growing Conditions section
                        if (plant.optimalConditions != null)
                          Container(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F5E9),
                              borderRadius: BorderRadius.circular(
                                AppSpacing.radiusMd,
                              ),
                              border: Border.all(
                                color: AppColors.primaryGreenModern.withValues(
                                  alpha: 0.3,
                                ),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Ideal Growing Conditions',
                                  style: AppTextStyles.heading3,
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                Text(
                                  plant.optimalConditions!,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.textPrimary,
                                    height: 1.6,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: AppSpacing.md),

                        // Growth Stages Timeline section
                        if (plant.growthStages != null &&
                            plant.growthStages!.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F0FF),
                              borderRadius: BorderRadius.circular(
                                AppSpacing.radiusMd,
                              ),
                              border: Border.all(
                                color: const Color(0xFF9C27B0).withValues(
                                  alpha: 0.3,
                                ),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.timeline,
                                      color: const Color(0xFF9C27B0),
                                      size: 24,
                                    ),
                                    const SizedBox(width: AppSpacing.sm),
                                    Text(
                                      'Growth Stages Timeline',
                                      style: AppTextStyles.heading3,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: AppSpacing.md),
                                ...plant.growthStages!.asMap().entries.map(
                                  (entry) {
                                    final index = entry.key;
                                    final stage = entry.value;
                                    return _buildTimelineItem(
                                      index + 1,
                                      stage,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        if (plant.growthStages != null &&
                            plant.growthStages!.isNotEmpty)
                          const SizedBox(height: AppSpacing.md),

                        // Healthy Description section
                        if (plant.healthyDescription != null)
                          _buildCard(
                            title: 'Healthy Plant Care',
                            content: plant.healthyDescription!,
                            backgroundColor: const Color(0xFFF1F8F4),
                          ),

                        const SizedBox(height: AppSpacing.lg),

                        // Scan This Plant button
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              // Pre-select this plant in scan screen
                              context.read<ScanProvider>().preselectPlant(plant.name);

                              // Navigate back to home and switch to Scan tab
                              Navigator.pop(context);
                              context.read<TabProvider>().setTab(2); // Scan tab
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryGreenModern,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppSpacing.radiusMd,
                                ),
                              ),
                              elevation: 0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(AppIcons.camera, size: 20),
                                const SizedBox(width: AppSpacing.sm),
                                Text(
                                  'Scan This Plant',
                                  style: AppTextStyles.buttonMedium,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required String content,
    Color backgroundColor = Colors.white,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(
          color: AppColors.textSecondary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.heading3),
          const SizedBox(height: AppSpacing.sm),
          Text(
            content,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeficiencyItem(String name, String type) {
    // Determine color based on type
    Color badgeColor;
    Color textColor;

    switch (type.toLowerCase()) {
      case 'fungal':
        badgeColor = const Color(0xFFFFB84D);
        textColor = const Color(0xFFE65100);
        break;
      case 'bacterial':
        badgeColor = const Color(0xFFFF8A80);
        textColor = const Color(0xFFD32F2F);
        break;
      case 'viral':
        badgeColor = const Color(0xFFB39DDB);
        textColor = const Color(0xFF5E35B1);
        break;
      case 'nutrient':
        badgeColor = const Color(0xFFFFEB99);
        textColor = Colors.black87;
        break;
      default:
        badgeColor = const Color(0xFFB3D9FF);
        textColor = const Color(0xFF1976D2);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            name,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: badgeColor,
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
          child: Text(
            type,
            style: AppTextStyles.bodySmall.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSingleImage(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: SizedBox(
        width: double.infinity,
        height: 250,
        child: Image.asset(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: double.infinity,
      height: 250,
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

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppColors.primaryGreenModern,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Loading plant details...',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.error,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Error Loading Plant',
              style: AppTextStyles.heading3,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              error,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            ElevatedButton(
              onPressed: () {
                context.read<LibraryProvider>().retryDetail(widget.plantId);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreenModern,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoDataState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 64,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'No plant data found',
            style: AppTextStyles.heading3,
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(int number, String stage) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: Color(0xFF9C27B0),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$number',
                style: AppTextStyles.bodySmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              stage,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDownloadAllButton(List<String> imagePaths, String plantName) {
    final imageCount = imagePaths.length;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.primaryGreenModern.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(
          color: AppColors.primaryGreenModern.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.download_for_offline_outlined,
            color: AppColors.primaryGreenModern,
            size: 24,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Save for Offline Scanning',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '$imageCount image${imageCount > 1 ? 's' : ''} available',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          _isDownloadingAll
              ? SizedBox(
                  width: 80,
                  child: Column(
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: AppColors.primaryGreenModern,
                          strokeWidth: 2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$_downloadProgress/$_downloadTotal',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.primaryGreenModern,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                )
              : TextButton(
                  onPressed: () => _downloadAllImages(imagePaths, plantName),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primaryGreenModern,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                  ),
                  child: Text(
                    'Save All',
                    style: AppTextStyles.buttonSmall.copyWith(
                      color: AppColors.primaryGreenModern,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
