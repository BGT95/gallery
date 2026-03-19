import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:webant_gallery/core/di/injection_container.dart' as di;
import 'package:webant_gallery/core/infrastructure/local/hive_service.dart';
import 'package:webant_gallery/core/presentation/theme/app_theme.dart';
import 'package:webant_gallery/core/utils/logger.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    FlutterError.onError = (details) {
      AppLogger.error('Flutter error', error: details.exception, stackTrace: details.stack);
    };

    try {
      await HiveService.init();
      await di.init();
      runApp(const WebAntGalleryApp());
    } catch (e, stack) {
      AppLogger.error('Initialization failed', error: e, stackTrace: stack);
      runApp(const _InitErrorApp());
    }
  }, (error, stack) {
    AppLogger.error('Unhandled error', error: error, stackTrace: stack);
  });
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

class _InitErrorApp extends StatelessWidget {
  const _InitErrorApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 64, color: AppColors.error),
                const SizedBox(height: 16),
                const Text(
                  'Не удалось запустить приложение',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Text(
                  'Попробуйте перезапустить или переустановить приложение',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: AppColors.textPrimary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}