import 'package:logger/logger.dart';

class LoggingService {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
    ),
  );

  static void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  static void info(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  static void warning(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  static void fatal(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.f(message, error: error, stackTrace: stackTrace);
  }

  // Log user actions for audit trail
  static void logUserAction(String action, {String? userId, Map<String, dynamic>? details}) {
    _logger.i(
      'User Action: $action',
      error: {
        'userId': userId,
        'details': details,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  // Log data access for security audit
  static void logDataAccess(String resource, {String? userId, String? action}) {
    _logger.i(
      'Data Access: $action on $resource',
      error: {
        'userId': userId,
        'resource': resource,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }
}
