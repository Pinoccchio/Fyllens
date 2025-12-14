import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:fyllens/core/theme/app_colors.dart';
import 'package:fyllens/core/theme/app_text_styles.dart';
import 'package:fyllens/core/constants/app_spacing.dart';
import 'package:fyllens/core/constants/app_constants.dart';
import 'package:fyllens/core/constants/app_routes.dart';
import 'package:fyllens/core/theme/app_icons.dart';
import 'package:fyllens/providers/history_provider.dart';
import 'package:fyllens/providers/auth_provider.dart';
import 'package:fyllens/providers/tab_provider.dart';
import 'package:fyllens/providers/scan_provider.dart';
import 'package:fyllens/models/scan_result.dart';
import 'package:fyllens/screens/history/history_result_screen.dart';
import 'package:fyllens/core/utils/health_status_helper.dart';
import 'package:intl/intl.dart';
import 'package:fyllens/screens/shared/widgets/severity_badge.dart';

/// Home page - Main dashboard
///
/// Displays the main dashboard with:
/// - Quick scan action card
/// - Recent scan history (from database)
/// - Fyllens AI assistant chat interface
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load scan history on init
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
      debugPrint('⚠️  [HOME] User not authenticated, cannot load history');
      return;
    }

    debugPrint('📚 [HOME] Loading scan history for user: $userId');
    await historyProvider.loadHistory(userId);
  }

  @override
  Widget build(BuildContext context) {
    final historyProvider = context.watch<HistoryProvider>();
    final recentScans = historyProvider.scans.take(3).toList();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        title: Text(
          AppConstants.appName.toUpperCase(),
          style: AppTextStyles.heading1.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(AppIcons.notifications),
            color: AppColors.textSecondary,
            onPressed: () {
              // TODO: Navigate to notifications
            },
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadHistory,
          color: AppColors.primaryGreenModern,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Scan action card
                  _buildScanCard(context),
                  const SizedBox(height: AppSpacing.xl),

                  // Recent Scans section (from database)
                  _buildRecentScansSection(context, historyProvider, recentScans),
                  const SizedBox(height: AppSpacing.xl),

                  // Fyllens AI Assistant section
                  _buildFyllensAISection(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScanCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryGreenModern,
            AppColors.primaryGreenModern.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(AppIcons.camera, color: Colors.white, size: 32),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Scan Your Plant',
                      style: AppTextStyles.heading2.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Get instant diagnosis',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ElevatedButton(
            onPressed: () {
              // Navigate to Scan tab using TabProvider
              context.read<TabProvider>().setTab(2);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              foregroundColor: AppColors.primaryGreenModern,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              elevation: 0,
            ),
            child: Text(
              'Start Scanning',
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentScansSection(
    BuildContext context,
    HistoryProvider provider,
    List<ScanResult> recentScans,
  ) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Scans',
              style: AppTextStyles.heading2.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                // Navigate to history screen using GoRouter
                context.go(AppRoutes.home, extra: {'tab': '3'});
                context.read<TabProvider>().setTab(3);
              },
              child: Text(
                'View All',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.primaryGreenModern,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),

        // Loading state
        if (provider.isLoading && provider.scans.isEmpty)
          _buildLoadingState()

        // Empty state
        else if (recentScans.isEmpty)
          _buildEmptyState()

        // Recent scans list
        else
          Column(
            children: recentScans.map((scan) => _buildScanItem(context, scan)).toList(),
          ),
      ],
    );
  }

  /// Loading state with shimmer effect
  Widget _buildLoadingState() {
    return Column(
      children: List.generate(
        2,
        (index) => Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surfaceGray,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderLight, width: 1),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.borderLight,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 120,
                      height: 16,
                      decoration: BoxDecoration(
                        color: AppColors.borderLight,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 180,
                      height: 14,
                      decoration: BoxDecoration(
                        color: AppColors.borderLight,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Empty state for no scans
  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        children: [
          Icon(
            AppIcons.history,
            size: 64,
            color: AppColors.textSecondary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'No scan history yet',
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Start scanning plants to see history here',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanItem(BuildContext context, ScanResult scan) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    final now = DateTime.now();
    final difference = now.difference(scan.createdAt);

    // Format relative time
    String timeAgo;
    if (difference.inMinutes < 60) {
      timeAgo = '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      timeAgo = '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      timeAgo = 'Yesterday';
    } else if (difference.inDays < 7) {
      timeAgo = '${difference.inDays}d ago';
    } else {
      timeAgo = dateFormat.format(scan.createdAt);
    }

    return InkWell(
      onTap: () {
        // Navigate to HistoryResultScreen with scan data
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HistoryResultScreen(
              plantName: scan.plantName,
              imageAssetPath: scan.imageUrl,
              deficiencyName: scan.deficiencyDetected ?? 'Unknown Deficiency',
              severity: scan.severity ?? 'Unknown',
              symptoms: scan.symptoms ?? ['No symptoms recorded'],
              treatments: (scan.geminiTreatments ?? [
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
              growthOptimization:
                  scan.isHealthy ? scan.growthOptimization : null,
              preventionTips: !scan.isHealthy ? scan.preventionTips : null,
              onRescanPressed: () {
                debugPrint('🔄 [HOME RESCAN] Callback triggered');

                // Pre-select the plant before navigating
                debugPrint('🌱 [HOME RESCAN] Pre-selecting plant: ${scan.plantName}');
                context.read<ScanProvider>().preselectPlant(scan.plantName);
                debugPrint('✅ [HOME RESCAN] Plant pre-selected successfully');

                // Clear current scan
                debugPrint('🧹 [HOME RESCAN] Clearing current scan...');
                context.read<ScanProvider>().clearCurrentScan();
                debugPrint('✅ [HOME RESCAN] Scan cleared successfully');

                // Pop result screen
                debugPrint('🔙 [HOME RESCAN] Popping HistoryResultScreen...');
                Navigator.pop(context);

                // Switch to Scan tab
                debugPrint('🎯 [HOME RESCAN] Switching to Scan tab...');
                context.read<TabProvider>().setTab(2);
                debugPrint('✅ [HOME RESCAN] Tab switch complete!');
              },
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderLight, width: 1),
        ),
        child: Row(
          children: [
            // Plant image with health indicator
            Stack(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color:
                        AppColors.primaryGreenModern.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      scan.imageUrl,
                      fit: BoxFit.cover,
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          scan.plantName,
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Show severity badge or healthy badge
                      if (!scan.isHealthy && scan.severity != null) ...[
                        const SizedBox(width: AppSpacing.sm),
                        SeverityBadge(severity: scan.severity!),
                      ],
                      if (scan.isHealthy) ...[
                        const SizedBox(width: AppSpacing.sm),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: HealthStatusHelper.healthyColor
                                .withValues(alpha: 0.1),
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
                  const SizedBox(height: 2),
                  Text(
                    scan.deficiencyDetected ?? 'No deficiency detected',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        timeAgo,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      if (scan.confidence != null) ...[
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          '• ${(scan.confidence! * 100).toStringAsFixed(0)}%',
                          style: AppTextStyles.bodySmall.copyWith(
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
            Icon(AppIcons.chevronRight, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }

  Widget _buildFyllensAISection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with AI icon
        Row(
          children: [
            Icon(
              AppIcons.sparkle,
              color: AppColors.primaryGreenModern,
              size: 24,
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'Talk with Fyllens AI',
              style: AppTextStyles.heading2.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),

        // AI chat card with "Open Chat" button
        InkWell(
          onTap: () => context.push(AppRoutes.chat),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF4CAF50),
                  Color(0xFF66BB6A),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryGreenModern.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                // AI icon
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    AppIcons.chat,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),

                // Text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Chat with Fyllens AI",
                        style: AppTextStyles.heading3.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Ask about plant care, diseases, and more",
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),

                // Arrow icon
                Icon(
                  AppIcons.chevronRight,
                  color: Colors.white.withValues(alpha: 0.8),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
