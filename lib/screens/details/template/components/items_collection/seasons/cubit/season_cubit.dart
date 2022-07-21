import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:items_repository/items_repository.dart';
import 'package:jellyflut_models/jellyflut_models.dart';

part 'season_state.dart';

class SeasonCubit extends Cubit<SeasonState> {
  SeasonCubit({required Item item, required ItemsRepository itemsRepository})
      : _itemsRepository = itemsRepository,
        super(SeasonState(parentItem: item)) {
    _initFromItem();
  }

  final ItemsRepository _itemsRepository;

  /// First method to be called
  /// Init seasons and episode from given item
  Future<void> _initFromItem() async {
    emit(state.copyWith(epsiodesStatus: Status.loading, seasonStatus: Status.loading));

    try {
      final seasons = (await _itemsRepository.getSeasons(state.parentItem.id)).items;
      emit(state.copyWith(seasonStatus: Status.success, seasons: seasons));

      final episodes = <String, Future<List<Item>>>{};
      for (var season in seasons) {
        episodes.putIfAbsent(season.id, () => _getEpisodes(season));
      }
      final currentSeason = seasons.first;
      final currentEpisodes = await episodes[currentSeason.id];
      emit(
        state.copyWith(
            epsiodesStatus: Status.success,
            episodes: episodes,
            currentSeason: currentSeason,
            currentEpisodes: currentEpisodes),
      );
    } on Exception catch (_) {
      emit(state.copyWith(epsiodesStatus: Status.failure, seasonStatus: Status.failure));
    }
  }

  /// Try to reload item seasons and episodes
  /// Useful on failure to allow user to reload data or when pull to refresh
  Future<void> retry() async {
    return _initFromItem();
  }

  void changeSeason(String seasonId) async {
    emit(state.copyWith(epsiodesStatus: Status.loading));
    try {
      final currentSeason = state.seasons.firstWhere((season) => season.id == seasonId);

      emit(
        state.copyWith(
          epsiodesStatus: Status.success,
          currentSeason: currentSeason,
          currentEpisodes: await state.episodes[currentSeason.id],
        ),
      );
    } on Exception catch (_) {
      emit(state.copyWith(epsiodesStatus: Status.failure));
    }
  }

  /// Get all episodes for a given season
  /// Utility function to return only items list
  Future<List<Item>> _getEpisodes(Item season) async {
    return (await _itemsRepository.getEpsiodes(state.parentItem.id, seasonId: season.id)).items;
  }

  void goToSeason(Item season) async {
    emit(state.copyWith(epsiodesStatus: Status.loading));
    emit(state.copyWith(
      epsiodesStatus: Status.success,
      currentSeason: season,
      currentEpisodes: await state.episodes[season.id],
    ));
  }
}
