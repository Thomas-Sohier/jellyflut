part of '../list_items_parent.dart';

class ListItemsHorizontalList extends StatelessWidget {
  final List<Item> items;
  final ScrollPhysics scrollPhysics;
  final ScrollController scrollController;

  const ListItemsHorizontalList(
      {Key? key,
      required this.items,
      required this.scrollPhysics,
      required this.scrollController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: listHeight,
      child: ListView.builder(
          itemCount: items.length,
          scrollDirection: Axis.horizontal,
          controller: scrollController,
          physics: scrollPhysics,
          itemBuilder: (context, index) => ItemPoster(items.elementAt(index))),
    );
  }
}
