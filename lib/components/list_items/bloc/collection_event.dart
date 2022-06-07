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

class SortByField extends CollectionEvent {
  final FieldsEnum fieldEnum;

  const SortByField({required this.fieldEnum});
}

class LoadMoreItems extends CollectionEvent {
  const LoadMoreItems();
}
