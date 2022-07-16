part of 'collection_bloc.dart';

enum CollectionStatus { initial, loading, loadingMore, success, failure }

enum ListType {
  poster,
  list,
  grid;
}

class CollectionState extends Equatable {
  final List<Item> carouselSliderItems;
  final List<Item> items;
  final ListType listType;
  final bool canLoadMore;
  final bool showTitle;
  final bool showIfEmpty;
  final bool showSorting;
  final CollectionStatus collectionStatus;
  final ScrollController scrollController;
  final Future<List<Item>> Function(int startIndex, int limit) fetchMethod;

  const CollectionState(
      {required this.scrollController,
      required this.fetchMethod,
      this.carouselSliderItems = const <Item>[],
      this.items = const <Item>[],
      this.canLoadMore = true,
      this.showTitle = false,
      this.showIfEmpty = true,
      this.showSorting = true,
      this.collectionStatus = CollectionStatus.initial,
      this.listType = ListType.grid});

  CollectionState copyWith({
    List<Item>? carouselSliderItems,
    List<Item>? items,
    ListType? listType,
    bool? canLoadMore,
    bool? showTitle,
    bool? showIfEmpty,
    bool? showSorting,
    ScrollController? scrollController,
    CollectionStatus? collectionStatus,
  }) {
    return CollectionState(
        carouselSliderItems: carouselSliderItems ?? this.carouselSliderItems,
        items: items ?? this.items,
        fetchMethod: fetchMethod,
        listType: listType ?? this.listType,
        canLoadMore: canLoadMore ?? this.canLoadMore,
        showTitle: showTitle ?? this.showTitle,
        showIfEmpty: showIfEmpty ?? this.showIfEmpty,
        showSorting: showSorting ?? this.showSorting,
        scrollController: scrollController ?? this.scrollController,
        collectionStatus: collectionStatus ?? this.collectionStatus);
  }

  @override
  List<Object?> get props => [
        canLoadMore,
        carouselSliderItems,
        scrollController,
        collectionStatus,
        items,
        showTitle,
        showIfEmpty,
        showSorting,
        listType
      ];
}
