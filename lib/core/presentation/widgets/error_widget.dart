import 'package:flutter/material.dart';
import 'package:webant_gallery/core/presentation/theme/app_theme.dart';
import 'package:webant_gallery/core/presentation/widgets/empty_state_widget.dart';
import 'package:webant_gallery/gen/assets.gen.dart';

class AppErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const AppErrorWidget({super.key, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Stack(
        alignment: Alignment.center,
        children: [
          Assets.icons.logoEr.svg(width: 78),
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
      message: message,
      onRetry: onRetry,
    );
  }
}
