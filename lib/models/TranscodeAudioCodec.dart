enum TranscodeAudioCodecName { auto, ACC, MP3, OPUS }

class TranscodeAudioCodec {
  final TranscodeAudioCodecName name;

  TranscodeAudioCodec({this.name});
}
