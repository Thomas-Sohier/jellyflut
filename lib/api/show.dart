import 'package:dio/dio.dart';
import 'package:jellyflut/models/category.dart';
import '../globals.dart';
import 'dio.dart';

Future<Category> getShowSeasonEpisode(String parentId, String seasonId) async {
  var queryParams = <String, dynamic>{};
  queryParams['seasonId'] = seasonId;
  queryParams['userId'] = userJellyfin.id;
  queryParams['Fields'] =
      'ItemCounts,PrimaryImageAspectRatio,BasicSyncInfo,CanDelete,MediaSourceCount,Overview,DateCreated,MediaStreams';

  var url = '${server.url}/Shows/$parentId/Episodes';

  Response response;
  var category = Category();
  try {
    response = await dio.get(url, queryParameters: queryParams);
    category = Category.fromMap(response.data);
  } catch (e) {
    print(e);
  }
  return category;
}
