class Configuration {
  Configuration({
    this.audioLanguagePreference,
    this.playDefaultAudioTrack,
    this.subtitleLanguagePreference,
    this.displayMissingEpisodes,
    this.groupedFolders,
    this.subtitleMode,
    this.displayCollectionsView,
    this.enableLocalPassword,
    this.orderedViews,
    this.latestItemsExcludes,
    this.myMediaExcludes,
    this.hidePlayedInLatest,
    this.rememberAudioSelections,
    this.rememberSubtitleSelections,
    this.enableNextEpisodeAutoPlay,
  });

  String audioLanguagePreference;
  bool playDefaultAudioTrack;
  String subtitleLanguagePreference;
  bool displayMissingEpisodes;
  List<dynamic> groupedFolders;
  String subtitleMode;
  bool displayCollectionsView;
  bool enableLocalPassword;
  List<String> orderedViews;
  List<dynamic> latestItemsExcludes;
  List<dynamic> myMediaExcludes;
  bool hidePlayedInLatest;
  bool rememberAudioSelections;
  bool rememberSubtitleSelections;
  bool enableNextEpisodeAutoPlay;

  factory Configuration.fromMap(Map<String, dynamic> json) => Configuration(
        audioLanguagePreference: json['AudioLanguagePreference'],
        playDefaultAudioTrack: json['PlayDefaultAudioTrack'],
        subtitleLanguagePreference: json['SubtitleLanguagePreference'],
        displayMissingEpisodes: json['DisplayMissingEpisodes'],
        groupedFolders:
            List<dynamic>.from(json['GroupedFolders'].map((x) => x)),
        subtitleMode: json['SubtitleMode'],
        displayCollectionsView: json['DisplayCollectionsView'],
        enableLocalPassword: json['EnableLocalPassword'],
        orderedViews: List<String>.from(json['OrderedViews'].map((x) => x)),
        latestItemsExcludes:
            List<dynamic>.from(json['LatestItemsExcludes'].map((x) => x)),
        myMediaExcludes:
            List<dynamic>.from(json['MyMediaExcludes'].map((x) => x)),
        hidePlayedInLatest: json['HidePlayedInLatest'],
        rememberAudioSelections: json['RememberAudioSelections'],
        rememberSubtitleSelections: json['RememberSubtitleSelections'],
        enableNextEpisodeAutoPlay: json['EnableNextEpisodeAutoPlay'],
      );

  Map<String, dynamic> toMap() => {
        'AudioLanguagePreference': audioLanguagePreference,
        'PlayDefaultAudioTrack': playDefaultAudioTrack,
        'SubtitleLanguagePreference': subtitleLanguagePreference,
        'DisplayMissingEpisodes': displayMissingEpisodes,
        'GroupedFolders': List<dynamic>.from(groupedFolders.map((x) => x)),
        'SubtitleMode': subtitleMode,
        'DisplayCollectionsView': displayCollectionsView,
        'EnableLocalPassword': enableLocalPassword,
        'OrderedViews': List<dynamic>.from(orderedViews.map((x) => x)),
        'LatestItemsExcludes':
            List<dynamic>.from(latestItemsExcludes.map((x) => x)),
        'MyMediaExcludes': List<dynamic>.from(myMediaExcludes.map((x) => x)),
        'HidePlayedInLatest': hidePlayedInLatest,
        'RememberAudioSelections': rememberAudioSelections,
        'RememberSubtitleSelections': rememberSubtitleSelections,
        'EnableNextEpisodeAutoPlay': enableNextEpisodeAutoPlay,
      };
}
