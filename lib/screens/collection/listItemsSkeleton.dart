import 'package:flutter/material.dart';
import 'package:jellyflut/components/skeleton.dart';
import 'package:jellyflut/shared/shared.dart';

class ListItemsSkeleton extends StatelessWidget {
  final count;
  ListItemsSkeleton({this.count = 10});

  @override
  Widget build(BuildContext context) {
    return buildSkeletonItemsGrid();
  }

  Widget buildSkeletonItemsGrid() {
    return Padding(
        padding: EdgeInsets.all(6),
        child: GridView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: 10,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: aspectRatio(),
                mainAxisSpacing: 15,
                crossAxisSpacing: 5),
            itemBuilder: (context, index) {
              return Column(children: [
                Skeleton(
                  height: 140,
                  colors: [Colors.white24, Colors.white30, Colors.white24],
                ),
                Skeleton(
                  colors: [Colors.white24, Colors.white30, Colors.white24],
                )
              ]);
            }));
  }
}
