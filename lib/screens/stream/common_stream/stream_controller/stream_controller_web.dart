import 'package:jellyflut/screens/stream/common_stream/common_stream.dart';
import 'package:jellyflut/screens/stream/common_stream/common_stream_video_player.dart';
import 'package:jellyflut/screens/stream/model/subtitle.dart';
import 'package:video_player/video_player.dart';

CommonStream parse(dynamic controller) {
  if (controller is VideoPlayerController) {
    return _parseVideoPlayerController(videoPlayerController: controller);
  }
  throw UnsupportedError(
      'No suitable player controller implementation was found.');
}

CommonStream _parseVideoPlayerController(
    {required VideoPlayerController videoPlayerController}) {
  final commonStreamVideoPlayer =
      CommonStreamVideoPlayer(videoPlayerController: videoPlayerController);
  return CommonStream(
      pause: videoPlayerController.pause,
      play: videoPlayerController.play,
      isPlaying: () => videoPlayerController.value.isPlaying,
      seekTo: videoPlayerController.seekTo,
      duration: () => videoPlayerController.value.duration,
      bufferingDuration: commonStreamVideoPlayer.getBufferingDurationVLC,
      currentPosition: () => videoPlayerController.value.position,
      isInit: () => videoPlayerController.value.isInitialized,
      hasPip: Future.value(false),
      pip: () => throw ('Not supported on VLC player'),
      getSubtitles: commonStreamVideoPlayer.getSubtitles,
      setSubtitle: (Subtitle subtitle) =>
          commonStreamVideoPlayer.setSpuTrack(subtitle),
      disableSubtitles: () => {},
      getAudioTracks: commonStreamVideoPlayer.getAudioTracks,
      setAudioTrack: (audioTrack) =>
          commonStreamVideoPlayer.setAudioTrack(audioTrack),
      positionStream: commonStreamVideoPlayer.positionStream(),
      durationStream: commonStreamVideoPlayer.durationStream(),
      isPlayingStream: commonStreamVideoPlayer.playingStateStream(),
      enterFullscreen: () => {},
      exitFullscreen: () => {},
      toggleFullscreen: () => {},
      dispose: commonStreamVideoPlayer.stopPlayer,
      controller: videoPlayerController);
}
