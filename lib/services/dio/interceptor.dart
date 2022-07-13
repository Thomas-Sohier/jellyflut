// or new Dio with a BaseOptions instance.
// ignore_for_file: unused_import

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:jellyflut/globals.dart';
import 'package:universal_io/io.dart';

import 'auth_header.dart';

final dio = DioHelper.generateDioClient();

class DioHelper {
  static BaseOptions _generateOptions(String baseUrl, String defaultContentType, DioExtra? extra) => BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: 15000,
      receiveTimeout: 15000,
      contentType: defaultContentType,
      extra: extra?.toJson());

  static Dio generateDioClient(
          {String baseUrl = '', String defaultContentType = 'application/json', DioExtra? extra}) =>
      Dio(_generateOptions(baseUrl, defaultContentType, extra))
        ..interceptors.addAll(
          [
            QueuedInterceptorsWrapper(
                onRequest: (RequestOptions requestOptions, RequestInterceptorHandler handler) async {
              var token = apiKey;
              var authEmby = await authHeader();
              if (token != null) {
                requestOptions.queryParameters;
                requestOptions.queryParameters['api_key'] = token;
              }
              requestOptions.headers['X-Emby-Authorization'] = authEmby;
              handler.next(requestOptions);
            })
          ],
        );
}

class DioExtra {
  final String? jellyfinUserId;

  const DioExtra({this.jellyfinUserId});

  Map<String, dynamic> toJson() {
    final val = <String, dynamic>{};

    void writeNotNull(String key, dynamic value) {
      if (value != null) {
        val[key] = value;
      }
    }

    writeNotNull('jellyfinUserId', jellyfinUserId);
    return val;
  }

  DioExtra fromJson(Map<String, dynamic> json) => DioExtra(jellyfinUserId: json['jellyfinUserId'] as String);
}
