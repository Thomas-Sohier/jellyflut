part of '../list_items_parent.dart';

class ListItemsGrid extends StatelessWidget {
  final List<Item> items;
  final ScrollPhysics scrollPhysics;
  final BoxFit boxFit;
  final Widget? notFoundPlaceholder;
  final EdgeInsetsGeometry padding;

  const ListItemsGrid(
      {super.key,
      this.boxFit = BoxFit.cover,
      this.notFoundPlaceholder,
      this.padding = const EdgeInsets.symmetric(horizontal: 8),
      required this.scrollPhysics,
      required this.items});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final itemHeight = context.read<CollectionBloc>().state.gridPosterHeight.isInfinite
          ? itemPosterHeight
          : context.read<CollectionBloc>().state.gridPosterHeight;
      final itemAspectRatio = items.first.getPrimaryAspectRatio(showParent: true);
      final numberOfItemRow = (constraints.maxWidth / (itemHeight * itemAspectRatio)).round();
      return CustomScrollView(controller: ScrollController(), scrollDirection: Axis.vertical, slivers: <Widget>[
        SliverPadding(
          padding: padding,
          sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: items.first.getPrimaryAspectRatio(),
                  crossAxisCount: numberOfItemRow,
                  mainAxisExtent: itemHeight + itemPosterLabelHeight,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5),
              delegate: SliverChildBuilderDelegate((BuildContext c, int index) {
                return ItemPoster(
                  items.elementAt(index),
                  boxFit: boxFit,
                  notFoundPlaceholder: notFoundPlaceholder,
                  width: double.infinity,
                  height: double.infinity,
                );
              }, childCount: items.length)),
        )
      ]);
    });
  }
}
