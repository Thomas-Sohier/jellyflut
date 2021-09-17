import 'package:flutter/material.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/shared/shared.dart';
import 'package:jellyflut/shared/theme.dart';
import 'package:shimmer/shimmer.dart';

class ListItemsSkeleton extends StatelessWidget {
  final count;
  ListItemsSkeleton({this.count = 10});

  @override
  Widget build(BuildContext context) {
    return buildSkeletonItemsGrid(context);
  }

  Widget buildSkeletonItemsGrid(BuildContext context) {
    var ratio = aspectRatio();
    var size = MediaQuery.of(context).size;
    var itemPosterHeight = 150 / ratio;
    var numberOfItemInRow = (size.width / 150).round();
    var numberOfRow = (size.height / itemPosterHeight).round() * 2;

    return Shimmer.fromColors(
      enabled: shimmerAnimation,
      baseColor: shimmerColor1,
      highlightColor: shimmerColor2,
      child: GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: numberOfItemInRow * numberOfRow,
          padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: numberOfItemInRow,
              childAspectRatio: ratio,
              mainAxisSpacing: 15,
              crossAxisSpacing: 5),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(left: 4, right: 4),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                child: Container(
                  height: 20,
                  color: Colors.white30,
                ),
              ),
            );
          }),
    );
  }
}
