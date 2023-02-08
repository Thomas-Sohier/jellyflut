class Capabilities {
  Capabilities({
    required this.playableMediaTypes,
    required this.supportedCommands,
    required this.supportsMediaControl,
    required this.supportsContentUploading,
    required this.supportsPersistentIdentifier,
    required this.supportsSync,
  });

  List<dynamic> playableMediaTypes;
  List<dynamic> supportedCommands;
  bool supportsMediaControl;
  bool supportsContentUploading;
  bool supportsPersistentIdentifier;
  bool supportsSync;

  factory Capabilities.fromMap(Map<String, dynamic> json) => Capabilities(
        playableMediaTypes: List<dynamic>.from(json['PlayableMediaTypes'].map((x) => x)),
        supportedCommands: List<dynamic>.from(json['SupportedCommands'].map((x) => x)),
        supportsMediaControl: json['SupportsMediaControl'],
        supportsContentUploading: json['SupportsContentUploading'],
        supportsPersistentIdentifier: json['SupportsPersistentIdentifier'],
        supportsSync: json['SupportsSync'],
      );

  Map<String, dynamic> toMap() => {
        'PlayableMediaTypes': List<dynamic>.from(playableMediaTypes.map((x) => x)),
        'SupportedCommands': List<dynamic>.from(supportedCommands.map((x) => x)),
        'SupportsMediaControl': supportsMediaControl,
        'SupportsContentUploading': supportsContentUploading,
        'SupportsPersistentIdentifier': supportsPersistentIdentifier,
        'SupportsSync': supportsSync,
      };
}
