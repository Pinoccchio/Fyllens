import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fyllens/core/theme/app_colors.dart';
import 'package:fyllens/core/theme/app_text_styles.dart';
import 'package:fyllens/core/constants/app_spacing.dart';
import 'package:fyllens/core/constants/app_routes.dart';
import 'package:fyllens/screens/shared/widgets/custom_list_tile.dart';
import 'package:fyllens/screens/shared/widgets/profile_avatar.dart';
import 'package:fyllens/screens/shared/widgets/image_picker_bottom_sheet.dart';
import 'package:fyllens/screens/shared/widgets/image_preview_dialog.dart';
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
    final displayName = currentUser?.fullName ?? currentUser?.email.split('@').first ?? 'User';
    final displayEmail = currentUser?.email ?? 'No email';
    final isLoading = authProvider.isLoading;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        title: Text(
          'Profile',
          style: AppTextStyles.heading1.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Green profile card (like scan card on home screen)
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryGreenModern,
                      AppColors.primaryGreenModern.withValues(alpha: 0.85),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryGreenModern.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Avatar with camera icon overlay and preview on tap
                    GestureDetector(
                      onTap: currentUser?.avatarUrl != null
                          ? () => _showAvatarPreview(context, currentUser!.avatarUrl!)
                          : null,
                      child: ProfileAvatar(
                        avatarUrl: currentUser?.avatarUrl,
                        displayName: currentUser?.fullName,
                        email: currentUser?.email,
                        size: 70,
                        showEditButton: true,
                        onEditPressed: () => _handleEditAvatar(context),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    // Name and email
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            displayName,
                            style: AppTextStyles.heading2.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            displayEmail,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: Colors.white.withValues(alpha: 0.95),
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Account section
              Padding(
                padding: EdgeInsets.zero,
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
                padding: EdgeInsets.zero,
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
                      icon: AppIcons.info,
                      title: 'About Fyllens',
                      onTap: () => _showAboutDialog(context),
                    ),
                    CustomListTile(
                      icon: AppIcons.info,
                      title: 'Help & Support',
                      onTap: () => _showHelpSupportDialog(context),
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
      ),
    );
  }

  /// Handle avatar edit - shows image picker and preview
  Future<void> _handleEditAvatar(BuildContext context) async {
    debugPrint('\n📸 ProfileScreen: Edit avatar requested');

    final currentUser = context.read<AuthProvider>().currentUser;
    if (currentUser == null) {
      debugPrint('❌ ProfileScreen: No authenticated user');
      return;
    }

    // Show image source picker bottom sheet
    final imageSource = await ImagePickerBottomSheet.show(context);
    if (imageSource == null) {
      debugPrint('   User cancelled image source selection');
      return;
    }

    debugPrint('   Image source selected: $imageSource');

    // Pick image from selected source
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
      debugPrint('❌ ProfileScreen: Image picker error: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
      return;
    }

    if (pickedFile == null) {
      debugPrint('   User cancelled image selection');
      return;
    }

    debugPrint('   Image selected: ${pickedFile.path}');

    if (!context.mounted) return;

    // Show preview dialog with upload functionality
    final success = await ImagePreviewDialog.show(
      context: context,
      imageFile: File(pickedFile.path),
      userId: currentUser.id,
    );

    if (success == true) {
      debugPrint('✅ ProfileScreen: Avatar updated successfully');
      if (context.mounted) {
        // Refresh auth provider to get updated user data
        final authProvider = context.read<AuthProvider>();
        await authProvider.refreshProfile();

        // Check if refresh had errors
        if (authProvider.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Avatar uploaded but failed to refresh: ${authProvider.errorMessage}'),
              backgroundColor: Colors.orange,
              action: SnackBarAction(
                label: 'Retry',
                textColor: Colors.white,
                onPressed: () => authProvider.refreshProfile(),
              ),
            ),
          );
        } else {
          // Success - show confirmation
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Profile picture updated successfully!'),
              backgroundColor: AppColors.primaryGreenModern,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    }
  }

  /// Show avatar preview dialog - Minimal TikTok/Instagram style with blur background
  void _showAvatarPreview(BuildContext context, String avatarUrl) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) => Dialog.fullscreen(
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            // Blurred background image
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

            // Dark overlay
            Positioned.fill(
              child: Container(
                color: Colors.black.withValues(alpha: 0.5),
              ),
            ),

            // Circular preview (centered)
            Center(
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 4,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 20,
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
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.primaryGreenModern,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => Center(
                      child: Icon(
                        Icons.error_outline,
                        color: Colors.white,
                        size: 48,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Close button at top-right
            Positioned(
              top: 20,
              right: 20,
              child: SafeArea(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 26),
                    iconSize: 26,
                    padding: const EdgeInsets.all(8),
                    onPressed: () => Navigator.pop(context),
                    tooltip: 'Close',
                  ),
                ),
              ),
            ),
          ],
        ),
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

  /// Show About Fyllens dialog with app info and team credits
  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        content: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with gradient
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryGreenModern,
                      AppColors.primaryGreenModern.withValues(alpha: 0.85),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppSpacing.radiusMd),
                    topRight: Radius.circular(AppSpacing.radiusMd),
                  ),
                ),
                child: Column(
                  children: [
                    // App icon
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        AppIcons.leafFilled,
                        size: 48,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    // App name
                    Text(
                      'Fyllens',
                      style: AppTextStyles.heading1.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    // Version badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'v1.0.0',
                        style: AppTextStyles.caption.copyWith(
                          color: Colors.white,
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
                    // Description
                    Text(
                      'Advanced plant health detection powered by AI and machine learning. Identify nutrient deficiencies and diseases in Rice, Corn, Okra, and Cucumber plants.',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    // Team credits section
                    Text(
                      'Development Team',
                      style: AppTextStyles.heading3.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _buildTeamMember('JAN MIKO A. GUEVARRA', 'Backend Developer'),
                    _buildTeamMember('JAN CARLO SURIG', 'User Interface'),
                    _buildTeamMember('RHEA GRACE BALATERO', 'User Interface (Assistant)'),
                    _buildTeamMember('JOHN MARK LIMSAM', 'Dataset Training'),
                    _buildTeamMember('MARLAN DIVA', 'Dataset Training'),
                    _buildTeamMember('JOAQUIM OLACO', 'Tester'),
                    const SizedBox(height: AppSpacing.md),
                    // Footer
                    Center(
                      child: Text(
                        'BSU Computer Science Students',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
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
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreenModern,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.md,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      ),
                    ),
                    child: Text(
                      'Close',
                      style: AppTextStyles.buttonMedium,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build team member row
  Widget _buildTeamMember(String name, String role) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: AppColors.primaryGreenModern,
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

  /// Show Help & Support dialog with FAQ
  void _showHelpSupportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: Container(
          constraints: const BoxConstraints(maxHeight: 600),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryGreenModern,
                      AppColors.primaryGreenModern.withValues(alpha: 0.85),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppSpacing.radiusMd),
                    topRight: Radius.circular(AppSpacing.radiusMd),
                  ),
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
                        fontWeight: FontWeight.bold,
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
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _buildFAQItem(
                        'How do I scan a plant?',
                        'Navigate to the Scan tab, select your plant species (Rice, Corn, Okra, or Cucumber), then tap the camera button. Ensure good lighting and focus on affected leaves for best results.',
                      ),
                      _buildFAQItem(
                        'What plants are supported?',
                        'Currently, Fyllens supports Rice, Corn, Okra, and Cucumber. We are working on adding more crop types in future updates.',
                      ),
                      _buildFAQItem(
                        'How accurate are the results?',
                        'Our machine learning model provides a confidence score (0-100%) with each detection. Higher confidence scores indicate more reliable results. For best accuracy, ensure clear, well-lit photos.',
                      ),
                      _buildFAQItem(
                        'What if my plant isn\'t detected correctly?',
                        'Try rescanning with better lighting or a different angle. Focus on the most affected parts of the plant. You can also use the Fyllens AI chat for additional plant care advice.',
                      ),
                      _buildFAQItem(
                        'Can I view my scan history?',
                        'Yes! Navigate to the History tab to view all your past scans, including detected deficiencies, treatments, and recommendations.',
                      ),
                      _buildFAQItem(
                        'How does the AI chat work?',
                        'Fyllens AI is powered by Google Gemini and can answer questions about plant care, nutrient deficiencies, and diseases. Access it from the Chat tab or Home screen.',
                      ),
                    ],
                  ),
                ),
              ),
              // Close button
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreenModern,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.md,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      ),
                    ),
                    child: Text(
                      'Close',
                      style: AppTextStyles.buttonMedium,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build FAQ item
  Widget _buildFAQItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.primaryGreenModern.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(
          color: AppColors.primaryGreenModern.withValues(alpha: 0.2),
          width: 1,
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
                size: 20,
                color: AppColors.primaryGreenModern,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  question,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Padding(
            padding: const EdgeInsets.only(left: 28),
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
