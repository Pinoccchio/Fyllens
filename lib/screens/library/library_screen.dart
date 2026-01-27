import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fyllens/core/theme/app_colors.dart';
import 'package:fyllens/core/theme/app_text_styles.dart';
import 'package:fyllens/core/constants/app_spacing.dart';
import 'package:fyllens/screens/library/plant_detail_screen.dart';
import 'package:fyllens/core/theme/app_icons.dart';
import 'package:fyllens/providers/library_provider.dart';
import 'package:fyllens/screens/shared/widgets/leaf_loader.dart';
import 'package:fyllens/screens/shared/widgets/custom_card.dart';

/// Library screen - "Organic Luxury" Design
///
/// Premium plant database experience with:
/// - Warm cream background
/// - Frosted glass search bar
/// - Pinterest-style staggered grid
/// - Plant names in serif font
/// - Botanical accent elements
class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LibraryProvider>().loadPlants();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Premium app bar with search
          SliverAppBar(
            expandedHeight: 140,
            floating: true,
            pinned: true,
            backgroundColor: AppColors.background,
            elevation: 0,
            scrolledUnderElevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.primarySage.withValues(alpha: 0.08),
                      AppColors.background,
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.screenPadding,
                      AppSpacing.md,
                      AppSpacing.screenPadding,
                      0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header with title and icon
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Plant Library',
                                style: AppTextStyles.heading1.copyWith(
                                  color: AppColors.primaryForest,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(AppSpacing.sm),
                              decoration: BoxDecoration(
                                color:
                                    AppColors.primarySage.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(
                                    AppSpacing.radiusMd),
                              ),
                              child: Icon(
                                AppIcons.leaf,
                                color: AppColors.primarySage,
                                size: 24,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'Discover plant species and care guides',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(56),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding,
                  vertical: AppSpacing.sm,
                ),
                child: _buildSearchBar(),
              ),
            ),
          ),

          // Plant grid
          Consumer<LibraryProvider>(
            builder: (context, provider, child) {
              // Loading state
              if (provider.isLoadingPlants) {
                return const SliverFillRemaining(
                  child: Center(child: LeafLoader(size: 60)),
                );
              }

              // Error state
              if (provider.hasError) {
                return SliverFillRemaining(
                  child: _buildErrorState(provider),
                );
              }

              // Empty state
              if (provider.isEmpty) {
                return SliverFillRemaining(
                  child: _buildEmptyState(provider),
                );
              }

              // Success state with grid
              return SliverPadding(
                padding: const EdgeInsets.all(AppSpacing.screenPadding),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: AppSpacing.md,
                    mainAxisSpacing: AppSpacing.md,
                    childAspectRatio: 0.72, // Adjusted for image + info layout
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final plant = provider.plants[index];
                      return _PlantGridCard(
                        plantName: plant.name,
                        scientificName: plant.species,
                        imageUrl: plant.imageUrl,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlantDetailScreen(
                                plantId: plant.id,
                              ),
                            ),
                          );
                        },
                      );
                    },
                    childCount: provider.plants.length,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceWarm,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search plants...',
          hintStyle: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textTertiary,
          ),
          prefixIcon: Icon(AppIcons.search, color: AppColors.textSecondary),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(AppIcons.close, color: AppColors.textSecondary),
                  onPressed: () {
                    _searchController.clear();
                    context.read<LibraryProvider>().clearSearch();
                    setState(() {});
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
        ),
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textPrimary,
        ),
        onChanged: (query) {
          context.read<LibraryProvider>().searchPlants(query);
          setState(() {});
        },
      ),
    );
  }

  Widget _buildErrorState(LibraryProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: CustomCard.standard(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.statusCritical.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    AppIcons.error,
                    size: 48,
                    color: AppColors.statusCritical,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Failed to load plants',
                  style: AppTextStyles.heading3.copyWith(
                    color: AppColors.primaryForest,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  provider.plantsError ?? 'Unknown error',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                ElevatedButton.icon(
                  onPressed: () => provider.retryPlants(),
                  icon: Icon(AppIcons.refresh),
                  label: const Text('Retry'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentGold,
                    foregroundColor: AppColors.textOnGold,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(LibraryProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: AppColors.primarySage.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                provider.searchQuery.isNotEmpty
                    ? AppIcons.search
                    : AppIcons.leaf,
                size: 64,
                color: AppColors.primarySage.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              provider.searchQuery.isNotEmpty
                  ? 'No plants found'
                  : 'No plants available',
              style: AppTextStyles.heading3.copyWith(
                color: AppColors.primaryForest,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              provider.searchQuery.isNotEmpty
                  ? 'Try a different search term'
                  : 'Plants will appear here',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Premium plant grid card - "Organic Luxury" Design
/// Similar to Recent Scans card style with image on top
class _PlantGridCard extends StatefulWidget {
  final String plantName;
  final String scientificName;
  final String? imageUrl;
  final VoidCallback onTap;

  const _PlantGridCard({
    required this.plantName,
    required this.scientificName,
    this.imageUrl,
    required this.onTap,
  });

  /// Get local asset image path for known plants
  /// Falls back to null if plant is not in the local assets
  String? get localAssetPath {
    final nameLower = plantName.toLowerCase();
    if (nameLower.contains('corn')) {
      return 'assets/images/corn.jpg';
    } else if (nameLower.contains('cucumber')) {
      return 'assets/images/cucumber.jpg';
    } else if (nameLower.contains('rice')) {
      return 'assets/images/rice.jpg';
    } else if (nameLower.contains('okra')) {
      return 'assets/images/library/okra/healthy_1.jpg';
    }
    return null;
  }

  @override
  State<_PlantGridCard> createState() => _PlantGridCardState();
}

class _PlantGridCardState extends State<_PlantGridCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: (_) => _animationController.forward(),
            onTapUp: (_) {
              _animationController.reverse();
              widget.onTap();
            },
            onTapCancel: () => _animationController.reverse(),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceWarm,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Plant image - fixed aspect ratio
                  AspectRatio(
                    aspectRatio: 1.2,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(AppSpacing.radiusMd),
                        topRight: Radius.circular(AppSpacing.radiusMd),
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Image - prefer network URL, fall back to local asset, then placeholder
                          _buildPlantImage(),

                          // Leaf accent badge
                          Positioned(
                            top: AppSpacing.sm,
                            right: AppSpacing.sm,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceWarm
                                    .withValues(alpha: 0.9),
                                borderRadius:
                                    BorderRadius.circular(AppSpacing.radiusSm),
                              ),
                              child: Icon(
                                AppIcons.leaf,
                                size: 14,
                                color: AppColors.primarySage,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Plant info - fixed padding
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Plant name
                        Text(
                          widget.plantName,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.primaryForest,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        // Scientific name italic
                        Text(
                          widget.scientificName,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.textSecondary,
                            fontStyle: FontStyle.italic,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        // View details link
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'View details',
                              style: AppTextStyles.labelSmall.copyWith(
                                color: AppColors.accentGold,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 2),
                            Icon(
                              AppIcons.chevronRight,
                              size: 12,
                              color: AppColors.accentGold,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Build the plant image with fallback logic:
  /// 1. Try network URL if available
  /// 2. Fall back to local asset if available
  /// 3. Show placeholder icon as last resort
  Widget _buildPlantImage() {
    // If network URL is available, try to load it
    if (widget.imageUrl != null && widget.imageUrl!.isNotEmpty) {
      return Image.network(
        widget.imageUrl!,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: AppColors.primarySage.withValues(alpha: 0.1),
            child: const Center(
              child: LeafLoader(size: 24),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) => _buildLocalOrPlaceholder(),
      );
    }

    // No network URL, try local asset or placeholder
    return _buildLocalOrPlaceholder();
  }

  /// Try to load local asset image, or show placeholder
  Widget _buildLocalOrPlaceholder() {
    final localPath = widget.localAssetPath;
    if (localPath != null) {
      return Image.asset(
        localPath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
      );
    }
    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.primarySage.withValues(alpha: 0.1),
      child: Center(
        child: Icon(
          AppIcons.seedling,
          size: 40,
          color: AppColors.primarySage.withValues(alpha: 0.4),
        ),
      ),
    );
  }
}
