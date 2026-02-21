import 'package:hive_flutter/hive_flutter.dart';
import 'package:webant_gallery/core/utils/logger.dart';

class HiveService {
  static const String photoCacheBox = 'photo_cache';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox<String>(photoCacheBox);
    AppLogger.info('Hive initialized');
  }

  static Box<String> get photoCache => Hive.box<String>(photoCacheBox);

  static Future<void> clearAll() async {
    await photoCache.clear();
    AppLogger.info('Hive cache cleared');
  }
}
