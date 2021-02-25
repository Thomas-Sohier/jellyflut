// or new Dio with a BaseOptions instance.
import 'package:dio/dio.dart';

import '../globals.dart';
import 'interceptor.dart';

BaseOptions options = BaseOptions(
    connectTimeout: 30000,
    receiveTimeout: 30000,
    contentType: 'application/json');

Dio dio = Dio(options)
  ..interceptors.addAll(
    [
      InterceptorsWrapper(onRequest: (RequestOptions requestOptions) async {
        dio.interceptors.requestLock.lock();
        var token = apiKey;
        var authEmby = await authHeader();
        if (token != null) {
          requestOptions.queryParameters ??= <String, dynamic>{};
          requestOptions.queryParameters['api_key'] = token;
        }
        requestOptions.headers['X-Emby-Authorization'] = authEmby;
        dio.interceptors.requestLock.unlock();
        return requestOptions;
      }),
      // other interceptor
    ],
  );
