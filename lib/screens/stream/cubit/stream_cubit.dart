import 'dart:async';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:jellyflut_models/jellyflut_models.dart';
import 'package:streaming_api/streaming_api.dart';
import 'package:streaming_repository/streaming_repository.dart';

part 'stream_state.dart';

class StreamCubit extends Cubit<StreamState> {
  StreamCubit({required StreamingRepository streamingRepository, Item? item, String? url})
      : assert(item != null || url != null, 'At least one param must be given'),
        _streamingRepository = streamingRepository,
        super(StreamState(
          parentItem: item,
          url: url,
          controlsVisibilityTimer: Timer(Duration.zero, () {}),
        ));

  final StreamingRepository _streamingRepository;
  final Duration _fastForwardStep = const Duration(seconds: 10);

  Future<void> init() async {
    emit(state.copyWith(status: StreamStatus.initial));
    late final CommonStream commonStream;
    late final StreamItem streamItem;

    try {
      if (state.parentItem != null) {
        print('parent item is not null');
        final streamController = await _generateController(item: state.parentItem);
        commonStream = streamController.controller;
        streamItem = streamController.streamItem;
      } else if (state.url != null) {
        commonStream = await _streamingRepository.createController(uri: Uri.parse(state.url!));
        streamItem = StreamItem(url: state.url!, item: Item(id: '0', type: ItemType.Video));
      }

      await commonStream.initialize();
      emit(state.copyWith(
          controller: commonStream,
          streamItem: streamItem,
          hasPip: await commonStream.hasPip(),
          status: StreamStatus.loading));
      emit(state.copyWith(status: StreamStatus.success));
      await play();
      emit(state.copyWith(audioTracks: await _getAudioTracks()));
    } on StreamingException catch (e, _) {
      emit(state.copyWith(failureMessage: e.message, status: StreamStatus.failure));
    } on DioError catch (e, _) {
      emit(state.copyWith(failureMessage: e.message, status: StreamStatus.failure));
    } catch (e, s) {
      print(s);
      emit(state.copyWith(failureMessage: (e as dynamic).toString(), status: StreamStatus.failure));
    }
  }

  Future<void> play() async {
    if (state.controller == null) return;
    await state.controller?.play();
    return emit(state.copyWith(
        playing: state.controller?.isPlaying() ?? false, fullscreen: await state.controller?.isFullscreen()));
  }

  void togglePlay() async {
    if (state.controller == null) return;
    if (state.controller!.isPlaying()) {
      await state.controller?.pause();
      emit(state.copyWith(playing: state.controller!.isPlaying()));
    } else {
      await state.controller?.play();
      emit(state.copyWith(playing: state.controller!.isPlaying()));
    }
  }

  void disposePlayer() {
    if (state.streamItem.playbackInfos?.playSessionId != null) {
      _streamingRepository.deleteActiveEncoding(playSessionId: state.streamItem.playbackInfos!.playSessionId!);
    }
    state.controlsVisibilityTimer.cancel();
    state.controller?.dispose();
  }

  void toggleFullscreen() async {
    if (state.controller == null) return;
    state.controller!.toggleFullscreen();
    emit(state.copyWith(fullscreen: await state.controller?.isFullscreen()));
  }

  void toggleControl() {
    if (state.visible) {
      state.controlsVisibilityTimer.cancel();
      emit(state.copyWith(visible: false));
    } else {
      state.controlsVisibilityTimer.cancel();
      final newTimer = Timer(Duration(seconds: 5), () => emit(state.copyWith(visible: false)));
      emit(state.copyWith(visible: true, controlsVisibilityTimer: newTimer));
    }
  }

  void autoHideControlTimer() {
    state.controlsVisibilityTimer.cancel();
    final newTimer = Timer(Duration(seconds: 5), () => emit(state.copyWith(visible: false)));
    emit(state.copyWith(visible: true, controlsVisibilityTimer: newTimer));
  }

  void setAudioStreamIndex(AudioTrack audioTrack) async {
    if (audioTrack.mediaType == MediaType.remote) {
      final streamParamters = StreamParameters(
          startAt: state.controller?.getCurrentPosition(), audioStreamIndex: audioTrack.jellyfinSubtitleIndex);
      await changeDataSource(
        item: state.streamItem.item,
        streamParameters: streamParamters,
      );
    } else if (audioTrack.mediaType == MediaType.local) {
      await state.controller?.setAudioTrack(audioTrack);
    }
    emit(state.copyWith(selectedAudioTrack: audioTrack));
  }

  void goForward() {
    final currentDuration = state.controller?.getCurrentPosition();
    final seekToDuration = (currentDuration ?? _fastForwardStep) + _fastForwardStep;
    state.controller?.seekTo(seekToDuration);
  }

  void goBackward() {
    final currentDuration = state.controller?.getCurrentPosition();
    final seekToDuration = (currentDuration ?? _fastForwardStep) - _fastForwardStep;
    state.controller?.seekTo(seekToDuration);
  }

  Future<void> changeDataSource(
      {required Item item, StreamParameters streamParameters = StreamParameters.empty}) async {
    emit(state.copyWith(status: StreamStatus.loading));
    final playSessionId = state.streamItem.playbackInfos?.playSessionId;
    if (playSessionId == null) return;
    await state.controller?.pause();
    await state.controller?.dispose();
    try {
      await _streamingRepository.deleteActiveEncoding(playSessionId: playSessionId);
    } catch (e, s) {
      print(e);
      print(s);
    }

    try {
      final streamController = await _generateController(item: item);
      emit(state.copyWith(
          controller: streamController.controller,
          streamItem: streamController.streamItem,
          status: StreamStatus.success));
    } on StreamingException catch (e, _) {
      emit(state.copyWith(failureMessage: e.message, status: StreamStatus.failure));
    } on DioError catch (e, _) {
      emit(state.copyWith(failureMessage: e.message, status: StreamStatus.failure));
    } catch (e, s) {
      print(s);
      emit(state.copyWith(
          failureMessage: (e as dynamic)?.message.toString() ?? e.toString(), status: StreamStatus.failure));
    }
  }

  Future<List<AudioTrack>> _getAudioTracks() async {
    final audioTracks = <AudioTrack>[];
    final localAudioTracks = await state.controller?.getAudioTracks() ?? [];
    audioTracks.addAll(localAudioTracks);
    // final lastIndex = audioTracks.map((e) => e.index).fold(0, max);
    // audioTracks.addAll(_getRemoteAudiotracks(lastIndex + 1));
    audioTracks.addAll([]);

    return audioTracks;
  }

  List<AudioTrack> _getRemoteAudiotracks() {
    final audioTracks = <AudioTrack>[];

    // For now we can change remote audio source if already transcoding
    // if (!(state.streamItem.playbackInfos?.isTranscoding() ?? false)) {
    //   return audioTracks;
    // }

    // final remoteAudioTracksMediaStream =
    //     state.streamItem.item.mediaStreams.where((e) => e.type == MediaStreamType.Audio).toList();

    // if (remoteAudioTracksMediaStream.isNotEmpty) {
    //   for (var i = 0; i < remoteAudioTracksMediaStream.length; i++) {
    //     final at = remoteAudioTracksMediaStream[i];
    //     final remoteAudioTrack = AudioTrack(
    //         index: audioTracks.length + startIndex,
    //         name: at.displayTitle ?? '',
    //         mediaType: MediaType.remote,
    //         jellyfinSubtitleIndex: at.index);
    //     audioTracks.add(remoteAudioTrack);
    //   }
    // }
    return audioTracks;
  }

  /// Method to fetch local (from video player controller) and remote
  /// subtitles
  Future<List<Subtitle>> getSubtitles() async {
    final subtitles = <Subtitle>[];
    final localSubtitles = await state.controller?.getSubtitles() ?? [];
    subtitles.addAll(localSubtitles);
    // final lastIndex = subtitles.map((e) => e.index).fold(0, max);
    // subtitles.addAll(_getRemoteSubtitles(lastIndex + 1).toString()));
    subtitles.addAll([]);

    return subtitles;
  }

  /// Method to fetch remote subtitles
  /// Can set [startIndex] a number to count from, useful if need to mix
  /// muliple subitles sources
  List<Subtitle> _getRemoteSubtitles() {
    final subtitles = <Subtitle>[];
    // final remoteSubtitlesMediaStream =
    //     state.streamItem.item.mediaStreams.where((e) => e.type == MediaStreamType.Subtitle).toList();

    // if (remoteSubtitlesMediaStream.isNotEmpty) {
    //   for (var i = 0; i < remoteSubtitlesMediaStream.length; i++) {
    //     final ls = remoteSubtitlesMediaStream[i];
    //     final remoteSubtitle = Subtitle(
    //         index: subtitles.length + startIndex,
    //         name: ls.displayTitle ?? '',
    //         mediaType: MediaType.remote,
    //         jellyfinSubtitleIndex: ls.index);
    //     subtitles.add(remoteSubtitle);
    //   }
    // }
    return subtitles;
  }

  /// Given an [item] generate the appropriate controller
  /// - 1st check if is downloaded and availbale
  Future<_StreamController> _generateController({Item? item}) async {
    final finalItem = item ?? state.parentItem;
    assert(finalItem != null);

    final streamItem = await _streamingRepository.getStreamItem(item: finalItem!);
    final controller = await _streamingRepository.createController(
      uri: Uri.parse(streamItem.url),
      startAtPosition: Duration(microseconds: ((streamItem.item.userData?.playbackPositionTicks ?? 0) / 10).round()),
    );

    return _StreamController(controller: controller, streamItem: streamItem);
  }

  /// Set current subtitle index to use
  void setSubtitleStreamIndex(Subtitle subtitleTrack) {
    if (subtitleTrack.mediaType == MediaType.local) {
      state.controller?.setSubtitle(subtitleTrack);
      emit(state.copyWith(selectedSubtitleTrack: subtitleTrack));
    }
  }
}

class _StreamController {
  final CommonStream<dynamic> controller;
  final StreamItem streamItem;

  const _StreamController({required this.controller, required this.streamItem});
}
