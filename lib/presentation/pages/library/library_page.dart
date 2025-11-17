import 'package:flutter/material.dart';
import 'package:fyllens/core/theme/app_colors.dart';
import 'package:fyllens/core/constants/app_constants.dart';

/// Library page
/// Plant species information library
class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(AppConstants.libraryLabel),
        backgroundColor: AppColors.primaryGreen,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.library_books,
                size: 80,
                color: AppColors.primaryGreen.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 20),
              const Text(
                '${AppConstants.comingSoon} - Plant Library',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 10),
              const Text(
                'Browse plant species and deficiency info',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
