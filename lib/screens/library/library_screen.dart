import 'package:flutter/material.dart';
import 'package:fyllens/core/theme/app_colors.dart';
import 'package:fyllens/core/theme/app_text_styles.dart';
import 'package:fyllens/core/constants/app_spacing.dart';
import 'package:fyllens/screens/shared/widgets/filter_chip_widget.dart';
import 'package:fyllens/screens/shared/widgets/plant_grid_card.dart';
import 'package:fyllens/screens/library/plant_detail_screen.dart';
import 'package:fyllens/core/theme/app_icons.dart';

/// Library page - Plant species database
///
/// Browse and search for plant care information, nutrient requirements,
/// and common deficiency symptoms.
class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Vegetables', 'Crops'];

  // Mock plant data
  final List<Map<String, String>> _plants = [
    {
      'name': 'Rice',
      'scientificName': 'Oryza sativa',
      'imageAssetPath': 'assets/images/rice.jpg',
      'category': 'Crops',
    },
    {
      'name': 'Corn',
      'scientificName': 'Zea mays',
      'imageAssetPath': 'assets/images/corn.jpg',
      'category': 'Crops',
    },
    {
      'name': 'Okra',
      'scientificName': 'Abelmoschus esculentus',
      'imageAssetPath': 'assets/images/okra.JPG',
      'category': 'Vegetables',
    },
    {
      'name': 'Cucumber',
      'scientificName': 'Cucumis sativus',
      'imageAssetPath': 'assets/images/cucumber.jpg',
      'category': 'Vegetables',
    },
  ];

  List<Map<String, String>> get _filteredPlants {
    if (_selectedFilter == 'All') {
      return _plants;
    }
    return _plants
        .where((plant) => plant['category'] == _selectedFilter)
        .toList();
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
            // Search and Filter Section
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
                      decoration: InputDecoration(
                        hintText: 'Search plants or deficiencies...',
                        hintStyle: AppTextStyles.inputHint,
                        prefixIcon: Icon(
                          AppIcons.search,
                          color: AppColors.textSecondary,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.md,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  // Filter chips
                  SizedBox(
                    height: 40,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _filters.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: AppSpacing.sm),
                      itemBuilder: (context, index) {
                        return FilterChipWidget(
                          label: _filters[index],
                          isSelected: _selectedFilter == _filters[index],
                          onTap: () {
                            setState(() {
                              _selectedFilter = _filters[index];
                            });
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            // Plant grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: AppSpacing.md,
                    mainAxisSpacing: AppSpacing.md,
                    childAspectRatio: 0.89, // 177px width / 198px height ≈ 0.89
                  ),
                  itemCount: _filteredPlants.length,
                  itemBuilder: (context, index) {
                    final plant = _filteredPlants[index];
                    return PlantGridCard(
                      plantName: plant['name']!,
                      scientificName: plant['scientificName']!,
                      imageAssetPath: plant['imageAssetPath'],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlantDetailScreen(
                              plantName: plant['name']!,
                              scientificName: plant['scientificName']!,
                              imageAssetPath: plant['imageAssetPath'],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
