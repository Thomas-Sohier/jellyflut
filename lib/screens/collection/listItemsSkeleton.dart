import 'package:flutter/material.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/shared/shared.dart';
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
    var itemHeight = 150 / ratio;
    var numberOfItemInRow = (size.width / 150).round();
    var numberOfRow = (size.height / itemHeight).round() * 2;

    return Padding(
        padding: EdgeInsets.all(6),
        child: Shimmer.fromColors(
          enabled: shimmerAnimation,
          highlightColor: Colors.grey[700],
          baseColor: Colors.grey[300],
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
                return ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  child: Container(
                    height: 20,
                    color: Colors.white30,
                  ),
                );
              }),
        ));
  }
}
