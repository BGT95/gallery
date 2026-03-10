import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:webant_gallery/core/di/injection_container.dart' as di;
import 'package:webant_gallery/core/infrastructure/local/hive_service.dart';
import 'package:webant_gallery/core/presentation/theme/app_theme.dart';

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
    final router = GetIt.I<GoRouter>();
    return MaterialApp.router(
      title: 'WebAnt Gallery',
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
