import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:webant_gallery/features/auth/infrastructure/repos/token_manager.dart';
import 'package:webant_gallery/features/auth/presentation/screens/welcome_screen.dart';
import 'package:webant_gallery/features/gallery/presentation/screens/home/home_page.dart';
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
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final tokenManager = GetIt.I<TokenManager>();
    final destination = tokenManager.isAuthenticated
        ? const HomePage()
        : const WelcomeScreen();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => destination),
    );
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
