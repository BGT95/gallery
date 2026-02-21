import 'package:flutter/material.dart';
import 'package:webant_gallery/core/presentation/theme/app_theme.dart';

class GradientTitle extends StatelessWidget {
  final String text;

  const GradientTitle({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          text,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 100,
          height: 2,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.gradientStart, AppColors.gradientEnd],
            ),
          ),
        ),
      ],
    );
  }
}
