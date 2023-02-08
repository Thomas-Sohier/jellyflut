part of 'list_items_skeleton.dart';

class ListItemsGridSkeleton extends StatelessWidget {
  const ListItemsGridSkeleton();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) => buildSkeletonItemsGrid(context, constraints));
  }

  Widget buildSkeletonItemsGrid(BuildContext context, BoxConstraints constraints) {
    final itemHeight = context.read<CollectionBloc>().state.gridPosterHeight.isInfinite
        ? itemPosterHeight
        : context.read<CollectionBloc>().state.gridPosterHeight;
    final ratio = aspectRatio();
    final size = MediaQuery.of(context).size;
    final numberOfRow = (size.height / itemHeight).round() * 2;
    final numberOfItemInRow = (constraints.maxWidth / (itemHeight * ratio)).round();

    return Shimmer.fromColors(
      enabled: shimmerAnimation,
      baseColor: shimmerColor1,
      highlightColor: shimmerColor2,
      child: GridView.builder(
          controller: ScrollController(),
          physics: NeverScrollableScrollPhysics(),
          itemCount: numberOfItemInRow * numberOfRow,
          padding: EdgeInsets.only(left: 4, right: 4),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: numberOfItemInRow, childAspectRatio: ratio, mainAxisSpacing: 10, crossAxisSpacing: 5),
          itemBuilder: (context, index) => SkeletonItemPoster(height: itemHeight)),
    );
  }
}
