import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fyllens/core/theme/app_colors.dart';
import 'package:fyllens/core/theme/app_text_styles.dart';
import 'package:fyllens/core/theme/app_gradients.dart';
import 'package:fyllens/core/constants/app_spacing.dart';
import 'package:fyllens/core/constants/app_routes.dart';
import 'package:fyllens/screens/shared/widgets/custom_card.dart';
import 'package:fyllens/screens/shared/widgets/custom_button.dart';
import 'package:fyllens/screens/shared/widgets/profile_avatar.dart';
import 'package:fyllens/screens/shared/widgets/image_picker_bottom_sheet.dart';
import 'package:fyllens/screens/shared/widgets/image_preview_dialog.dart';
import 'package:fyllens/core/theme/app_icons.dart';
import 'package:fyllens/providers/auth_provider.dart';
import 'package:fyllens/providers/profile_provider.dart';

/// Profile screen - "Organic Luxury" Design
///
/// Premium user profile experience with:
/// - Blurred avatar header background
/// - Forest gradient profile card
/// - Warm settings sections
/// - About dialog with team credits
/// - Smooth animations throughout
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final currentUser = authProvider.currentUser;
    final profileProvider = context.watch<ProfileProvider>();
    final isUploadingAvatar = profileProvider.isUploading;

    final displayName =
        currentUser?.fullName ?? currentUser?.email.split('@').first ?? 'User';
    final displayEmail = currentUser?.email ?? 'No email';
    final isLoading = authProvider.isLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: () => _refreshProfile(context),
        color: AppColors.accentGold,
        backgroundColor: AppColors.surfaceWarm,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // Premium header with avatar
            SliverAppBar(
              expandedHeight: 280,
              pinned: true,
              backgroundColor: AppColors.primaryForest,
              elevation: 0,
              scrolledUnderElevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Gradient background
                    Container(
                      decoration: BoxDecoration(
                        gradient: AppGradients.forest,
                      ),
                    ),
                    // Botanical pattern overlay
                    Positioned(
                      top: -50,
                      right: -50,
                      child: Opacity(
                        opacity: 0.08,
                        child: Icon(
                          AppIcons.leaf,
                          size: 200,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 50,
                      left: -30,
                      child: Opacity(
                        opacity: 0.06,
                        child: Icon(
                          AppIcons.leaf,
                          size: 120,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    // Profile content
                    SafeArea(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: AppSpacing.xl),
                            // Avatar with edit button
                            GestureDetector(
                              onTap: currentUser?.avatarUrl != null
                                  ? () => _showAvatarPreview(
                                      context, currentUser!.avatarUrl!)
                                  : null,
                              child: Stack(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppColors.accentGold,
                                        width: 3,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black
                                              .withValues(alpha: 0.2),
                                          blurRadius: 20,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: ProfileAvatar(
                                      avatarUrl: currentUser?.avatarUrl,
                                      displayName: currentUser?.fullName,
                                      email: currentUser?.email,
                                      size: 100,
                                      showEditButton: false,
                                      isUploading: isUploadingAvatar,
                                    ),
                                  ),
                                  // Edit button
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: () => _handleEditAvatar(context),
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: AppColors.accentGold,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppColors.accentGold
                                                  .withValues(alpha: 0.4),
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          AppIcons.camera,
                                          size: 18,
                                          color: AppColors.textOnGold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            // User name
                            Text(
                              displayName,
                              style: AppTextStyles.heading1.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            // Email
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.md,
                                vertical: AppSpacing.xs,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(
                                    AppSpacing.radiusPill),
                              ),
                              child: Text(
                                displayEmail,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: Colors.white.withValues(alpha: 0.9),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              title: Text(
                'Profile',
                style: AppTextStyles.heading2.copyWith(
                  color: Colors.white,
                ),
              ),
              centerTitle: true,
            ),

            // Profile content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.screenPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Account section
                    Text(
                      'Account',
                      style: AppTextStyles.heading3.copyWith(
                        color: AppColors.primaryForest,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _buildSettingsCard(
                      context,
                      icon: AppIcons.profile,
                      title: 'Edit Full Name',
                      subtitle: 'Update your display name',
                      onTap: () => context.push(AppRoutes.editProfile),
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    // Preferences section
                    Text(
                      'Preferences',
                      style: AppTextStyles.heading3.copyWith(
                        color: AppColors.primaryForest,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _buildSettingsCard(
                      context,
                      icon: AppIcons.info,
                      title: 'About Fyllens',
                      subtitle: 'App info and team credits',
                      onTap: () => _showAboutDialog(context),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _buildSettingsCard(
                      context,
                      icon: AppIcons.info,
                      title: 'Help & Support',
                      subtitle: 'FAQ and assistance',
                      onTap: () => _showHelpSupportDialog(context),
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    // Logout button
                    CustomButton.outlined(
                      text: 'Logout',
                      icon: AppIcons.signOut,
                      onPressed: isLoading
                          ? () {}
                          : () => _showLogoutConfirmation(context, authProvider),
                    ),

                    const SizedBox(height: AppSpacing.xxl),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return CustomCard.standard(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: (iconColor ?? AppColors.primarySage)
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: Icon(
                icon,
                size: 22,
                color: iconColor ?? AppColors.primarySage,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryForest,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              AppIcons.chevronRight,
              color: AppColors.textTertiary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> _refreshProfile(BuildContext context) async {
    final authProvider = context.read<AuthProvider>();
    await authProvider.refreshProfile();
  }

  Future<void> _handleEditAvatar(BuildContext context) async {
    debugPrint('\n📸 ProfileScreen: Edit avatar requested');

    final currentUser = context.read<AuthProvider>().currentUser;
    if (currentUser == null) {
      debugPrint('❌ ProfileScreen: No authenticated user');
      return;
    }

    final imageSource = await ImagePickerBottomSheet.show(context);
    if (imageSource == null) return;

    final picker = ImagePicker();
    XFile? pickedFile;

    try {
      pickedFile = await picker.pickImage(
        source: imageSource,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image: $e'),
            backgroundColor: AppColors.statusCritical,
          ),
        );
      }
      return;
    }

    if (pickedFile == null) return;

    if (!context.mounted) return;

    final success = await ImagePreviewDialog.show(
      context: context,
      imageFile: File(pickedFile.path),
      userId: currentUser.id,
    );

    if (!context.mounted) return;

    if (success == true) {
      final authProvider = context.read<AuthProvider>();
      await authProvider.refreshProfile();

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(AppIcons.checkCircle, color: Colors.white, size: 20),
              const SizedBox(width: AppSpacing.sm),
              const Text('Profile picture updated!'),
            ],
          ),
          backgroundColor: AppColors.statusHealthy,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          margin: const EdgeInsets.all(AppSpacing.md),
        ),
      );
    }
  }

  void _showAvatarPreview(BuildContext context, String avatarUrl) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) => Dialog.fullscreen(
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            // Blurred background
            Positioned.fill(
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Image.network(
                  avatarUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            // Overlay
            Positioned.fill(
              child: Container(
                color: Colors.black.withValues(alpha: 0.5),
              ),
            ),
            // Avatar preview
            Center(
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.accentGold,
                    width: 4,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accentGold.withValues(alpha: 0.3),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.network(
                    avatarUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.accentGold,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => Center(
                      child: Icon(
                        AppIcons.error,
                        color: Colors.white,
                        size: 48,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Close button
            Positioned(
              top: 20,
              right: 20,
              child: SafeArea(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceWarm.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(AppIcons.close, color: AppColors.primaryForest),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showLogoutConfirmation(
      BuildContext context, AuthProvider authProvider) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surfaceWarm,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        ),
        title: Text(
          'Logout',
          style: AppTextStyles.heading2.copyWith(
            color: AppColors.primaryForest,
          ),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(
              'Cancel',
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.statusCritical,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _handleLogout(context, authProvider);
    }
  }

  Future<void> _handleLogout(
      BuildContext context, AuthProvider authProvider) async {
    final success = await authProvider.signOut();

    if (!context.mounted) return;

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(AppIcons.error, color: Colors.white, size: 20),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                    authProvider.errorMessage ?? 'Logout failed. Please try again.'),
              ),
            ],
          ),
          backgroundColor: AppColors.statusCritical,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          margin: const EdgeInsets.all(AppSpacing.md),
        ),
      );
    }
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xl,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
          child: Container(
            color: AppColors.surfaceWarm,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with gradient - edge to edge
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: const BoxDecoration(
                    gradient: AppGradients.forest,
                  ),
                child: Column(
                  children: [
                    // Logo
                    Container(
                      width: 80,
                      height: 80,
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'assets/images/fyllens_logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Fyllens',
                      style: AppTextStyles.displayMedium.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accentGold,
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusPill),
                      ),
                      child: Text(
                        'v1.0.0',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.textOnGold,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Advanced plant health detection powered by AI and machine learning. Identify nutrient deficiencies and diseases in Rice, Corn, Okra, and Cucumber plants.',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'Development Team',
                      style: AppTextStyles.heading3.copyWith(
                        color: AppColors.primaryForest,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _buildTeamMember('JAN MIKO A. GUEVARRA', 'Backend Developer'),
                    _buildTeamMember('JAN CARLO SURIG', 'Frontend Developer'),
                    _buildTeamMember('RHEA GRACE BALATERO', 'ML Training'),
                    _buildTeamMember('JOHN MARK LIMSAM', 'ML Training'),
                    _buildTeamMember('MARLAN DIVA', 'ML Training'),
                    _buildTeamMember('JOAQUIM OLACO', 'QA & Testing'),
                    const SizedBox(height: AppSpacing.md),
                    Center(
                      child: Text(
                        'CSP Computer Science Students',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.textTertiary,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Close button
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  0,
                  AppSpacing.lg,
                  AppSpacing.lg,
                ),
                child: CustomButton.primary(
                  text: 'Close',
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }

  Widget _buildTeamMember(String name, String role) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: AppColors.accentGold,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textPrimary,
                ),
                children: [
                  TextSpan(
                    text: name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(
                    text: ' - $role',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showHelpSupportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xl,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
          child: Container(
            constraints: const BoxConstraints(maxHeight: 500),
            color: AppColors.surfaceWarm,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header - edge to edge
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: const BoxDecoration(
                    gradient: AppGradients.forest,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        AppIcons.info,
                        color: Colors.white,
                        size: 28,
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Text(
                        'Help & Support',
                        style: AppTextStyles.heading2.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                // FAQ content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Frequently Asked Questions',
                          style: AppTextStyles.heading3.copyWith(
                            color: AppColors.primaryForest,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        _buildFAQItem(
                          'How do I scan a plant?',
                          'Navigate to the Scan tab, select your plant species (Rice, Corn, Okra, or Cucumber), then tap the camera button.',
                        ),
                        _buildFAQItem(
                          'What plants are supported?',
                          'Currently, Fyllens supports Rice, Corn, Okra, and Cucumber.',
                        ),
                        _buildFAQItem(
                          'How accurate are the results?',
                          'Our ML model provides a confidence score (0-100%) with each detection. Higher scores indicate more reliable results.',
                        ),
                        _buildFAQItem(
                          'Can I view my scan history?',
                          'Yes! Navigate to the History tab to view all your past scans.',
                        ),
                      ],
                    ),
                  ),
                ),
                // Close button
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: CustomButton.primary(
                    text: 'Close',
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.primarySage.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(
          color: AppColors.primarySage.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                AppIcons.checkCircle,
                size: 18,
                color: AppColors.accentGold,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  question,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primaryForest,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Padding(
            padding: const EdgeInsets.only(left: 26),
            child: Text(
              answer,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
