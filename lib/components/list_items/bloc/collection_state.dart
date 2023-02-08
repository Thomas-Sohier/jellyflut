part of 'collection_bloc.dart';

enum SeasonStatus { initial, loading, loadingMore, success, failure }

enum ListType {
  poster,
  list,
  grid;

  const ListType();

  ListType getNextListType() => ListType.values[(index + 1) >= ListType.values.length ? 0 : index + 1];
}

enum SortBy {
  ASC,
  DESC;

  const SortBy();

  SortBy reverse() => this == SortBy.ASC ? SortBy.DESC : SortBy.ASC;
}

class SeasonState extends Equatable {
  final List<Item> carouselSliderItems;
  final List<Item> items;
  final ListType listType;
  final bool canLoadMore;
  final bool showTitle;
  final bool showIfEmpty;
  final bool showSorting;
  final SortBy sortBy;
  final String sortField;
  final double horizontalListPosterHeight;
  final double verticalListPosterHeight;
  final double gridPosterHeight;
  final SeasonStatus collectionStatus;
  final ScrollController scrollController;
  final Future<List<Item>> Function(int startIndex, int limit) fetchMethod;

  const SeasonState(
      {required this.scrollController,
      required this.fetchMethod,
      this.sortField = '',
      this.carouselSliderItems = const <Item>[],
      this.items = const <Item>[],
      this.canLoadMore = true,
      this.showTitle = false,
      this.showIfEmpty = true,
      this.showSorting = true,
      this.horizontalListPosterHeight = 150,
      this.verticalListPosterHeight = double.infinity,
      this.gridPosterHeight = 100,
      this.sortBy = SortBy.DESC,
      this.collectionStatus = SeasonStatus.initial,
      this.listType = ListType.grid});

  SeasonState copyWith({
    List<Item>? carouselSliderItems,
    List<Item>? items,
    ListType? listType,
    bool? canLoadMore,
    bool? showTitle,
    bool? showIfEmpty,
    bool? showSorting,
    double? horizontalListPosterHeight,
    double? verticalListPosterHeight,
    double? gridPosterHeight,
    SortBy? sortBy,
    String? sortField,
    ScrollController? scrollController,
    SeasonStatus? collectionStatus,
  }) {
    return SeasonState(
        carouselSliderItems: carouselSliderItems ?? this.carouselSliderItems,
        items: items ?? this.items,
        fetchMethod: fetchMethod,
        listType: listType ?? this.listType,
        canLoadMore: canLoadMore ?? this.canLoadMore,
        showTitle: showTitle ?? this.showTitle,
        showIfEmpty: showIfEmpty ?? this.showIfEmpty,
        showSorting: showSorting ?? this.showSorting,
        sortBy: sortBy ?? this.sortBy,
        horizontalListPosterHeight: horizontalListPosterHeight ?? this.horizontalListPosterHeight,
        verticalListPosterHeight: verticalListPosterHeight ?? this.verticalListPosterHeight,
        gridPosterHeight: gridPosterHeight ?? this.gridPosterHeight,
        sortField: sortField ?? this.sortField,
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
        sortBy,
        sortField,
        listType
      ];
}
