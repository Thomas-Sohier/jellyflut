class StreamParameters {
  final int? subtitleStreamIndex;
  final int? audioStreamIndex;
  final Duration? startAt;

  const StreamParameters({this.startAt, this.subtitleStreamIndex, this.audioStreamIndex});

  static const empty = StreamParameters();

  /// Convenience getter to determine whether the current stream parameters is empty.
  bool get isEmpty => this == StreamParameters.empty;

  /// Convenience getter to determine whether the current current stream parameters is not empty.
  bool get isNotEmpty => this != StreamParameters.empty;
}
