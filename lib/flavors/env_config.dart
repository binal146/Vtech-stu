import 'dart:ui';

import 'package:logger/logger.dart';
import '../app/core/utils/colour.dart';
import '../app/core/values/app_values.dart';
enum Endpoints { items, details }
class EnvConfig {
  Map<Endpoints, String>? apiEndpoint;
  final String appName;
  final String clientId;
  final bool shouldCollectCrashLog;
  final bool isProduction;
  late final Logger logger;

  static const Color defaultColor = Color(0xffF26222);

  EnvConfig({
    required this.appName,
    this.shouldCollectCrashLog = false,
    this.isProduction = false,
    this.clientId = "",
  }) {
    logger = Logger(
      printer: PrettyPrinter(
          methodCount: AppValues.loggerMethodCount,
          // number of method calls to be displayed
          errorMethodCount: AppValues.loggerErrorMethodCount,
          // number of method calls if stacktrace is provided
          lineLength: AppValues.loggerLineLength,
          // width of the output
          colors: true,
          // Colorful log messages
          printEmojis: true,
          // Print an emoji for each log message
          printTime: false, // Should each log print contain a timestamp
          ),
    );
  }
}
