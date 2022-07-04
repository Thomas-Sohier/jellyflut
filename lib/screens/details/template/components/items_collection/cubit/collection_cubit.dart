import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:items_repository/items_repository.dart';
import 'package:jellyflut_models/jellyflut_models.dart';

part 'collection_state.dart';

class CollectionCubit extends Cubit<CollectionState> {
  CollectionCubit({required Item item, required ItemsRepository itemsRepository, required this.tabController})
      : _item = item,
        _itemsRepository = itemsRepository,
        super(CollectionState()) {
    _initFromItem(_item);
  }

  TabController tabController;
  final ItemsRepository _itemsRepository;
  final Item _item;
  final List<Item> _seasons = <Item>[];
  final Map<String, Future<List<Item>>> _episodes = <String, Future<List<Item>>>{};

  UnmodifiableListView<Item> get seasons => UnmodifiableListView(_seasons);
  Item get item => _item;

  Future<void> _initFromItem(Item item) async {
    emit(state.copyWith(status: CollectionStatus.loading));

    try {
      final seasons = await _itemsRepository.getSeasons(item.id);
      _seasons.clear();
      _seasons.addAll(seasons.items);
      for (var season in _seasons) {
        _episodes.putIfAbsent(season.id, () => _getEpisodes(season));
      }

      final currentSeason = _seasons.first;

      emit(
        state.copyWith(
          status: CollectionStatus.success,
          season: currentSeason,
          episodes: await _episodes[currentSeason.id],
        ),
      );
    } on Exception {
      emit(state.copyWith(status: CollectionStatus.failure));
    }
  }

  void changeSeason(String seasonId) async {
    emit(state.copyWith(status: CollectionStatus.loading));
    try {
      final currentSeason = _seasons.firstWhere((season) => season.id == seasonId);

      emit(
        state.copyWith(
          status: CollectionStatus.success,
          season: currentSeason,
          episodes: await _episodes[currentSeason.id],
        ),
      );
    } on Exception {
      emit(state.copyWith(status: CollectionStatus.failure));
    }
  }

  /// Get all episodes for a given season
  /// Utility function to return only items list
  Future<List<Item>> _getEpisodes(Item season) async {
    final episodes = await _itemsRepository.getEpsiodes(item.id, seasonId: season.id);
    return episodes.items;
  }

  void goToSeason(Item season) async {
    emit(state.copyWith(status: CollectionStatus.loading));

    tabController.animateTo(_seasons.indexOf(season));
    emit(state.copyWith(
      status: CollectionStatus.success,
      season: season,
      episodes: await _episodes[season.id],
    ));
  }
}
