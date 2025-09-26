part of 'stream_cubit.dart';

enum StreamStatus { initial, loading, success, failure }

@immutable
class StreamState extends Equatable {
  const StreamState(
      {this.parentItem,
      this.url,
      this.status = StreamStatus.initial,
      this.streamItem = StreamItem.empty,
      this.controller,
      this.playing = false,
      this.visible = false,
      this.fullscreen = false,
      this.hasPip = false,
      this.showChannelPanel = false,
      this.selectedAudioTrack = AudioTrack.empty,
      this.audioTracks = const <AudioTrack>[],
      this.selectedSubtitleTrack = Subtitle.empty,
      this.failureMessage});

  final StreamStatus status;
  final Item? parentItem;
  final String? url;
  final StreamItem streamItem;
  final CommonStream<dynamic>? controller;
  final bool playing;
  final bool visible;
  final bool fullscreen;
  final bool hasPip;
  final bool showChannelPanel;
  final AudioTrack selectedAudioTrack;
  final List<AudioTrack> audioTracks;
  final Subtitle selectedSubtitleTrack;

  final String? failureMessage;

  StreamState copyWith(
      {StreamStatus? status,
      covariant CommonStream? controller,
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
        playing,
        visible,
        url,
        fullscreen,
        hasPip,
        showChannelPanel,
        selectedAudioTrack,
        audioTracks,
        selectedSubtitleTrack,
        failureMessage
      ];
}
