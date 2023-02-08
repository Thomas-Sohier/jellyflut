part of 'stream_cubit.dart';

enum StreamStatus { initial, loading, success, failure }

@immutable
class StreamState extends Equatable {
  const StreamState(
      {required this.controlsVisibilityTimer,
      this.parentItem,
      this.streamItem = StreamItem.empty,
      this.url,
      this.playing = false,
      this.visible = false,
      this.fullscreen = false,
      this.hasPip = false,
      this.showChannelPanel = false,
      this.selectedAudioTrack = AudioTrack.empty,
      this.selectedSubtitleTrack = Subtitle.empty,
      this.audioTracks = const <AudioTrack>[],
      this.status = StreamStatus.initial,
      this.controller,
      this.failureMessage});

  final StreamStatus status;
  final Item? parentItem;
  final String? url;
  final StreamItem streamItem;
  final CommonStream? controller;
  final bool playing;
  final bool visible;
  final bool fullscreen;
  final bool hasPip;
  final bool showChannelPanel;
  final AudioTrack selectedAudioTrack;
  final List<AudioTrack> audioTracks;
  final Subtitle selectedSubtitleTrack;
  final Timer controlsVisibilityTimer;
  final String? failureMessage;

  StreamState copyWith(
      {StreamStatus? status,
      CommonStream? controller,
      Item? parentItem,
      String? url,
      StreamItem? streamItem,
      bool? playing,
      bool? visible,
      bool? fullscreen,
      bool? hasPip,
      bool? showChannelPanel,
      Timer? controlsVisibilityTimer,
      AudioTrack? selectedAudioTrack,
      List<AudioTrack>? audioTracks,
      Subtitle? selectedSubtitleTrack,
      String? failureMessage}) {
    return StreamState(
        status: status ?? this.status,
        controller: controller ?? this.controller,
        parentItem: parentItem ?? this.parentItem,
        url: url ?? this.url,
        streamItem: streamItem ?? this.streamItem,
        playing: playing ?? this.playing,
        visible: visible ?? this.visible,
        fullscreen: fullscreen ?? this.fullscreen,
        hasPip: hasPip ?? this.hasPip,
        showChannelPanel: showChannelPanel ?? this.showChannelPanel,
        controlsVisibilityTimer: controlsVisibilityTimer ?? this.controlsVisibilityTimer,
        selectedAudioTrack: selectedAudioTrack ?? this.selectedAudioTrack,
        audioTracks: audioTracks ?? this.audioTracks,
        selectedSubtitleTrack: selectedSubtitleTrack ?? this.selectedSubtitleTrack,
        failureMessage: failureMessage ?? this.failureMessage);
  }

  @override
  List<Object?> get props => [
        status,
        parentItem,
        streamItem,
        controller,
        playing,
        visible,
        url,
        fullscreen,
        hasPip,
        showChannelPanel,
        selectedAudioTrack,
        audioTracks,
        controlsVisibilityTimer,
        selectedSubtitleTrack,
        failureMessage
      ];
}
