import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:webant_gallery/core/presentation/theme/app_theme.dart';

class AuthAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AuthAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.surface,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_outlined,
          size: 24,
          color: AppColors.searchPlaceholder,
        ),
        onPressed: () => context.pop(),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(color: AppColors.disabledText, height: 1.0),
      ),
    );
  }
}
