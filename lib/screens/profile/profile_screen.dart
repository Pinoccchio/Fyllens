import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:fyllens/core/theme/app_colors.dart';
import 'package:fyllens/core/theme/app_text_styles.dart';
import 'package:fyllens/core/constants/app_spacing.dart';
import 'package:fyllens/core/constants/app_routes.dart';
import 'package:fyllens/screens/shared/widgets/custom_list_tile.dart';
import 'package:fyllens/core/theme/app_icons.dart';
import 'package:fyllens/providers/auth_provider.dart';

/// Profile page - User account and settings
///
/// Displays authenticated user's profile information and settings.
/// Includes logout functionality that redirects to splash/login screen.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get current authenticated user from AuthProvider
    final authProvider = context.watch<AuthProvider>();
    final currentUser = authProvider.currentUser;

    // Extract user display information
    final displayName = currentUser?.fullName ?? currentUser?.email?.split('@').first ?? 'User';
    final displayEmail = currentUser?.email ?? 'No email';
    final isLoading = authProvider.isLoading;

    return Scaffold(
      backgroundColor: AppColors.backgroundSoft,
      body: CustomScrollView(
        slivers: [
          // Profile header (no AppBar)
          SliverToBoxAdapter(
            child: Container(
              height: 240,
              decoration: const BoxDecoration(
                color: AppColors.primaryGreenModern,
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Avatar
                      Container(
                        width: 80,
                        height: 80,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          AppIcons.profile,
                          size: 45,
                          color: AppColors.primaryGreenModern,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      // Name with overflow protection
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                        child: Text(
                          displayName,
                          style: AppTextStyles.heading1.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Email with overflow protection
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                        child: Text(
                          displayEmail,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Scrollable content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.lg),
              // Account section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Account',
                      style: AppTextStyles.heading3,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    CustomListTile(
                      icon: AppIcons.profile,
                      title: 'Edit Profile',
                      onTap: () {
                        // TODO: Navigate to edit profile
                      },
                    ),
                    CustomListTile(
                      icon: AppIcons.profile,
                      title: 'Change Username',
                      onTap: () {
                        // TODO: Navigate to change username
                      },
                    ),
                    CustomListTile(
                      icon: AppIcons.lock,
                      title: 'Change Password',
                      onTap: () {
                        // TODO: Navigate to change password
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              // Preferences section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Preferences',
                      style: AppTextStyles.heading3,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    CustomListTile(
                      icon: AppIcons.settings,
                      title: 'Theme',
                      trailing: 'Default',
                      onTap: () {
                        // TODO: Show theme selector
                      },
                    ),
                    CustomListTile(
                      icon: AppIcons.notifications,
                      title: 'Notifications',
                      onTap: () {
                        // TODO: Navigate to notification settings
                      },
                    ),
                    CustomListTile(
                      icon: AppIcons.info,
                      title: 'About Fyllena',
                      onTap: () {
                        // TODO: Show about dialog
                      },
                    ),
                    CustomListTile(
                      icon: AppIcons.info,
                      title: 'Help & Support',
                      onTap: () {
                        // TODO: Navigate to help
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    // Logout button with confirmation dialog
                    CustomListTile(
                      icon: AppIcons.signOut,
                      title: 'Logout',
                      onTap: isLoading ? null : () => _showLogoutConfirmation(context, authProvider),
                      iconColor: Colors.red[700],
                      iconBackgroundColor: Colors.red[50],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ],
    ),
    );
  }

  /// Show logout confirmation dialog
  Future<void> _showLogoutConfirmation(BuildContext context, AuthProvider authProvider) async {
    debugPrint('\n🚪 ProfileScreen: Logout confirmation requested');

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        title: Text(
          'Logout',
          style: AppTextStyles.heading2,
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          // Cancel button
          TextButton(
            onPressed: () {
              debugPrint('   User cancelled logout');
              Navigator.pop(dialogContext, false);
            },
            child: Text(
              'Cancel',
              style: AppTextStyles.buttonMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          // Logout button
          TextButton(
            onPressed: () {
              debugPrint('   ✅ User confirmed logout');
              Navigator.pop(dialogContext, true);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red[700],
            ),
            child: Text(
              'Logout',
              style: AppTextStyles.buttonMedium.copyWith(
                color: Colors.red[700],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    // Only proceed with logout if user confirmed
    if (confirmed == true) {
      await _handleLogout(context, authProvider);
    }
  }

  /// Handle logout - Signs out user and navigates to login screen
  ///
  /// Logout flow:
  /// 1. Call AuthProvider.signOut() to clear session
  /// 2. AuthProvider notifies listeners of auth state change
  /// 3. GoRouter's refreshListenable detects change and triggers redirect
  /// 4. Explicit navigation to login as fallback safety measure
  Future<void> _handleLogout(BuildContext context, AuthProvider authProvider) async {
    debugPrint('\n🚪 ProfileScreen: Logout initiated');

    // Call AuthProvider.signOut()
    final success = await authProvider.signOut();

    if (!context.mounted) return;

    if (success) {
      debugPrint('✅ ProfileScreen: Logout successful');
      debugPrint('   Auth state changed - notifyListeners() called');
      debugPrint('   GoRouter.refreshListenable will detect change');

      // Explicit navigation as fallback (GoRouter redirect should handle this automatically)
      // This ensures logout works even if redirect logic has issues
      debugPrint('   Navigating to login screen...');
      context.go(AppRoutes.login);

      debugPrint('✅ ProfileScreen: Navigation to login completed');
    } else {
      debugPrint('❌ ProfileScreen: Logout failed');
      // Show error message to user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage ?? 'Logout failed. Please try again.'),
          backgroundColor: Colors.red[700],
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
