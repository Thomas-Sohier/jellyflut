import 'dart:developer';

import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/iptv/channels_request_body.dart';
import 'package:jellyflut/models/jellyfin/category.dart';
import 'package:jellyflut/services/dio/interceptor.dart';
import 'package:jellyflut/services/item/parser.dart';

import '../../models/iptv/programs_request_body.dart';

class IptvService {
  static Future<Category> getChannels({ChannelsRequestBody? body}) async {
    final queryParams = body == null ? <String, dynamic>{} : body.toMap()
      ..removeWhere((key, value) => value == null);

    final url = '${server.url}/LiveTv/Channels';

    try {
      final response = await dio.get<Map<String, dynamic>>(url,
          queryParameters: queryParams);
      return parseCategory(response.data!);
    } catch (e, stacktrace) {
      log(e.toString(), stackTrace: stacktrace, level: 5);
      rethrow;
    }
  }

  static Future<Category> getPrograms({ProgramsRequestBody? body}) async {
    final url = '${server.url}/LiveTv/Programs';

    try {
      final response =
          await dio.post<Map<String, dynamic>>(url, data: body?.toJson());
      return parseCategory(response.data!);
    } catch (e, stacktrace) {
      log(e.toString(), stackTrace: stacktrace, level: 5);
      rethrow;
    }
  }

  static Future<Category> getGuide(
      {int startIndex = 0,
      String fields = 'PrimaryImageAspectRatio',
      int limit = 100}) async {
    final queryParams = <String, dynamic>{};
    queryParams['StartIndex'] = startIndex;
    queryParams['Fields'] = fields;
    queryParams['Limit'] = limit;
    queryParams['UserId'] = userJellyfin!.id;

    final url = '${server.url}/LiveTv/GuideInfo';

    try {
      final response = await dio.get<Map<String, dynamic>>(url,
          queryParameters: queryParams);
      return parseCategory(response.data!);
    } catch (e, stacktrace) {
      log(e.toString(), stackTrace: stacktrace, level: 5);
      rethrow;
    }
  }
}
