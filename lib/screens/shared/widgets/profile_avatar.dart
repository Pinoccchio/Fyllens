import 'package:flutter/material.dart';
import 'package:fyllens/core/theme/app_colors.dart';

/// Profile avatar widget with camera icon overlay
/// Displays user's profile image or initials with an edit button
class ProfileAvatar extends StatelessWidget {
  final String? avatarUrl;
  final String? displayName;
  final String? email;
  final double size;
  final VoidCallback? onEditPressed;
  final bool showEditButton;

  const ProfileAvatar({
    super.key,
    this.avatarUrl,
    this.displayName,
    this.email,
    this.size = 120,
    this.onEditPressed,
    this.showEditButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Avatar circle
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primaryGreen.withValues(alpha: 0.1),
            border: Border.all(
              color: AppColors.primaryGreen.withValues(alpha: 0.2),
              width: 2,
            ),
          ),
          child: ClipOval(
            child: avatarUrl != null && avatarUrl!.isNotEmpty
                ? Image.network(
                    avatarUrl!,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.primaryGreen,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      // DIAGNOSTIC LOGGING - Phase 1: Identify why Image.network() fails
                      debugPrint('🔴 [AVATAR ERROR] Failed to load profile picture');
                      debugPrint('   URL: $avatarUrl');
                      debugPrint('   Error type: ${error.runtimeType}');
                      debugPrint('   Error details: $error');
                      if (stackTrace != null) {
                        debugPrint('   Stack trace (first 3 lines):');
                        final lines = stackTrace.toString().split('\n').take(3);
                        for (var line in lines) {
                          debugPrint('   $line');
                        }
                      }
                      debugPrint('   Falling back to initials avatar');
                      return _buildInitialsAvatar();
                    },
                  )
                : _buildInitialsAvatar(),
          ),
        ),

        // Camera icon button (positioned at bottom-right)
        if (showEditButton)
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: onEditPressed,
              child: Container(
                width: size * 0.3,
                height: size * 0.3,
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadowMedium,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: size * 0.15,
                ),
              ),
            ),
          ),
      ],
    );
  }

  /// Build initials avatar fallback
  Widget _buildInitialsAvatar() {
    final initials = _getInitials();
    return Container(
      color: AppColors.primaryGreen.withValues(alpha: 0.1),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            fontSize: size * 0.35,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryGreen,
          ),
        ),
      ),
    );
  }

  /// Get user initials from display name or email
  String _getInitials() {
    if (displayName != null && displayName!.isNotEmpty) {
      final parts = displayName!.trim().split(' ');
      if (parts.length >= 2) {
        return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      }
      return displayName![0].toUpperCase();
    }

    if (email != null && email!.isNotEmpty) {
      return email![0].toUpperCase();
    }

    return 'U';
  }
}
