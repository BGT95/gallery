import 'package:flutter/material.dart';
import 'package:webant_gallery/core/di/injection_container.dart' as di;
import 'package:webant_gallery/core/infrastructure/local/hive_service.dart';
import 'package:webant_gallery/core/presentation/theme/app_theme.dart';
import 'package:webant_gallery/features/auth/presentation/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();
  await di.init();
  runApp(const WebAntGalleryApp());
}

class WebAntGalleryApp extends StatelessWidget {
  const WebAntGalleryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WebAnt Gallery',
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
