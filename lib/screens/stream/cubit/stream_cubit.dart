import 'dart:async';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Import ajouté
import 'package:jellyflut_models/jellyflut_models.dart';
import 'package:streaming_api/streaming_api.dart';
import 'package:streaming_repository/streaming_repository.dart';

part 'stream_state.dart';

class StreamCubit extends Cubit<StreamState> {
  final StreamingRepository _streamingRepository;
  final Duration _autoHideDuration = const Duration(seconds: 5);
  final Duration _fastForwardStep = const Duration(seconds: 10);
  late Timer _controlsVisibilityTimer;

  StreamCubit({required StreamingRepository streamingRepository, Item? item, String? url})
      : assert(item != null || url != null, 'At least one param must be given'),
        _streamingRepository = streamingRepository,
        super(StreamState(parentItem: item, url: url)) {
    _controlsVisibilityTimer = Timer(Duration.zero, () {});
  }

  void _startControlsAutoDismissTimer() {
    _controlsVisibilityTimer.cancel();
    _controlsVisibilityTimer = Timer(_autoHideDuration, () => emit(state.copyWith(visible: false)));
  }

  /// Initialise le lecteur vidéo et prépare le flux.
  ///
  /// Génère le contrôleur de flux (à partir d'un [Item] ou d'une [url]),
  /// initialise le lecteur, commence la lecture et charge les pistes audio.
  /// Émet [StreamStatus.success] en cas de réussite ou [StreamStatus.failure] en cas d'erreur.
  Future<void> init() async {
    emit(state.copyWith(status: StreamStatus.initial));
    late final CommonStream commonStream;
    late final StreamItem streamItem;

    try {
      if (state.parentItem != null) {
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
          audioTracks: await _getAudioTracks(),
          status: StreamStatus.success));

      await state.controller?.play();
    } on StreamingException catch (e) {
      emit(state.copyWith(failureMessage: e.message, status: StreamStatus.failure));
    } on DioError catch (e) {
      emit(state.copyWith(failureMessage: e.message, status: StreamStatus.failure));
    } catch (e, s) {
      debugPrint('Error during init: $s');
      emit(state.copyWith(failureMessage: e.toString(), status: StreamStatus.failure));
    }
  }

  /// Dispose des ressources du lecteur.
  ///
  /// Doit être appelée à la fermeture du widget (dans dispose).
  void disposePlayer() {
    if (state.streamItem.playbackInfos?.playSessionId != null) {
      _streamingRepository.deleteActiveEncoding(playSessionId: state.streamItem.playbackInfos!.playSessionId!);
    }
    _controlsVisibilityTimer.cancel();
    state.controller?.dispose();
  }

  /// Bascule l'état de lecture/pause du lecteur vidéo.
  ///
  /// Si le lecteur est en lecture, il sera mis en pause, et vice-versa.
  /// Émet le nouvel état de lecture dans le Cubit.
  void togglePlay() async {
    if (state.controller == null) return;
    if (state.controller!.isPlaying()) {
      await state.controller?.pause();
    } else {
      await state.controller?.play();
    }
    emit(state.copyWith(playing: state.controller!.isPlaying()));
  }

  /// Bascule la visibilité des contrôles du lecteur.
  ///
  /// Si les contrôles sont visibles, ils sont cachés. S'ils sont cachés,
  /// ils sont affichés et le minuteur d'auto-masquage est démarré.
  void toggleControlsVisibility() {
    if (state.visible) {
      _controlsVisibilityTimer.cancel();
      emit(state.copyWith(visible: false));
    } else {
      _startControlsAutoDismissTimer();
      emit(state.copyWith(visible: true));
    }
  }

  /// Affiche les contrôles et démarre le minuteur d'auto-masquage.
  void showControlsAndAutoDismiss() {
    emit(state.copyWith(visible: true));
    _startControlsAutoDismissTimer();
  }

  /// Définit la piste audio sélectionnée.
  ///
  /// Si la piste est 'remote', une nouvelle source de données est générée et chargée.
  /// Si la piste est 'local', le contrôleur du lecteur est mis à jour.
  ///
  /// [audioTrack] La piste audio à sélectionner.
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

  /// Avance la lecture de la durée prédéfinie ([_fastForwardStep]).
  ///
  /// Affiche les contrôles et déclenche l'auto-masquage.
  void goForward() {
    final currentDuration = state.controller?.getCurrentPosition() ?? Duration.zero;
    final seekToDuration = currentDuration + _fastForwardStep;
    state.controller?.seekTo(seekToDuration);
    showControlsAndAutoDismiss();
  }

  /// Recule la lecture de la durée prédéfinie ([_fastForwardStep]).
  ///
  /// La position de recherche est bornée à [Duration.zero] pour éviter
  /// de reculer avant le début du flux. Affiche les contrôles et déclenche l'auto-masquage.
  void goBackward() {
    final currentDuration = state.controller?.getCurrentPosition() ?? Duration.zero;
    final targetDuration = currentDuration - _fastForwardStep;
    final seekToDuration = targetDuration < Duration.zero ? Duration.zero : targetDuration;
    state.controller?.seekTo(seekToDuration);
    showControlsAndAutoDismiss();
  }

  /// Change la source de données du lecteur vidéo.
  ///
  /// Supprime l'encodage actif, dispose l'ancien contrôleur et génère/charge
  /// une nouvelle source de données.
  ///
  /// [item] L'élément (média) pour la nouvelle source.
  /// [streamParameters] Les paramètres de flux optionnels pour la nouvelle source.
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
    } on StreamingException catch (e) {
      emit(state.copyWith(failureMessage: e.message, status: StreamStatus.failure));
    } on DioError catch (e) {
      emit(state.copyWith(failureMessage: e.message, status: StreamStatus.failure));
    } catch (e, s) {
      debugPrint('Error during changeDataSource: $s');
      emit(state.copyWith(failureMessage: e.toString(), status: StreamStatus.failure));
    }
  }

  /// Récupère la liste des sous-titres disponibles, locaux et distants.
  Future<List<Subtitle>> getSubtitles() async {
    final subtitles = <Subtitle>[];
    final localSubtitles = await state.controller?.getSubtitles() ?? [];
    subtitles.addAll(localSubtitles);
    subtitles.addAll(_getRemoteSubtitles());
    return subtitles;
  }

  /// Définit la piste de sous-titres à utiliser.
  ///
  /// Supporte uniquement les sous-titres locaux pour l'instant.
  ///
  /// [subtitleTrack] La piste de sous-titres à sélectionner.
  void setSubtitleStreamIndex(Subtitle subtitleTrack) {
    if (subtitleTrack.mediaType == MediaType.local) {
      state.controller?.setSubtitle(subtitleTrack);
      emit(state.copyWith(selectedSubtitleTrack: subtitleTrack));
    }
  }

  // Méthodes privées :

  Future<List<AudioTrack>> _getAudioTracks() async {
    final audioTracks = <AudioTrack>[];
    final localAudioTracks = await state.controller?.getAudioTracks() ?? [];
    audioTracks.addAll(localAudioTracks);
    audioTracks.addAll(_getRemoteAudiotracks());
    return audioTracks;
  }

  List<AudioTrack> _getRemoteAudiotracks() {
    return [];
  }

  List<Subtitle> _getRemoteSubtitles() {
    final subtitles = <Subtitle>[];
    return subtitles;
  }

  /// Génère le contrôleur de flux et les informations de flux (StreamItem)
  /// pour un [item] donné.
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
}

class _StreamController {
  final CommonStream<dynamic> controller;
  final StreamItem streamItem;

  const _StreamController({required this.controller, required this.streamItem});
}
