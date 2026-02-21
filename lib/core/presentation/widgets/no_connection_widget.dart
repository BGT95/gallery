import 'package:flutter/material.dart';
import 'package:webant_gallery/core/presentation/theme/app_theme.dart';

class NoConnectionWidget extends StatelessWidget {
  final VoidCallback? onRetry;

  const NoConnectionWidget({super.key, this.onRetry});

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
                  Icon(
                    Icons.image_outlined,
                    size: 74,
                    color: AppColors.searchBackground,
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
            const Text(
              'No internet connection.\nPlease come back later.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
                height: 1.33,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
