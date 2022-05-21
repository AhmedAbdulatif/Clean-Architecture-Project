import 'package:clean_arc_app/app/app_prefs.dart';
import 'package:clean_arc_app/app/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

const String APPLICATION_JSON = "application/json";
const String CONTENT_TYPE = "content-type";
const String ACCEPT = "accept";
const String AUTHORIZATION = "authorization";
const String DEFAULT_LANGUAGE = "language";

class DioFactory {
  final AppPrefrences _appPrefrences;
  DioFactory(this._appPrefrences);

  Future<Dio> getDio() async {
    Dio dio = Dio();
    String language = await _appPrefrences.getAppLanguage();
    Map<String, String> _headers = {
      CONTENT_TYPE: APPLICATION_JSON,
      ACCEPT: APPLICATION_JSON,
      AUTHORIZATION: Constants.token,
      DEFAULT_LANGUAGE: language // todo get language from app prefs
    };
    dio.options = BaseOptions(
      baseUrl: Constants.baseUrl,
      headers: _headers,
      sendTimeout: Constants.apiTimeOut,
      receiveTimeout: Constants.apiTimeOut,
    );
    if (!kReleaseMode) {
      dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
      ));
    }

    return dio;
  }
}
