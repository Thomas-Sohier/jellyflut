// \.[0-9a-z]+$

import 'package:jellyflut/models/enum/enum_values.dart';

enum StreamingEvent {
  DATASOURCE_CHANGED,
  SUBTITLE_SELECTED,
  AUDIO_TRACK_SELECTED,
  PLAY,
  PAUSE
}

final streamingEventValues = EnumValues({
  'DatasourceChanged': StreamingEvent.DATASOURCE_CHANGED,
  'SubtitleSelected': StreamingEvent.SUBTITLE_SELECTED,
  'AudioTrackSelected': StreamingEvent.AUDIO_TRACK_SELECTED,
  'Play': StreamingEvent.PLAY,
  'PAuse': StreamingEvent.PAUSE
});
