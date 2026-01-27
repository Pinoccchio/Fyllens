import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fyllens/core/theme/app_colors.dart';
import 'package:fyllens/core/theme/app_text_styles.dart';
import 'package:fyllens/core/constants/app_spacing.dart';
import 'package:fyllens/screens/shared/widgets/filter_chip_widget.dart';
import 'package:fyllens/screens/shared/widgets/custom_card.dart';
import 'package:fyllens/screens/shared/widgets/leaf_loader.dart';
import 'package:fyllens/screens/history/history_result_screen.dart';
import 'package:fyllens/providers/history_provider.dart';
import 'package:fyllens/providers/auth_provider.dart';
import 'package:fyllens/providers/scan_provider.dart';
import 'package:fyllens/providers/tab_provider.dart';
import 'package:fyllens/models/scan_result.dart';
import 'package:fyllens/core/theme/app_icons.dart';
import 'package:fyllens/core/utils/health_status_helper.dart';
import 'package:fyllens/core/utils/timestamp_formatter.dart';
import 'package:fyllens/core/utils/timezone_helper.dart';

/// History screen - "Organic Luxury" Design
///
/// Premium scan history experience with:
/// - Warm cream background
/// - Gold accent filter pills
/// - Premium history cards with severity accents
/// - Swipe-to-delete with color-coded backgrounds
/// - Smooth animations throughout
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'This Week', 'This Month'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadHistory();
    });
  }

  Future<void> _loadHistory() async {
    final authProvider = context.read<AuthProvider>();
    final historyProvider = context.read<HistoryProvider>();

    final userId = authProvider.currentUser?.id;
    if (userId == null) {
      debugPrint('⚠️  [HISTORY] User not authenticated, cannot load history');
      return;
    }

    debugPrint('📚 [HISTORY] Loading scan history for user: $userId');
    await historyProvider.loadHistory(userId);
  }

  Future<void> _refreshHistory() async {
    final authProvider = context.read<AuthProvider>();
    final historyProvider = context.read<HistoryProvider>();

    final userId = authProvider.currentUser?.id;
    if (userId != null) {
      await historyProvider.refresh(userId);
    }
  }

  List<ScanResult> _getFilteredHistory(List<ScanResult> scans) {
    if (_selectedFilter == 'All') {
      return scans;
    }

    final now = TimezoneHelper.nowInManila();
    if (_selectedFilter == 'This Week') {
      return scans
          .where((scan) => now.difference(scan.createdAt).inDays <= 7)
          .toList();
    }

    if (_selectedFilter == 'This Month') {
      return scans
          .where((scan) => now.difference(scan.createdAt).inDays <= 30)
          .toList();
    }

    return scans;
  }

  Future<void> _deleteScan(ScanResult scan) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceWarm,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        ),
        title: Text(
          'Delete Scan',
          style: AppTextStyles.heading2.copyWith(
            color: AppColors.primaryForest,
          ),
        ),
        content: Text(
          'Are you sure you want to delete this scan for ${scan.plantName}?',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.statusCritical,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: CustomCard.standard(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const LeafLoader(size: 40),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Deleting scan...',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      final historyProvider = context.read<HistoryProvider>();
      final success = await historyProvider.deleteScan(scan.id);

      if (mounted) {
        Navigator.of(context).pop();
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  success ? AppIcons.checkCircle : AppIcons.error,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  success
                      ? 'Scan deleted successfully'
                      : 'Failed to delete scan',
                  style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
                ),
              ],
            ),
            backgroundColor:
                success ? AppColors.statusHealthy : AppColors.statusCritical,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            margin: const EdgeInsets.all(AppSpacing.md),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final historyProvider = context.watch<HistoryProvider>();
    final filteredHistory = _getFilteredHistory(historyProvider.scans);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        title: Text(
          'Scan History',
          style: AppTextStyles.heading1.copyWith(
            color: AppColors.primaryForest,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filter Section with gold accent pills
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding,
                vertical: AppSpacing.md,
              ),
              child: SizedBox(
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
            ),

            // History list with pull-to-refresh
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshHistory,
                color: AppColors.accentGold,
                backgroundColor: AppColors.surfaceWarm,
                child: _buildHistoryContent(historyProvider, filteredHistory),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryContent(
    HistoryProvider provider,
    List<ScanResult> filteredHistory,
  ) {
    // Loading state
    if (provider.isLoading && provider.scans.isEmpty) {
      return const Center(child: LeafLoader(size: 60));
    }

    // Error state
    if (provider.errorMessage != null) {
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
                    'Error loading history',
                    style: AppTextStyles.heading3.copyWith(
                      color: AppColors.primaryForest,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    provider.errorMessage!,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  ElevatedButton.icon(
                    onPressed: _loadHistory,
                    icon: Icon(AppIcons.refresh),
                    label: const Text('Retry'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentGold,
                      foregroundColor: AppColors.textOnGold,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusPill),
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

    // Empty state
    if (filteredHistory.isEmpty) {
      return ListView(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Center(
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
                        AppIcons.history,
                        size: 64,
                        color: AppColors.primarySage.withValues(alpha: 0.5),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      _selectedFilter == 'All'
                          ? 'No scan history yet'
                          : 'No scans in this period',
                      style: AppTextStyles.heading3.copyWith(
                        color: AppColors.primaryForest,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      _selectedFilter == 'All'
                          ? 'Start scanning plants to see history here'
                          : 'Try selecting a different time period',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }

    // History list with swipe-to-delete
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      itemCount: filteredHistory.length,
      itemBuilder: (context, index) {
        final scan = filteredHistory[index];
        return Dismissible(
          key: Key(scan.id),
          direction: DismissDirection.endToStart,
          background: Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.md),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.statusCritical.withValues(alpha: 0.8),
                  AppColors.statusCritical,
                ],
              ),
              borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
            ),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: AppSpacing.lg),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  AppIcons.delete,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Delete',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          confirmDismiss: (direction) async {
            await _deleteScan(scan);
            return false;
          },
          child: _buildHistoryItem(scan),
        );
      },
    );
  }

  Widget _buildHistoryItem(ScanResult scan) {
    final isHealthy = scan.isHealthy;
    final statusColor = HealthStatusHelper.getHealthColor(
      isHealthy: isHealthy,
      severity: scan.severity,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: CustomCard.standard(
        accentColor: statusColor,
        accentPosition: AccentPosition.left,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HistoryResultScreen(
                plantName: scan.plantName,
                imageAssetPath: scan.imageUrl,
                deficiencyName: scan.deficiencyDetected ?? 'Unknown Deficiency',
                severity: scan.severity ?? 'Unknown',
                symptoms: scan.symptoms ?? ['No symptoms recorded'],
                treatments: (scan.geminiTreatments ??
                        [
                          {
                            'icon': 'fertilizer',
                            'title': 'Balanced Fertilizer',
                            'description': 'Apply recommended NPK fertilizer',
                          }
                        ])
                    .map((t) => {
                          'icon': t['icon']?.toString() ?? 'fertilizer',
                          'title': t['title']?.toString() ?? 'Treatment',
                          'description': t['description']?.toString() ??
                              'Apply appropriate treatment',
                        })
                    .toList(),
                careTips: isHealthy ? scan.careTips : null,
                preventiveCare: isHealthy ? scan.preventiveCare : null,
                growthOptimization: isHealthy ? scan.growthOptimization : null,
                preventionTips: !isHealthy ? scan.preventionTips : null,
                onRescanPressed: () {
                  debugPrint('🔄 [RESCAN CALLBACK] Callback triggered');
                  context.read<ScanProvider>().preselectPlant(scan.plantName);
                  context.read<ScanProvider>().clearCurrentScan();
                  Navigator.pop(context);
                  context.read<TabProvider>().setTab(2);
                },
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Row(
            children: [
              // Plant image with status overlay
              Stack(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppColors.primarySage.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      child: Image.network(
                        scan.imageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.primarySage,
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) => Icon(
                          AppIcons.seedling,
                          color: AppColors.primarySage,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                  // Health status indicator
                  Positioned(
                    bottom: -2,
                    right: -2,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceWarm,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Icon(
                        HealthStatusHelper.getHealthIcon(
                          isHealthy: isHealthy,
                          severity: scan.severity,
                        ),
                        size: 12,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: AppSpacing.sm),
              // Scan info - use Expanded to prevent overflow
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Plant name and status badge row
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            scan.plantName,
                            style: AppTextStyles.bodySmall.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryForest,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        // Status badge - fixed size
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.12),
                            borderRadius:
                                BorderRadius.circular(AppSpacing.radiusPill),
                          ),
                          child: Text(
                            isHealthy
                                ? 'Healthy'
                                : scan.severity ?? 'Issue',
                            style: AppTextStyles.caption.copyWith(
                              color: statusColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    // Deficiency name
                    Text(
                      isHealthy
                          ? 'Healthy'
                          : scan.deficiencyDetected ?? 'Unknown',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Timestamp and confidence row
                    Row(
                      children: [
                        Icon(
                          AppIcons.clock,
                          size: 10,
                          color: AppColors.textTertiary,
                        ),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            TimestampFormatter.formatAgo(scan.createdAt),
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textTertiary,
                              fontSize: 10,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (scan.confidence != null) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 1,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.accentGold.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${(scan.confidence! * 100).toStringAsFixed(0)}%',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.accentGold,
                                fontWeight: FontWeight.w600,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              // Chevron
              Icon(
                AppIcons.chevronRight,
                color: AppColors.textTertiary,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
