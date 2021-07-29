import 'package:jellyflut/models/category.dart';
import '../globals.dart';
import 'dio.dart';

Future<Category> getShowSeasonEpisode(String parentId, String seasonId) async {
  var queryParams = <String, dynamic>{};
  queryParams['seasonId'] = seasonId;
  queryParams['userId'] = userJellyfin!.id;
  queryParams['Fields'] =
      'ItemCounts,PrimaryImageAspectRatio,BasicSyncInfo,CanDelete,MediaSourceCount,Overview,DateCreated,MediaStreams';

  var url = '${server.url}/Shows/$parentId/Episodes';

  try {
    var response = await dio.get(url, queryParameters: queryParams);
    return Category.fromMap(response.data);
  } catch (e) {
    print(e);
    rethrow;
  }
}
