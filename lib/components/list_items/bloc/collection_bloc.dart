import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut_models/jellyflut_models.dart';

part 'collection_event.dart';
part 'collection_state.dart';

const int _paginationLimit = 100;

class CollectionBloc extends Bloc<CollectionEvent, CollectionState> {
  final Future<List<Item>> Function(int startIndex, int limit) _fetchMethod;

  // Configuration de l'affichage (immmuable)
  final ScrollPhysics physics;
  final double verticalListPosterHeight;
  final double horizontalListPosterHeight;
  final double gridPosterHeight;
  final bool showTitle;
  final bool showSorting;

  CollectionBloc({
    required Future<List<Item>> Function(int startIndex, int limit) fetchMethod,
    ListType listType = ListType.grid,
    this.physics = const ClampingScrollPhysics(),
    this.verticalListPosterHeight = 250,
    this.horizontalListPosterHeight = 150,
    this.gridPosterHeight = 220,
    this.showTitle = true,
    this.showSorting = true,
  }) : _fetchMethod = fetchMethod,
       super(CollectionState(listType: listType)) {
    on<CollectionFetchStarted>(onFetchStarted);
    on<CollectionFetchMore>(onFetchMore);
    on<CollectionRefreshed>(onRefreshed);
    on<CollectionListTypeChanged>(onListTypeChanged);
    on<CollectionSortChanged>(onSortChanged);
    on<CollectionItemsReplaced>(onItemsReplaced);
  }

  Future<void> onFetchStarted(CollectionFetchStarted event, Emitter<CollectionState> emit) async {
    emit(state.copyWith(status: CollectionStatus.loading, items: [], canLoadMore: true));
    try {
      final items = await _fetchMethod(0, _paginationLimit);
      emit(
        state.copyWith(status: CollectionStatus.success, items: items, canLoadMore: items.length == _paginationLimit),
      );
    } catch (_) {
      emit(state.copyWith(status: CollectionStatus.failure));
    }
  }

  Future<void> onFetchMore(CollectionFetchMore event, Emitter<CollectionState> emit) async {
    if (!state.canLoadMore || state.status == CollectionStatus.loadingMore) return;

    emit(state.copyWith(status: CollectionStatus.loadingMore));
    try {
      final newItems = await _fetchMethod(state.items.length, _paginationLimit);
      emit(
        state.copyWith(
          status: CollectionStatus.success,
          items: List.of(state.items)..addAll(newItems),
          canLoadMore: newItems.length == _paginationLimit,
        ),
      );
    } catch (_) {
      // Restore previous state on failure
      emit(state.copyWith(status: CollectionStatus.success));
    }
  }

  Future<void> onRefreshed(CollectionRefreshed event, Emitter<CollectionState> emit) async {
    // This is essentially the same as starting from scratch
    return onFetchStarted(CollectionFetchStarted(), emit);
  }

  void onListTypeChanged(CollectionListTypeChanged event, Emitter<CollectionState> emit) {
    emit(state.copyWith(listType: event.listType ?? state.listType.next));
  }

  void onItemsReplaced(CollectionItemsReplaced event, Emitter<CollectionState> emit) {
    emit(state.copyWith(items: event.items));
  }

  Future<void> onSortChanged(CollectionSortChanged event, Emitter<CollectionState> emit) async {
    final newOrder = (state.sortField == event.field) ? state.sortOrder.reverse : SortOrder.asc;

    emit(state.copyWith(status: CollectionStatus.loading, sortField: event.field, sortOrder: newOrder));

    final sortedItems = await compute(_sortItems, {
      'items': List.of(state.items),
      'field': event.field,
      'order': newOrder,
    });

    emit(state.copyWith(status: CollectionStatus.success, items: sortedItems));
  }
}

// Helper function for compute, must be a top-level function
Future<List<Item>> _sortItems(Map<String, dynamic> args) async {
  final items = args['items'] as List<Item>;
  final field = args['field'] as String;
  final order = args['order'] as SortOrder;

  int compare(dynamic a, dynamic b) {
    if (a == null && b == null) return 0;
    if (a == null) return 1;
    if (b == null) return -1;
    return (a as Comparable).compareTo(b as Comparable);
  }

  items.sort((a, b) {
    final aValue = a.toJson()[field];
    final bValue = b.toJson()[field];
    final comparison = compare(aValue, bValue);
    return order == SortOrder.asc ? comparison : -comparison;
  });

  return items;
}
