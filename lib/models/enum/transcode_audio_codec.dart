enum TranscodeAudioCodec {
  auto('auto'),
  ACC('ACC'),
  MP3('MP3'),
  OPUS('OPUS');

  final String name;
  const TranscodeAudioCodec(this.name);

  static TranscodeAudioCodec fromString(String name) {
    return TranscodeAudioCodec.values
        .firstWhere((codec) => codec.name.toLowerCase() == name.toLowerCase());
  }
}
