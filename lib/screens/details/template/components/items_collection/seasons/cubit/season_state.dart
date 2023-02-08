part of 'season_cubit.dart';

enum Status { initial, loading, success, failure }

class SeasonState extends Equatable {
  const SeasonState(
      {required this.parentItem,
      this.seasonStatus = Status.initial,
      this.epsiodesStatus = Status.initial,
      this.currentSeason = Item.empty,
      this.currentEpisodes = const <Item>[],
      this.seasons = const <Item>[],
      this.episodes = const <String, Future<List<Item>>>{}});

  final Status seasonStatus;
  final Status epsiodesStatus;
  final Item parentItem;
  final List<Item> seasons;
  final Map<String, Future<List<Item>>> episodes;
  final Item currentSeason;
  final List<Item> currentEpisodes;

  SeasonState copyWith(
      {Status? seasonStatus,
      Status? epsiodesStatus,
      Item? parentItem,
      List<Item>? seasons,
      Item? currentSeason,
      List<Item>? currentEpisodes,
      Map<String, Future<List<Item>>>? episodes}) {
    return SeasonState(
        seasonStatus: seasonStatus ?? this.seasonStatus,
        epsiodesStatus: epsiodesStatus ?? this.epsiodesStatus,
        parentItem: parentItem ?? this.parentItem,
        seasons: seasons ?? this.seasons,
        currentSeason: currentSeason ?? this.currentSeason,
        currentEpisodes: currentEpisodes ?? this.currentEpisodes,
        episodes: episodes ?? this.episodes);
  }

  @override
  List<Object?> get props =>
      [seasonStatus, epsiodesStatus, currentSeason, currentEpisodes, parentItem, seasons, episodes];
}
