import 'package:flutter/material.dart';
import 'package:webant_gallery/core/presentation/theme/app_theme.dart';

class GradientLogo extends StatelessWidget {
  final double size;

  const GradientLogo({super.key, this.size = 135});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [AppColors.gradientStart, AppColors.gradientEnd],
      ).createShader(bounds),
      child: Icon(
        Icons.camera_alt_rounded,
        size: size,
        color: Colors.white,
      ),
    );
  }
}
