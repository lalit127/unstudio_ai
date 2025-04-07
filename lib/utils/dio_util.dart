import 'package:dio/dio.dart';
import 'package:unstudio_ai/utils/app_preferences.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioUtil {
  final Dio _dioInstance = Dio(
    BaseOptions(
      connectTimeout: Duration(milliseconds: 50000),
      receiveTimeout: Duration(milliseconds: 50000),
    ),
  );

  Dio getDio({bool? useAccessToken, String? token}) {
    _dioInstance.interceptors.clear(); // Clear existing interceptors

    // Add PrettyDioLogger for logging
    _dioInstance.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        compact: false,
      ),
    );

    // Add authorization header if useAccessToken is true
    if (useAccessToken ?? false) {
      _dioInstance.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            // Corrected line: Access the static method using the class name
            final accessToken = await AppPreference.getStringFromSF(
              'access_token',
            );
            options.headers['Authorization'] = 'Bearer $accessToken';
            return handler.next(options);
          },
        ),
      );
    }

    // Set default content-type header
    _dioInstance.options.headers['Content-Type'] = 'application/json';
    return _dioInstance;
  }
}
