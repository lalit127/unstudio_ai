import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
import 'package:unstudio_ai/models/caption_model.dart';
import 'package:unstudio_ai/models/common_model.dart';
import 'package:unstudio_ai/utils/constants.dart';
import 'package:unstudio_ai/utils/dio_util.dart';

part 'api_services.g.dart';

@RestApi()
abstract class ApiService {
  factory ApiService(Dio dio, {String? baseUrl}) = _ApiService;

  static ApiService create({String? baseUrl}) {
    final dio = DioUtil().getDio(useAccessToken: true);

    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: kDebugMode,
        requestBody: kDebugMode,
        responseBody: kDebugMode,
        responseHeader: kDebugMode,
        compact: kDebugMode,
      ),
    );

    return ApiService(dio, baseUrl: baseUrl ?? Constants.baseUrl);
  }

  static ApiService createHuggingFace(String hfApiKey) {
    final dio = DioUtil().getDio(useAccessToken: false);

    dio.options.headers = {
      "Authorization": "Bearer $hfApiKey",
      "Content-Type": "application/octet-stream",
    };

    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: kDebugMode,
        requestBody: kDebugMode,
        responseBody: kDebugMode,
        responseHeader: kDebugMode,
        compact: kDebugMode,
      ),
    );

    return ApiService(
      dio,
      baseUrl: 'https://api-inference.huggingface.co/models/',
    );
  }

  @POST("Salesforce/blip-image-captioning-base")
  Future<CaptionModelResponse> captionWithHuggingFace(
    @Body() Uint8List imageBytes,
  );
}
