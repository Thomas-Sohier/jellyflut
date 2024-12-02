import 'package:music_player_api/music_player_api.dart';
import 'package:streaming_repository/streaming_repository.dart';

Future<void> init() async {
  await StreamingRepository.init();
  await MusicPlayerApi.init();
  return Future.value(null);
}
