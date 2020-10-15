import 'dart:io';

import 'package:dio/dio.dart';

Future<Response<dynamic>> downloadFile(String url, String path) async {
  return new Dio().download(url, path,
      options: Options(headers: {HttpHeaders.acceptEncodingHeader: "*"}));
}
