// \.[0-9a-z]+$

import 'package:jellyflut/models/enum/enum_values.dart';

enum StreamingEvent { SUBTITLE_SELECTED, AUDIO_TRACK_SELECTED, PLAY, PAUSE }

final streamingEventValues = EnumValues({
  'SubtitleSelected': StreamingEvent.SUBTITLE_SELECTED,
  '.AudioTrackSelected': StreamingEvent.AUDIO_TRACK_SELECTED,
  'Play': StreamingEvent.PLAY,
  'PAuse': StreamingEvent.PAUSE
});
