import 'package:flutter/material.dart';
import 'package:webant_gallery/core/presentation/theme/app_theme.dart';
import 'package:webant_gallery/gen/assets.gen.dart';

class AppErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const AppErrorWidget({super.key, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onRetry,
      behavior: HitTestBehavior.opaque,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 74,
              height: 78,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Assets.icons.logoEr.svg(
                    width: 78,
                  ),
                  Transform.rotate(
                    angle: 0.785,
                    child: Container(
                      width: 2,
                      height: 50,
                      color: AppColors.searchBackground,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Sorry!',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'There is no pictures.\nPlease come back later.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                  height: 1.33,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
