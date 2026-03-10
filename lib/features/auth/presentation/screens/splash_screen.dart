import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:webant_gallery/core/presentation/router/app_router.dart';
import 'package:webant_gallery/gen/assets.gen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateAfterDelay();
  }

  Future<void> _navigateAfterDelay() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    context.go(AppRoutes.root);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Assets.icons.logo.svg(),
      ),
    );
  }
}
