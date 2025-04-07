import 'package:dio/dio.dart';

abstract class ParseErrorLogger {
  void logError(
    Object error,
    StackTrace stackTrace,
    RequestOptions requestOptions,
  );
}
