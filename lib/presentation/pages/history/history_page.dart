import 'package:flutter/material.dart';
import 'package:fyllens/core/theme/app_colors.dart';
import 'package:fyllens/core/theme/app_text_styles.dart';
import 'package:fyllens/core/constants/app_spacing.dart';
import 'package:fyllens/presentation/shared/widgets/filter_chip_widget.dart';
import 'package:fyllens/presentation/shared/widgets/severity_badge.dart';
import 'package:fyllens/presentation/pages/scan/scan_results_page.dart';
import 'package:intl/intl.dart';

/// History page - Past scan results
///
/// View all previous plant scans with their analysis results,
/// timestamps, and recommendations.
class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'This Week', 'This Month'];

  // Mock scan history data
  final List<Map<String, dynamic>> _scanHistory = [
    {
      'id': '1',
      'plantName': 'Rice',
      'deficiency': 'Nitrogen Deficiency',
      'severity': 'Mild',
      'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
    },
    {
      'id': '2',
      'plantName': 'Rice',
      'deficiency': 'Nitrogen Deficiency',
      'severity': 'Moderate',
      'timestamp': DateTime.now().subtract(const Duration(days: 1)),
    },
    {
      'id': '3',
      'plantName': 'Corn',
      'deficiency': 'Phosphorus Deficiency',
      'severity': 'Severe',
      'timestamp': DateTime.now().subtract(const Duration(days: 3)),
    },
  ];

  List<Map<String, dynamic>> get _filteredHistory {
    if (_selectedFilter == 'All') {
      return _scanHistory;
    }
    final now = DateTime.now();
    if (_selectedFilter == 'This Week') {
      return _scanHistory
          .where((scan) =>
              now.difference(scan['timestamp'] as DateTime).inDays <= 7)
          .toList();
    }
    if (_selectedFilter == 'This Month') {
      return _scanHistory
          .where((scan) =>
              now.difference(scan['timestamp'] as DateTime).inDays <= 30)
          .toList();
    }
    return _scanHistory;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSoft,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Scan History',
                    style: AppTextStyles.heading1,
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
            // History list
            Expanded(
              child: _filteredHistory.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.history,
                            size: 80,
                            color: AppColors.textSecondary.withValues(alpha: 0.3),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            'No scan history',
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                      itemCount: _filteredHistory.length,
                      itemBuilder: (context, index) {
                        final scan = _filteredHistory[index];
                        return _buildHistoryItem(scan);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem(Map<String, dynamic> scan) {
    final timestamp = scan['timestamp'] as DateTime;
    final dateFormat = DateFormat('MMM dd, yyyy | h:mm a');

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ScanResultsPage(
                  plantName: (scan['plantName'] as String).toLowerCase(),
                  imageAssetPath: 'assets/images/${(scan['plantName'] as String).toLowerCase()}.jpg',
                  deficiencyName: scan['deficiency'] as String,
                  severity: scan['severity'] as String,
                  symptoms: _getSymptomsForDeficiency(scan['deficiency'] as String),
                  treatments: _getTreatmentsForDeficiency(scan['deficiency'] as String),
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                // Plant icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreenModern.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.grass,
                    color: AppColors.primaryGreenModern,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                // Scan info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            scan['plantName'] as String,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          SeverityBadge(severity: scan['severity'] as String),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        scan['deficiency'] as String,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 12,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            dateFormat.format(timestamp),
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Chevron
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<String> _getSymptomsForDeficiency(String deficiency) {
    switch (deficiency) {
      case 'Nitrogen Deficiency':
        return [
          'Yellow of older leaves starting from the tip',
          'Stunted growth and reduced plant vigor',
          'Pale green color of entire plant',
        ];
      case 'Phosphorus Deficiency':
        return [
          'Dark green or purplish leaves',
          'Delayed maturity and flowering',
          'Stunted root development',
        ];
      case 'Potassium Deficiency':
        return [
          'Yellowing and browning of leaf margins',
          'Weak stalks prone to lodging',
          'Poor kernel or fruit development',
        ];
      default:
        return [
          'Visible symptoms on leaves',
          'Reduced plant growth',
          'Lower crop yield',
        ];
    }
  }

  List<Map<String, String>> _getTreatmentsForDeficiency(String deficiency) {
    switch (deficiency) {
      case 'Nitrogen Deficiency':
        return [
          {
            'icon': 'fertilizer',
            'title': 'Fertilizer Application',
            'description': 'Apply urea at 40-60 kg per hectare',
          },
          {
            'icon': 'organic',
            'title': 'Organic Amendment',
            'description': 'Add compost or green manure',
          },
        ];
      case 'Phosphorus Deficiency':
        return [
          {
            'icon': 'fertilizer',
            'title': 'Phosphate Fertilizer',
            'description': 'Apply superphosphate or DAP',
          },
          {
            'icon': 'organic',
            'title': 'Bone Meal Application',
            'description': 'Add bone meal as organic source',
          },
        ];
      case 'Potassium Deficiency':
        return [
          {
            'icon': 'fertilizer',
            'title': 'Potassium Fertilizer',
            'description': 'Apply potassium chloride or sulfate',
          },
          {
            'icon': 'organic',
            'title': 'Wood Ash Application',
            'description': 'Apply wood ash as organic potassium source',
          },
        ];
      default:
        return [
          {
            'icon': 'fertilizer',
            'title': 'Balanced Fertilizer',
            'description': 'Apply recommended NPK fertilizer',
          },
        ];
    }
  }
}
