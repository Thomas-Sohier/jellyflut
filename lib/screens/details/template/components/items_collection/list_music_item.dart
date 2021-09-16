import 'package:flutter/material.dart';
import 'package:jellyflut/models/enum/list_type.dart';
import 'package:jellyflut/models/jellyfin/category.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/components/list_items.dart';
import 'package:jellyflut/services/item/item_service.dart';

class ListMusicItem extends StatefulWidget {
  final Item item;

  const ListMusicItem({required this.item});

  @override
  State<StatefulWidget> createState() => _ListMusicItemState();
}

class _ListMusicItemState extends State<ListMusicItem> {
  late Future<Category> musicFuture;

  @override
  void initState() {
    musicFuture = ItemService.getItems(parentId: widget.item.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListItems.fromFuture(
      itemsFuture: musicFuture,
      lisType: ListType.LIST,
    );
  }
}
