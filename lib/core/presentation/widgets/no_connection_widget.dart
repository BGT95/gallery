import 'package:flutter/material.dart';
import 'package:webant_gallery/core/presentation/theme/app_theme.dart';
import 'package:webant_gallery/core/presentation/widgets/empty_state_widget.dart';

class NoConnectionWidget extends StatelessWidget {
  final VoidCallback? onRetry;

  const NoConnectionWidget({super.key, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Stack(
        alignment: Alignment.center,
        children: [
          Icon(Icons.image_outlined, size: 74, color: AppColors.searchBackground),
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
      message: 'Нет подключения к интернету.\nПопробуйте позже.',
      onRetry: onRetry,
    );
  }
}
