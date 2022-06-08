// import 'dart:async';

// import 'package:jellyflut/models/jellyfin/item.dart';
// import 'package:jellyflut/providers/streaming/streaming_provider.dart';
// import 'package:jellyflut/screens/stream/model/audio_track.dart';
// import 'package:jellyflut/screens/stream/model/subtitle.dart';
// import 'package:jellyflut/services/streaming/streaming_service.dart';
// import 'package:libmpv/libmpv.dart';
// import 'package:rxdart/rxdart.dart';
// import 'package:window_manager/window_manager.dart';

// import 'common_stream.dart';

// class CommonStreamMPV {
//   static final streamingProvider = StreamingProvider();
//   final Player mpvPlayer;

//   const CommonStreamMPV({required this.mpvPlayer});

//   Duration getBufferingDurationVLC() {
//     // final durationCurrentFile = mpvPlayerController.value.duration;
//     // final totalMilliseconds = durationCurrentFile.inMilliseconds;
//     // final currentBufferedMilliseconds =
//     //     totalMilliseconds / mpvPlayerController.value.bufferPercent;
//     // return Duration(
//     //     milliseconds: currentBufferedMilliseconds.isNaN ||
//     //             currentBufferedMilliseconds.isInfinite
//     //         ? 0
//     //         : currentBufferedMilliseconds.toInt());
//     return Duration(seconds: 0);
//   }

//   static Future<Player> setupData({required Item item}) async {
//     final streamingProvider = StreamingProvider();
//     final streamURL = await item.getItemURL(directPlay: true);

//     await MPV.initialize();
//     final player = Player();

//     await player.open([
//       Media(streamURL),
//     ]);

//     player.volume = 50.0;
//     player.rate = 1.0;

//     // create timer to save progress
//     final timer = _startProgressTimer(item, player);
//     streamingProvider.timer?.cancel();
//     streamingProvider.setTimer(timer);

//     // // create common stream controller
//     final commonStream = CommonStream.parseMpvController(mpvPlayer: player);

//     streamingProvider.setCommonStream(commonStream);
//     return player;
//   }

//   static Future<Player> setupDataFromUrl({required String url}) async {
//     await MPV.initialize();
//     final player = Player();

//     await player.open([
//       Media(url),
//     ]);

//     player.volume = 50.0;
//     player.rate = 1.0;

//     // create common stream controller
//     final commonStream = CommonStream.parseMpvController(mpvPlayer: player);

//     StreamingProvider().setCommonStream(commonStream);
//     return Future.value(player);
//   }

//   void enterFullscreen() async {
//     final windowInstance = WindowManager.instance;
//     await windowInstance.setFullScreen(true);
//   }

//   void exitFullscreen() async {
//     final windowInstance = WindowManager.instance;
//     await windowInstance.setFullScreen(false);
//   }

//   void toggleFullscreen() async {
//     final windowInstance = WindowManager.instance;
//     await windowInstance.isFullScreen().then(
//         (bool isFullscreen) => windowInstance.setFullScreen(!isFullscreen));
//   }

//   static Timer _startProgressTimer(Item item, Player mpvPlayer) {
//     return Timer.periodic(
//         Duration(seconds: 15),
//         (Timer t) => StreamingService.streamingProgress(item,
//             canSeek: true,
//             isMuted: mpvPlayer.state.volume > 0 ? true : false,
//             isPaused: !mpvPlayer.state.isPlaying,
//             positionTicks: mpvPlayer.state.position.inMicroseconds,
//             volumeLevel: mpvPlayer.state.volume.round(),
//             subtitlesIndex: 0));
//   }

//   Future<List<Subtitle>> getSubtitles() async {
//     // ignore: omit_local_variable_types
//     final List<Subtitle> parsedSubtitiles = [];
//     // final subtitles = await mpvPlayer.getSpuTracks();
//     // for (var i = 0; i < subtitles.length; i++) {
//     //   final subtitleKey = subtitles.keys.elementAt(i);
//     //   parsedSubtitiles.add(Subtitle(
//     //       index: i,
//     //       jellyfinSubtitleIndex: subtitleKey,
//     //       name: subtitles[subtitleKey]!));
//     // }
//     return parsedSubtitiles;
//   }

//   void setSubtitle(
//     Subtitle subtitle,
//   ) {
//     // mpvPlayer.setSpuTrack(subtitle.jellyfinSubtitleIndex!);
//   }

//   Future<List<AudioTrack>> getAudioTracks() async {
//     // ignore: omit_local_variable_types
//     final List<AudioTrack> parsedAudioTracks = [];
//     // final audioTracks = await mpvPlayer.getAudioTracks();
//     // for (var i = 0; i < audioTracks.length; i++) {
//     //   final audioTrackKey = audioTracks.keys.elementAt(i);
//     //   parsedAudioTracks.add(AudioTrack(
//     //       index: i,
//     //       jellyfinSubtitleIndex: audioTrackKey,
//     //       name: audioTracks[audioTrackKey]!));
//     // }
//     return parsedAudioTracks;
//   }

//   void setAudioTrack(
//     AudioTrack trackIndex,
//   ) {
//     // mpvPlayer.state.(trackIndex.jellyfinSubtitleIndex!);
//   }

//   BehaviorSubject<Duration> positionStream() {
//     final streamController = BehaviorSubject<Duration>();
//     mpvPlayer.streams.position.doOnData((event) {
//       streamController.add(event);
//     });
//     return streamController;
//   }

//   BehaviorSubject<Duration> durationStream() {
//     final streamController = BehaviorSubject<Duration>();
//     mpvPlayer.streams.duration.doOnData((event) {
//       streamController.add(event);
//     });
//     return streamController;
//   }

//   BehaviorSubject<bool> playingStateStream() {
//     final streamController = BehaviorSubject<bool>();
//     mpvPlayer.streams.isPlaying.doOnData((event) {
//       streamController.add(event);
//     });
//     return streamController;
//   }

//   void stopPlayer() {
//     StreamingService.deleteActiveEncoding();
//     mpvPlayer.dispose();
//   }
// }
