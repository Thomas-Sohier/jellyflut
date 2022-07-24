part of 'list_items_skeleton.dart';

class ListItemsHorizontalSkeleton extends StatelessWidget {
  final int count;
  const ListItemsHorizontalSkeleton({this.count = 10});

  @override
  Widget build(BuildContext context) {
    final itemHeight = context.read<CollectionBloc>().state.horizontalListPosterHeight;
    return Shimmer.fromColors(
        baseColor: shimmerColor1,
        highlightColor: shimmerColor2,
        child: Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            height: itemHeight,
            child: ListView.builder(
                padding: EdgeInsets.zero,
                controller: ScrollController(),
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: count,
                itemBuilder: (context, index) => SkeletonItemPoster(
                      height: itemHeight,
                      padding: EdgeInsets.only(right: 8),
                    )),
          ),
        ));
  }
}
