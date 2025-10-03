part of 'collection_bloc.dart';

enum CollectionStatus { initial, loading, loadingMore, success, failure }

enum ListType {
  poster,
  list,
  grid;

  const ListType();
  ListType get next => ListType.values[(index + 1) % ListType.values.length];
}

enum SortOrder {
  asc,
  desc;

  const SortOrder();
  SortOrder get reverse => this == SortOrder.asc ? SortOrder.desc : SortOrder.asc;
}

class CollectionState extends Equatable {
  final CollectionStatus status;
  final List<Item> items;
  final bool canLoadMore;
  final ListType listType;
  final SortOrder sortOrder;
  final String sortField;

  const CollectionState({
    this.status = CollectionStatus.initial,
    this.items = const <Item>[],
    this.canLoadMore = true,
    this.listType = ListType.grid,
    this.sortOrder = SortOrder.asc,
    this.sortField = '',
  });

  CollectionState copyWith({
    CollectionStatus? status,
    List<Item>? items,
    bool? canLoadMore,
    ListType? listType,
    SortOrder? sortOrder,
    String? sortField,
  }) {
    return CollectionState(
      status: status ?? this.status,
      items: items ?? this.items,
      canLoadMore: canLoadMore ?? this.canLoadMore,
      listType: listType ?? this.listType,
      sortOrder: sortOrder ?? this.sortOrder,
      sortField: sortField ?? this.sortField,
    );
  }

  @override
  List<Object> get props => [status, items, canLoadMore, listType, sortOrder, sortField];
}
