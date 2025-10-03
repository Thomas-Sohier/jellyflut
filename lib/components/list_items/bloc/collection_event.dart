part of 'collection_bloc.dart';

abstract class CollectionEvent extends Equatable {
  const CollectionEvent();

  @override
  List<Object?> get props => [];
}

class CollectionFetchStarted extends CollectionEvent {}

class CollectionFetchMore extends CollectionEvent {}

class CollectionRefreshed extends CollectionEvent {}

class CollectionListTypeChanged extends CollectionEvent {
  final ListType? listType;
  const CollectionListTypeChanged({this.listType});
}

class CollectionSortChanged extends CollectionEvent {
  final String field;
  const CollectionSortChanged(this.field);
}

class CollectionItemsReplaced extends CollectionEvent {
  final List<Item> items;
  const CollectionItemsReplaced(this.items);
}
