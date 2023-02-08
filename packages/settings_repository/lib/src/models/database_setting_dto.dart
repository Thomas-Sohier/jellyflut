class DatabaseSettingDto {
  final int? id;
  final String? preferredPlayer;
  final String? preferredTranscodeAudioCodec;
  final int? maxVideoBitrate;
  final int? maxAudioBitrate;
  final String? downloadPath;
  final bool? directPlay;

  DatabaseSettingDto(
      {this.id,
      this.preferredPlayer,
      this.preferredTranscodeAudioCodec,
      this.maxVideoBitrate,
      this.maxAudioBitrate,
      this.downloadPath,
      this.directPlay});
}
