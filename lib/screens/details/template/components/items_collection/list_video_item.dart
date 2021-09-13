import 'package:flutter/material.dart';
import 'package:jellyflut/models/jellyfin/category.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/components/list_items.dart';
import 'package:jellyflut/services/item/item_service.dart';

class ListVideoItem extends StatefulWidget {
  final Item item;

  const ListVideoItem({required this.item});

  @override
  State<StatefulWidget> createState() => _ListVideoItemState();
}

class _ListVideoItemState extends State<ListVideoItem> {
  late Future<Category> episodeFuture;

  @override
  void initState() {
    episodeFuture =
        ItemService.getEpsiode(widget.item.seriesId!, widget.item.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListItems.fromFuture(
      itemsFuture: episodeFuture,
      showTitle: true,
    );
  }
}
