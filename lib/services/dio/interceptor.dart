// or new Dio with a BaseOptions instance.
// ignore_for_file: unused_import

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:jellyflut/globals.dart';

import 'auth_header.dart';

BaseOptions options = BaseOptions(
    connectTimeout: 30000,
    receiveTimeout: 30000,
    contentType: 'application/json');

Dio dio = Dio(options)
  ..interceptors.addAll(
    [
      InterceptorsWrapper(onRequest: (RequestOptions requestOptions,
          RequestInterceptorHandler handler) async {
        dio.interceptors.requestLock.lock();
        var token = apiKey;
        var authEmby = await authHeader();
        if (token != null) {
          requestOptions.queryParameters;
          requestOptions.queryParameters['api_key'] = token;
        }
        requestOptions.headers['X-Emby-Authorization'] = authEmby;
        handler.next(requestOptions);
        dio.interceptors.requestLock.unlock();
      })
    ],
  );
