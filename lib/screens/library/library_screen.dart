import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fyllens/core/theme/app_colors.dart';
import 'package:fyllens/core/theme/app_text_styles.dart';
import 'package:fyllens/core/constants/app_spacing.dart';
import 'package:fyllens/screens/shared/widgets/plant_grid_card.dart';
import 'package:fyllens/screens/library/plant_detail_screen.dart';
import 'package:fyllens/core/theme/app_icons.dart';
import 'package:fyllens/providers/library_provider.dart';

/// Library page - Plant species database
///
/// Browse and search for plant care information, nutrient requirements,
/// and common deficiency symptoms. Now dynamically loads data from Supabase.
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
    // Load plants when screen initializes
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
      backgroundColor: AppColors.backgroundSoft,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundSoft,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        title: Text('Plant Library', style: AppTextStyles.heading1),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Section
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search bar
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (query) {
                        // Search as user types
                        context.read<LibraryProvider>().searchPlants(query);
                      },
                      decoration: InputDecoration(
                        hintText: 'Search plants...',
                        hintStyle: AppTextStyles.inputHint,
                        prefixIcon: Icon(
                          AppIcons.search,
                          color: AppColors.textSecondary,
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: Icon(
                                  AppIcons.close,
                                  color: AppColors.textSecondary,
                                ),
                                onPressed: () {
                                  _searchController.clear();
                                  context.read<LibraryProvider>().clearSearch();
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.md,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Plant grid with loading/error/empty states
            Expanded(
              child: Consumer<LibraryProvider>(
                builder: (context, provider, child) {
                  // Loading state
                  if (provider.isLoadingPlants) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  // Error state - with pull-to-refresh
                  if (provider.hasError) {
                    return RefreshIndicator(
                      onRefresh: () => provider.retryPlants(),
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(AppSpacing.lg),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    AppIcons.info,
                                    size: 64,
                                    color: AppColors.textSecondary,
                                  ),
                                  const SizedBox(height: AppSpacing.md),
                                  Text(
                                    'Failed to load plants',
                                    style: AppTextStyles.heading3,
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: AppSpacing.sm),
                                  Text(
                                    provider.plantsError ?? 'Unknown error',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: AppSpacing.lg),
                                  ElevatedButton(
                                    onPressed: () => provider.retryPlants(),
                                    child: const Text('Retry'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  // Empty state
                  if (provider.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              AppIcons.search,
                              size: 64,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              provider.searchQuery.isNotEmpty
                                  ? 'No plants found'
                                  : 'No plants available',
                              style: AppTextStyles.heading3,
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

                  // Success state with data
                  return RefreshIndicator(
                    onRefresh: () => provider.refresh(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: AppSpacing.md,
                          mainAxisSpacing: AppSpacing.md,
                          childAspectRatio: 0.89,
                        ),
                        itemCount: provider.plants.length,
                        itemBuilder: (context, index) {
                          final plant = provider.plants[index];
                          return PlantGridCard(
                            plantName: plant.name,
                            scientificName: plant.species,
                            imageAssetPath: plant.imageUrl,
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
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
