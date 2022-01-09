part of 'collection_bloc.dart';

class CollectionEvent {
  const CollectionEvent();
}

class AddItem extends CollectionEvent {
  final List<Item> items;

  const AddItem({required this.items});
}

class ClearItem extends CollectionEvent {
  const ClearItem();
}

class SortByDate extends CollectionEvent {
  const SortByDate();
}

class SortByName extends CollectionEvent {
  const SortByName();
}

class LoadMoreItems extends CollectionEvent {
  const LoadMoreItems();
}
