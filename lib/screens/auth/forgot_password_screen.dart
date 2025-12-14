import 'package:flutter/material.dart';
import 'package:fyllens/core/theme/app_colors.dart';

/// Forgot password page
/// Password reset screen
class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Forgot Password'),
        backgroundColor: AppColors.primaryGreen,
      ),
      body: SafeArea(
        child: Center(
          child: Builder(
            builder: (context) => Text(
              'Coming Soon - Password Reset',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
        ),
      ),
    );
  }
}
