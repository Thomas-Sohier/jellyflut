part of '../list_items_parent.dart';

class ListItemsGrid extends StatelessWidget {
  final List<Item> items;
  final ScrollController scrollController;
  final ScrollPhysics scrollPhysics;

  const ListItemsGrid(
      {Key? key,
      required this.scrollPhysics,
      required this.scrollController,
      required this.items})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final itemAspectRatio =
          items.first.getPrimaryAspectRatio(showParent: true);
      final numberOfItemRow =
          (constraints.maxWidth / (itemPosterHeight * itemAspectRatio)).round();
      return CustomScrollView(
          controller: scrollController,
          scrollDirection: Axis.vertical,
          slivers: <Widget>[
            SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: items.first.getPrimaryAspectRatio(),
                    crossAxisCount: numberOfItemRow,
                    mainAxisExtent: itemPosterHeight + itemPosterLabelHeight,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5),
                delegate:
                    SliverChildBuilderDelegate((BuildContext c, int index) {
                  return ItemPoster(
                    items.elementAt(index),
                    width: double.infinity,
                    height: double.infinity,
                  );
                }, childCount: items.length))
          ]);
    });
  }
}
