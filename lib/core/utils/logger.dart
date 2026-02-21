import 'dart:developer' as developer;

class AppLogger {
  static const String _defaultName = 'WebAntGallery';

  static void log(String message, {String? name}) {
    developer.log(message, name: name ?? _defaultName);
  }

  static void info(String message, {String? name}) {
    developer.log('ℹ️ $message', name: name ?? _defaultName);
  }

  static void warning(String message, {String? name}) {
    developer.log('⚠️ $message', name: name ?? _defaultName);
  }

  static void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? name,
  }) {
    developer.log(
      '❌ $message',
      name: name ?? _defaultName,
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void network(String message) {
    developer.log(message, name: 'Network');
  }

  static void auth(String message) {
    developer.log(message, name: 'Auth');
  }
}
