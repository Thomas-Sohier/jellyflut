class SettingsDB {
  SettingsDB(
      {this.id,
      this.preferredPlayer,
      this.maxVideoBitrate,
      this.preferredTranscodeAudioCodec,
      this.maxAudioBitrate});

  int id;
  String preferredPlayer;
  int maxVideoBitrate;
  String preferredTranscodeAudioCodec;
  int maxAudioBitrate;

  factory SettingsDB.fromMap(Map<String, dynamic> map) => SettingsDB(
      id: map['id'],
      preferredPlayer: map['preferredPlayer'],
      maxVideoBitrate: map['maxVideoBitrate'],
      preferredTranscodeAudioCodec: map['preferredTranscodeAudioCodec'],
      maxAudioBitrate: map['maxAudioBitrate']);

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'preferredPlayer': preferredPlayer,
      'maxVideoBitrate': maxVideoBitrate,
      'preferredTranscodeAudioCodec': preferredTranscodeAudioCodec,
      'maxAudioBitrate': maxAudioBitrate,
    };
  }

  Map<String, dynamic> toMapDB() {
    return {
      if (id != null) 'id': id,
      if (preferredPlayer != null) 'preferredPlayer': preferredPlayer,
      if (maxVideoBitrate != null) 'maxVideoBitrate': maxVideoBitrate,
      if (preferredTranscodeAudioCodec != null)
        'preferredTranscodeAudioCodec': preferredTranscodeAudioCodec,
      if (maxAudioBitrate != null) 'maxAudioBitrate': maxAudioBitrate,
    };
  }
}
