enum TranscodeAudioCodec {
  auto('auto'),
  ACC('ACC'),
  MP3('MP3'),
  OPUS('OPUS');

  final String codecName;
  const TranscodeAudioCodec(this.codecName);

  static TranscodeAudioCodec fromString(String codecName) {
    return TranscodeAudioCodec.values.firstWhere((codec) => codec.codecName.toLowerCase() == codecName.toLowerCase());
  }
}
