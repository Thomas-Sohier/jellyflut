part of '../list_items_parent.dart';

class ListItemsHorizontalList extends StatelessWidget {
  final List<Item> items;
  final ScrollPhysics scrollPhysics;
  final BoxFit boxFit;
  final Widget? notFoundPlaceholder;

  const ListItemsHorizontalList(
      {super.key,
      this.boxFit = BoxFit.cover,
      this.notFoundPlaceholder,
      required this.items,
      required this.scrollPhysics});

  @override
  Widget build(BuildContext context) {
    final itemHeight = context.read<CollectionBloc>().state.horizontalListPosterHeight;
    return SizedBox(
      height: itemHeight,
      child: ListView.builder(
          itemCount: items.length,
          scrollDirection: Axis.horizontal,
          controller: ScrollController(),
          physics: scrollPhysics,
          itemBuilder: (context, index) => ItemPoster(
                items.elementAt(index),
                boxFit: boxFit,
                notFoundPlaceholder: notFoundPlaceholder,
                width: double.infinity,
                height: double.infinity,
              )),
    );
  }
}
