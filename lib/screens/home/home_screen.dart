import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:fyllens/core/theme/app_colors.dart';
import 'package:fyllens/core/theme/app_text_styles.dart';
import 'package:fyllens/core/constants/app_spacing.dart';
import 'package:fyllens/core/constants/app_constants.dart';
import 'package:fyllens/core/constants/app_routes.dart';
import 'package:fyllens/core/theme/app_icons.dart';
import 'package:fyllens/core/theme/app_gradients.dart';
import 'package:fyllens/providers/history_provider.dart';
import 'package:fyllens/providers/auth_provider.dart';
import 'package:fyllens/providers/tab_provider.dart';
import 'package:fyllens/providers/scan_provider.dart';
import 'package:fyllens/providers/notification_provider.dart';
import 'package:fyllens/models/scan_result.dart';
import 'package:fyllens/screens/history/history_result_screen.dart';
import 'package:fyllens/core/utils/health_status_helper.dart';
import 'package:fyllens/core/utils/timestamp_formatter.dart';
import 'package:fyllens/screens/shared/widgets/custom_button.dart';
import 'package:fyllens/screens/shared/widgets/custom_card.dart';
import 'package:fyllens/screens/shared/widgets/leaf_loader.dart';

/// Home page - Main dashboard with "Organic Luxury" design
///
/// Displays the main dashboard with:
/// - Hero scan card with forest gradient
/// - Quick stats row
/// - Horizontal scrolling recent scans
/// - Fyllens AI assistant card with gold-coral gradient
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
    final notificationProvider = context.read<NotificationProvider>();

    final userId = authProvider.currentUser?.id;
    if (userId == null) {
      debugPrint('⚠️  [HOME] User not authenticated, cannot load history');
      return;
    }

    debugPrint('📚 [HOME] Loading scan history for user: $userId');
    await historyProvider.loadHistory(userId);

    // Load notifications
    debugPrint('🔔 [HOME] Loading notifications for user: $userId');
    await notificationProvider.loadNotifications(userId);
  }

  @override
  Widget build(BuildContext context) {
    final historyProvider = context.watch<HistoryProvider>();
    final notificationProvider = context.watch<NotificationProvider>();
    final recentScans = historyProvider.scans.take(5).toList();
    final unreadCount = notificationProvider.unreadCount;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadHistory,
          color: AppColors.accentGold,
          backgroundColor: AppColors.surfaceLight,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // Custom App Bar
              SliverToBoxAdapter(
                child: _buildAppBar(context, unreadCount),
              ),

              // Main content
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: AppSpacing.md),

                    // Hero Scan Card
                    _buildHeroScanCard(context),
                    const SizedBox(height: AppSpacing.xl),

                    // Quick Stats Row
                    _buildQuickStatsRow(context, historyProvider),
                    const SizedBox(height: AppSpacing.xl),

                    // Recent Scans section (horizontal scroll)
                    _buildRecentScansSection(context, historyProvider, recentScans),
                    const SizedBox(height: AppSpacing.xl),

                    // Fyllens AI Assistant section
                    _buildFyllensAISection(context),
                    const SizedBox(height: AppSpacing.xxl),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Premium App Bar with botanical styling
  Widget _buildAppBar(BuildContext context, int unreadCount) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.md,
        AppSpacing.screenPadding,
        0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo and title
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppConstants.appName.toUpperCase(),
                style: AppTextStyles.displayMedium.copyWith(
                  color: AppColors.primaryForest,
                  letterSpacing: 3.0,
                ),
              ),
              Text(
                'Plant Health Assistant',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),

          // Notification button
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceWarm,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  boxShadow: AppSpacing.shadowSubtle,
                ),
                child: IconButton(
                  icon: Icon(AppIcons.notifications),
                  color: AppColors.primaryForest,
                  onPressed: () => context.push(AppRoutes.notifications),
                ),
              ),
              if (unreadCount > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      gradient: AppGradients.goldCoral,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accentCoral.withValues(alpha: 0.4),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Text(
                      unreadCount > 99 ? '99+' : '$unreadCount',
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  /// Hero Scan Card - Forest gradient with gold CTA
  Widget _buildHeroScanCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPaddingLg),
      decoration: BoxDecoration(
        gradient: AppGradients.forest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryForest.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Fyllens logo
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Image.asset(
                  'assets/images/fyllens_logo.png',
                  width: 48,
                  height: 48,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Scan Your Plant',
                      style: AppTextStyles.displaySmall.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Get instant AI-powered diagnosis\nfor nutrient deficiencies',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white.withValues(alpha: 0.85),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // Gold "Start Scanning" button
          CustomButton.primary(
            text: 'Start Scanning',
            icon: AppIcons.camera,
            onPressed: () {
              context.read<TabProvider>().setTab(2);
            },
            fullWidth: true,
          ),
        ],
      ),
    );
  }

  /// Quick Stats Row - 3 mini metric cards
  Widget _buildQuickStatsRow(BuildContext context, HistoryProvider provider) {
    final totalScans = provider.scans.length;
    final healthyCount = provider.scans.where((s) => s.isHealthy).length;
    final issuesCount = totalScans - healthyCount;

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            icon: AppIcons.history,
            value: '$totalScans',
            label: 'Total Scans',
            gradient: AppGradients.sage,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _buildStatCard(
            context,
            icon: AppIcons.checkmark,
            value: '$healthyCount',
            label: 'Healthy',
            gradient: AppGradients.mint,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _buildStatCard(
            context,
            icon: AppIcons.warning,
            value: '$issuesCount',
            label: 'Issues Found',
            gradient: AppGradients.goldCoral,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String value,
    required String label,
    required LinearGradient gradient,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        boxShadow: AppSpacing.shadowLight,
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: AppSpacing.iconMd),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: AppTextStyles.displaySmall.copyWith(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: Colors.white.withValues(alpha: 0.85),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Recent Scans Section with horizontal scrolling cards
  Widget _buildRecentScansSection(
    BuildContext context,
    HistoryProvider provider,
    List<ScanResult> recentScans,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Scans',
              style: AppTextStyles.heading2.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            TextButton(
              onPressed: () {
                context.go(AppRoutes.home, extra: {'tab': '3'});
                context.read<TabProvider>().setTab(3);
              },
              style: TextButton.styleFrom(
                foregroundColor: AppColors.accentGold,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'View All',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.accentGold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    AppIcons.chevronRight,
                    size: 16,
                    color: AppColors.accentGold,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),

        // Content
        if (provider.isLoading && provider.scans.isEmpty)
          _buildLoadingState()
        else if (recentScans.isEmpty)
          _buildEmptyState()
        else
          _buildHorizontalScansList(context, recentScans),
      ],
    );
  }

  /// Horizontal scrolling list of scan cards
  Widget _buildHorizontalScansList(BuildContext context, List<ScanResult> scans) {
    return SizedBox(
      height: 180,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: scans.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
        itemBuilder: (context, index) => _buildScanCard(context, scans[index]),
      ),
    );
  }

  /// Individual scan card for horizontal list
  Widget _buildScanCard(BuildContext context, ScanResult scan) {
    final timeAgo = TimestampFormatter.formatAgo(scan.createdAt);

    return GestureDetector(
      onTap: () => _navigateToScanResult(context, scan),
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surfaceWarm,
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
          border: Border.all(
            color: scan.isHealthy
                ? AppColors.statusHealthy.withValues(alpha: 0.3)
                : AppColors.statusWarning.withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: AppSpacing.shadowCard,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with health indicator
            Stack(
              children: [
                Container(
                  height: 80,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceCream,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    child: Image.network(
                      scan.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Center(
                        child: Icon(
                          AppIcons.seedling,
                          color: AppColors.primarySage,
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                ),
                // Health badge
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: scan.isHealthy
                          ? AppColors.statusHealthy
                          : HealthStatusHelper.getHealthColor(
                              isHealthy: scan.isHealthy,
                              severity: scan.severity,
                            ),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                    ),
                    child: Text(
                      scan.isHealthy ? 'Healthy' : scan.severity ?? 'Issue',
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),

            // Plant name
            Text(
              scan.plantName,
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),

            // Deficiency or healthy status
            Text(
              scan.isHealthy
                  ? 'No issues detected'
                  : scan.deficiencyDetected ?? 'Unknown',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            const Spacer(),

            // Time ago
            Text(
              timeAgo,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToScanResult(BuildContext context, ScanResult scan) {
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
                    'description':
                        t['description']?.toString() ?? 'Apply appropriate treatment',
                  })
              .toList(),
          careTips: scan.isHealthy ? scan.careTips : null,
          preventiveCare: scan.isHealthy ? scan.preventiveCare : null,
          growthOptimization: scan.isHealthy ? scan.growthOptimization : null,
          preventionTips: !scan.isHealthy ? scan.preventionTips : null,
          onRescanPressed: () {
            debugPrint('🔄 [HOME RESCAN] Callback triggered');
            context.read<ScanProvider>().preselectPlant(scan.plantName);
            context.read<ScanProvider>().clearCurrentScan();
            Navigator.pop(context);
            context.read<TabProvider>().setTab(2);
          },
        ),
      ),
    );
  }

  /// Loading state with leaf animation
  Widget _buildLoadingState() {
    return SizedBox(
      height: 180,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const LeafLoader.medium(),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Loading your scans...',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Empty state for no scans
  Widget _buildEmptyState() {
    return SizedBox(
      width: double.infinity,
      child: CustomCard.outlined(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.primarySage.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                AppIcons.seedling,
                size: 48,
                color: AppColors.primarySage,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'No scans yet',
              style: AppTextStyles.heading3.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Scan your first plant to start\ntracking its health',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Fyllens AI Section with gold-coral gradient
  Widget _buildFyllensAISection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: AppGradients.goldCoral,
                borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
              ),
              child: Icon(
                AppIcons.sparkle,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'Fyllens AI',
              style: AppTextStyles.heading2.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),

        // AI chat card
        GestureDetector(
          onTap: () => context.push(AppRoutes.chat),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.cardPadding),
            decoration: BoxDecoration(
              gradient: AppGradients.goldCoral,
              borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
              boxShadow: AppSpacing.shadowGold,
            ),
            child: Row(
              children: [
                // AI avatar
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                      width: 1,
                    ),
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
                        'Ask Fyllens AI',
                        style: AppTextStyles.heading3.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Get expert advice on plant care,\ndiseases, and treatments',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),

                // Arrow
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    AppIcons.chevronRight,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
