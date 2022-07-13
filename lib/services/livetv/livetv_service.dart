import 'dart:developer';

import 'package:flutter/foundation.dart' hide Category;
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/services/dio/dio_helper.dart';
import 'package:jellyflut_models/jellyflut_models.dart';

class IptvService {
  static Future<Category> getChannels({ChannelsRequestBody? body}) async {
    final queryParams = body == null ? <String, dynamic>{} : body.toMap()
      ..removeWhere((key, value) => value == null);

    final url = '${server.url}/LiveTv/Channels';

    try {
      final response = await dio.get<Map<String, dynamic>>(url, queryParameters: queryParams);
      return compute(Category.fromMap, response.data!);
    } catch (e, stacktrace) {
      log(e.toString(), stackTrace: stacktrace, level: 5);
      rethrow;
    }
  }

  static Future<Category> getPrograms({ProgramsRequestBody? body}) async {
    final url = '${server.url}/LiveTv/Programs';

    try {
      final response = await dio.post<Map<String, dynamic>>(url, data: body?.toJson());
      return compute(Category.fromMap, response.data!);
    } catch (e, stacktrace) {
      log(e.toString(), stackTrace: stacktrace, level: 5);
      rethrow;
    }
  }

  static Future<Category> getGuide(
      {int startIndex = 0, String fields = 'PrimaryImageAspectRatio', int limit = 100}) async {
    final queryParams = <String, dynamic>{};
    queryParams['StartIndex'] = startIndex;
    queryParams['Fields'] = fields;
    queryParams['Limit'] = limit;
    queryParams['UserId'] = userJellyfin!.id;

    final url = '${server.url}/LiveTv/GuideInfo';

    try {
      final response = await dio.get<Map<String, dynamic>>(url, queryParameters: queryParams);
      return compute(Category.fromMap, response.data!);
    } catch (e, stacktrace) {
      log(e.toString(), stackTrace: stacktrace, level: 5);
      rethrow;
    }
  }
}
