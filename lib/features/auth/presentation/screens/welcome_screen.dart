import 'package:flutter/material.dart';

import 'package:webant_gallery/core/presentation/theme/app_theme.dart';
import 'package:webant_gallery/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:webant_gallery/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:webant_gallery/gen/assets.gen.dart';
import 'package:webant_gallery/core/presentation/widgets/custom_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Assets.icons.logo.svg(width: 135, height: 135),
                const SizedBox(height: 36),
                const Text(
                  'Welcome to Gallery!',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 80),
                CustomButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const SignUpScreen()),
                  ),
                  text: 'Create an account',
                  filled: true,
                ),
                const SizedBox(height: 20),
                CustomButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const SignInScreen()),
                  ),
                  text: 'I already have an account',
                ),                
              ],
            ),
          ),
        ),
      ),
    );
  }
}
