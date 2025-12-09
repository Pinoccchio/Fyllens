import 'package:flutter/material.dart';
import 'package:fyllens/core/theme/app_colors.dart';

/// Edit profile page
/// Edit user profile information
class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: AppColors.primaryGreen,
      ),
      body: const SafeArea(
        child: Center(
          child: Text(
            'Coming Soon - Edit Profile Form',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
