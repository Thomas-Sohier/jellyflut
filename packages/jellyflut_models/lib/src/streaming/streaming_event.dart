enum StreamingEvent {
  DATASOURCE_CHANGED('DatasourceChanged'),
  SUBTITLE_SELECTED('SubtitleSelected'),
  AUDIO_TRACK_SELECTED('AudioTrackSelected'),
  PLAY('Play'),
  PAUSE('Pause');

  final String _value;

  String get value => _value;

  const StreamingEvent(this._value);
}
