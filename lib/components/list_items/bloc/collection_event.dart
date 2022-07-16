part of 'collection_bloc.dart';

class CollectionEvent {
  const CollectionEvent();
}

class InitCollectionRequested extends CollectionEvent {
  const InitCollectionRequested();
}

class AddItem extends CollectionEvent {
  final List<Item> items;

  const AddItem({required this.items});
}

class ClearItemsRequested extends CollectionEvent {
  const ClearItemsRequested();
}

class SortByField extends CollectionEvent {
  final FieldsEnum fieldEnum;

  const SortByField({required this.fieldEnum});
}

class LoadMoreItemsRequested extends CollectionEvent {
  const LoadMoreItemsRequested();
}

class SetScrollController extends CollectionEvent {
  final ScrollController scrollController;

  const SetScrollController({required this.scrollController});
}
