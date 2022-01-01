import 'package:jellyflut/models/jellyfin/item.dart';

/// Events triggered from view
enum CollectionStatus { SORT_DATE, SORT_NAME, ADD, LOAD_MORE }

class CollectionEvent {
  final List<Item> items;
  final CollectionStatus status;

  const CollectionEvent({required this.items, required this.status});
}
