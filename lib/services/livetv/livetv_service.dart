import 'dart:developer';

import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/jellyfin/category.dart';
import 'package:jellyflut/services/dio/interceptor.dart';
import 'package:jellyflut/services/item/parser.dart';

class IptvService {
  static Future<Category> getPrograms(
      {int startIndex = 0,
      String fields = 'PrimaryImageAspectRatio',
      int limit = 100}) async {
    final queryParams = <String, dynamic>{};
    queryParams['StartIndex'] = startIndex;
    queryParams['Fields'] = fields;
    queryParams['Limit'] = limit;
    queryParams['UserId'] = userJellyfin!.id;

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
}
