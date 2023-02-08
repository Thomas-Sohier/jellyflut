part of 'list_items_skeleton.dart';

class ListItemsVerticalSkeleton extends StatelessWidget {
  final int count;
  const ListItemsVerticalSkeleton({this.count = 10});

  @override
  Widget build(BuildContext context) {
    final itemHeight = context.read<CollectionBloc>().state.verticalListPosterHeight;
    return Shimmer.fromColors(
        baseColor: shimmerColor1,
        highlightColor: shimmerColor2,
        child: ListView.builder(
            padding: EdgeInsets.zero,
            controller: ScrollController(),
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: count,
            itemBuilder: (context, index) => SkeletonItemPoster(
                  height: itemHeight,
                  padding: EdgeInsets.fromLTRB(10, 8, 10, 8),
                )));
  }
}
