import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:fyllens/core/theme/app_colors.dart';
import 'package:fyllens/core/theme/app_text_styles.dart';
import 'package:fyllens/core/constants/app_spacing.dart';
import 'package:fyllens/core/theme/app_icons.dart';
import 'package:fyllens/providers/scan_provider.dart';
import 'package:fyllens/providers/auth_provider.dart';
import 'package:fyllens/core/constants/app_routes.dart';

/// Camera screen for capturing plant images
///
/// Allows users to take photos or select from gallery
/// for ML-based plant deficiency detection
class CameraScreen extends StatefulWidget {
  final String plantName;

  const CameraScreen({
    super.key,
    required this.plantName,
  });

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    // Clear any previous image when returning to this screen
    _selectedImage = null;
    _isProcessing = false;
    // Auto-open camera on screen load (optional)
    // _openCamera();
  }

  Future<void> _openCamera() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (photo != null) {
        setState(() {
          _selectedImage = File(photo.path);
        });
      }
    } catch (e) {
      _showErrorDialog('Camera Error', 'Unable to access camera. Please check permissions.');
    }
  }

  Future<void> _openGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      _showErrorDialog('Gallery Error', 'Unable to access gallery. Please check permissions.');
    }
  }

  Future<void> _processImage() async {
    if (_selectedImage == null) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      print('\n📸 [CAMERA SCREEN] Starting image processing...');
      print('   Plant Name: ${widget.plantName}');
      print('   Image Path: ${_selectedImage!.path}');

      // Get userId from AuthProvider
      final authProvider = context.read<AuthProvider>();
      final userId = authProvider.currentUser?.id;

      print('   User ID: ${userId ?? "NULL - NOT AUTHENTICATED"}');

      // Validate userId
      if (userId == null || userId.isEmpty) {
        setState(() {
          _isProcessing = false;
        });
        _showErrorDialog(
          'Authentication Required',
          'You must be signed in to perform a scan. Please sign in and try again.',
        );
        print('   ❌ [CAMERA SCREEN] Error: User not authenticated');
        return;
      }

      final scanProvider = context.read<ScanProvider>();

      // Perform ML analysis
      print('   🔬 [CAMERA SCREEN] Calling performScan()...');
      final success = await scanProvider.performScan(
        imageFile: _selectedImage!,
        plantId: null, // Optional - database accepts NULL
        plantName: widget.plantName,
        userId: userId,
      );

      print('   📊 [CAMERA SCREEN] performScan() result: $success');

      if (!mounted) return;

      // Check if scan was successful before navigating
      if (success) {
        print('   ✅ [CAMERA SCREEN] Scan successful! Navigating to results...');
        context.pushReplacement(AppRoutes.scanResult);
      } else {
        setState(() {
          _isProcessing = false;
        });

        final errorMessage = scanProvider.errorMessage ??
            'Failed to analyze the image. Please try again.';

        print('   ❌ [CAMERA SCREEN] Scan failed!');
        print('   Error Message: $errorMessage');

        _showErrorDialog(
          'Scan Failed',
          errorMessage,
        );
      }
    } catch (e, stackTrace) {
      print('   🚨 [CAMERA SCREEN] Exception caught in _processImage():');
      print('   Exception: $e');
      print('   Stack Trace: $stackTrace');

      if (!mounted) return;

      setState(() {
        _isProcessing = false;
      });

      _showErrorDialog(
        'Processing Error',
        'An unexpected error occurred: $e',
      );
    }
  }

  void _retakePhoto() {
    setState(() {
      _selectedImage = null;
    });
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: _selectedImage == null
            ? _buildCameraOptions()
            : _buildImagePreview(),
      ),
    );
  }

  Widget _buildCameraOptions() {
    return Stack(
      children: [
        // Background gradient
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.backgroundDark,
                AppColors.backgroundDark.withValues(alpha: 0.9),
              ],
            ),
          ),
        ),

        // Content
        Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: Icon(
                      AppIcons.arrowBack,
                      color: AppColors.backgroundLight,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Scan ${widget.plantName}',
                          style: AppTextStyles.heading2.copyWith(
                            color: AppColors.backgroundLight,
                          ),
                        ),
                        Text(
                          'Take or select a photo',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.backgroundLight.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Camera placeholder with instructions
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primaryGreenModern.withValues(alpha: 0.3),
                          width: 3,
                        ),
                      ),
                      child: Icon(
                        AppIcons.camera,
                        size: 80,
                        color: AppColors.primaryGreenModern.withValues(alpha: 0.5),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Text(
                      'Capture a Clear Photo',
                      style: AppTextStyles.heading2.copyWith(
                        color: AppColors.backgroundLight,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                      child: Text(
                        'Make sure the affected leaves are visible and well-lit',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.backgroundLight.withValues(alpha: 0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom action buttons
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Gallery button
                  _buildActionButton(
                    icon: AppIcons.image,
                    label: 'Gallery',
                    onTap: _openGallery,
                  ),

                  // Camera button (primary)
                  _buildPrimaryCameraButton(),

                  // Spacer to balance layout
                  const SizedBox(width: 80),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildImagePreview() {
    return Stack(
      children: [
        // Image preview
        Positioned.fill(
          child: Image.file(
            _selectedImage!,
            fit: BoxFit.contain,
          ),
        ),

        // Top bar
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.7),
                  Colors.transparent,
                ],
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: _retakePhoto,
                  icon: Icon(
                    AppIcons.close,
                    color: AppColors.backgroundLight,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreenModern.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    border: Border.all(
                      color: AppColors.primaryGreenModern,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    widget.plantName,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.backgroundLight,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Bottom action bar
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.8),
                  Colors.transparent,
                ],
              ),
            ),
            child: Column(
              children: [
                if (_isProcessing)
                  Column(
                    children: [
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primaryGreenModern,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'Analyzing image...',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.backgroundLight,
                        ),
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      // Retake button
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _retakePhoto,
                          icon: Icon(AppIcons.camera),
                          label: const Text('Retake'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.backgroundLight,
                            side: BorderSide(
                              color: AppColors.backgroundLight.withValues(alpha: 0.5),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: AppSpacing.md,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),

                      // Use photo button
                      Expanded(
                        flex: 2,
                        child: ElevatedButton.icon(
                          onPressed: _processImage,
                          icon: Icon(AppIcons.checkCircle),
                          label: const Text('Analyze Image'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryGreenModern,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              vertical: AppSpacing.md,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPrimaryCameraButton() {
    return GestureDetector(
      onTap: _openCamera,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primaryGreenModern,
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryGreenModern.withValues(alpha: 0.4),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Icon(
          AppIcons.camera,
          size: 36,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surfaceLight.withValues(alpha: 0.3),
              border: Border.all(
                color: AppColors.backgroundLight.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Icon(
              icon,
              size: 28,
              color: AppColors.backgroundLight,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.backgroundLight,
            ),
          ),
        ],
      ),
    );
  }
}
