import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fyllens/core/theme/app_colors.dart';
import 'package:fyllens/core/theme/app_text_styles.dart';
import 'package:fyllens/core/constants/app_spacing.dart';
import 'package:fyllens/screens/shared/widgets/filter_chip_widget.dart';
import 'package:fyllens/screens/shared/widgets/severity_badge.dart';
import 'package:fyllens/screens/history/history_result_screen.dart';
import 'package:fyllens/providers/history_provider.dart';
import 'package:fyllens/providers/auth_provider.dart';
import 'package:fyllens/providers/scan_provider.dart';
import 'package:fyllens/providers/tab_provider.dart';
import 'package:fyllens/models/scan_result.dart';
import 'package:intl/intl.dart';
import 'package:fyllens/core/theme/app_icons.dart';
import 'package:fyllens/core/utils/health_status_helper.dart';

/// History page - Past scan results
///
/// View all previous plant scans with their analysis results,
/// timestamps, and recommendations. Fetches real data from Supabase.
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
    // Load history from database on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadHistory();
    });
  }

  /// Load scan history from database
  Future<void> _loadHistory() async {
    final authProvider = context.read<AuthProvider>();
    final historyProvider = context.read<HistoryProvider>();

    final userId = authProvider.currentUser?.id;
    if (userId == null) {
      print('⚠️  [HISTORY] User not authenticated, cannot load history');
      return;
    }

    print('📚 [HISTORY] Loading scan history for user: $userId');
    await historyProvider.loadHistory(userId);
  }

  /// Refresh history (pull-to-refresh)
  Future<void> _refreshHistory() async {
    final authProvider = context.read<AuthProvider>();
    final historyProvider = context.read<HistoryProvider>();

    final userId = authProvider.currentUser?.id;
    if (userId != null) {
      await historyProvider.refresh(userId);
    }
  }

  /// Get filtered history based on selected filter
  List<ScanResult> _getFilteredHistory(List<ScanResult> scans) {
    if (_selectedFilter == 'All') {
      return scans;
    }

    final now = DateTime.now();
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

  /// Delete scan with confirmation
  Future<void> _deleteScan(ScanResult scan) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).dialogBackgroundColor,
        title: const Text('Delete Scan'),
        content: Text(
          'Are you sure you want to delete this scan for ${scan.plantName}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Deleting scan...'),
                ],
              ),
            ),
          ),
        ),
      );

      final historyProvider = context.read<HistoryProvider>();
      final success = await historyProvider.deleteScan(scan.id);

      // Close loading dialog
      if (mounted) {
        Navigator.of(context).pop();
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success
                  ? 'Scan deleted successfully'
                  : 'Failed to delete scan',
            ),
            backgroundColor: success ? Colors.green : Colors.red,
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
      backgroundColor: AppColors.backgroundSoft,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundSoft,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        title: Text('Scan History', style: AppTextStyles.heading1),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filter Section
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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

            // History list with pull-to-refresh
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshHistory,
                color: AppColors.primaryGreenModern,
                child: _buildHistoryContent(historyProvider, filteredHistory),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build history content based on loading state
  Widget _buildHistoryContent(
    HistoryProvider provider,
    List<ScanResult> filteredHistory,
  ) {
    // Loading state
    if (provider.isLoading && provider.scans.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.primaryGreenModern,
        ),
      );
    }

    // Error state
    if (provider.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Error loading history',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Text(
                provider.errorMessage!,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            ElevatedButton.icon(
              onPressed: _loadHistory,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreenModern,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    // Empty state
    if (filteredHistory.isEmpty) {
      return ListView(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    AppIcons.history,
                    size: 80,
                    color: AppColors.textSecondary.withValues(alpha: 0.3),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    _selectedFilter == 'All'
                        ? 'No scan history yet'
                        : 'No scans in this period',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    _selectedFilter == 'All'
                        ? 'Start scanning plants to see history here'
                        : 'Try selecting a different time period',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    // History list with swipe-to-delete
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      itemCount: filteredHistory.length,
      itemBuilder: (context, index) {
        final scan = filteredHistory[index];
        return Dismissible(
          key: Key(scan.id),
          direction: DismissDirection.endToStart,
          background: Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: AppSpacing.lg),
            child: const Icon(
              Icons.delete_outline,
              color: Colors.white,
              size: 28,
            ),
          ),
          confirmDismiss: (direction) async {
            await _deleteScan(scan);
            return false; // We handle deletion manually
          },
          child: _buildHistoryItem(scan),
        );
      },
    );
  }

  /// Build individual history item
  Widget _buildHistoryItem(ScanResult scan) {
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
            // Navigate to history result screen with real data
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HistoryResultScreen(
                  plantName: scan.plantName,
                  imageAssetPath: scan.imageUrl,
                  deficiencyName:
                      scan.deficiencyDetected ?? 'Unknown Deficiency',
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
                  careTips: scan.isHealthy ? scan.careTips : null,
                  preventiveCare: scan.isHealthy ? scan.preventiveCare : null,
                  growthOptimization: scan.isHealthy ? scan.growthOptimization : null,
                  preventionTips: !scan.isHealthy ? scan.preventionTips : null,
                  onRescanPressed: () {
                    // LOG 1: Callback started
                    debugPrint('🔄 [RESCAN CALLBACK] Callback triggered');
                    debugPrint('   Context mounted: ${context.mounted}');

                    // LOG 1.5: Pre-select the plant before clearing/navigating
                    debugPrint('🌱 [RESCAN CALLBACK] Pre-selecting plant: ${scan.plantName}');
                    context.read<ScanProvider>().preselectPlant(scan.plantName);
                    debugPrint('✅ [RESCAN CALLBACK] Plant pre-selected successfully');

                    // LOG 2: Clear current scan
                    debugPrint('🧹 [RESCAN CALLBACK] Clearing current scan...');
                    context.read<ScanProvider>().clearCurrentScan();
                    debugPrint('✅ [RESCAN CALLBACK] Scan cleared successfully');

                    // LOG 3: Pop HistoryResultScreen to go back to History
                    debugPrint('🔙 [RESCAN CALLBACK] Popping HistoryResultScreen...');
                    Navigator.pop(context);
                    debugPrint('✅ [RESCAN CALLBACK] Navigator.pop() executed');

                    // LOG 4: Use TabProvider to switch to Scan tab (index 2)
                    // This bypasses GoRouter completely and works reliably for repeated navigation
                    debugPrint('🎯 [RESCAN CALLBACK] Switching to Scan tab via TabProvider...');
                    context.read<TabProvider>().setTab(2);
                    debugPrint('✅ [RESCAN CALLBACK] Tab switch complete!');
                  },
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                // Plant image or icon with health status overlay
                Stack(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreenModern.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
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
                                  color: AppColors.primaryGreenModern,
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) => Icon(
                            AppIcons.seedling,
                            color: AppColors.primaryGreenModern,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                    // Health status icon overlay
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                        child: Icon(
                          HealthStatusHelper.getHealthIcon(
                            isHealthy: scan.isHealthy,
                            severity: scan.severity,
                          ),
                          size: 12,
                          color: HealthStatusHelper.getHealthColor(
                            isHealthy: scan.isHealthy,
                            severity: scan.severity,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: AppSpacing.md),
                // Scan info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              scan.plantName,
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // Only show severity badge for deficient plants
                          if (!scan.isHealthy && scan.severity != null) ...[
                            const SizedBox(width: AppSpacing.sm),
                            SeverityBadge(severity: scan.severity!),
                          ],
                          // Show "Healthy" badge for healthy plants
                          if (scan.isHealthy) ...[
                            const SizedBox(width: AppSpacing.sm),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: HealthStatusHelper.healthyColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Healthy',
                                style: AppTextStyles.caption.copyWith(
                                  color: HealthStatusHelper.healthyColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        scan.deficiencyDetected ?? 'No deficiency detected',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            AppIcons.clock,
                            size: 12,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            dateFormat.format(scan.createdAt),
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          if (scan.confidence != null) ...[
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              '• ${(scan.confidence! * 100).toStringAsFixed(0)}%',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.primaryGreenModern,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                // Chevron
                Icon(
                  AppIcons.chevronRight,
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
}
