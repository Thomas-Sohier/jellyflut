import 'package:flutter/material.dart';
import 'package:jellyflut/components/skeleton.dart';
import 'package:jellyflut/shared/shared.dart';

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
    var nbColumn = 3;
    if (size.width < 1024) {
      nbColumn = (size.width / 150).round();
    } else {
      nbColumn = (size.width / 200).round();
    }
    return Padding(
        padding: EdgeInsets.all(6),
        child: GridView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: 10,
            padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: nbColumn,
                childAspectRatio: ratio,
                mainAxisSpacing: 15,
                crossAxisSpacing: 5),
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Skeleton(
                    height: 175,
                    colors: [Colors.white24, Colors.white30, Colors.white24],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Skeleton(
                    height: 10,
                    colors: [Colors.white24, Colors.white30, Colors.white24],
                  ),
                ],
              );
              // Expanded(
              //     flex: 8,
              //     child: Skeleton(
              //       height: double.maxFinite,
              //       colors: [Colors.white24, Colors.white30, Colors.white24],
              //     )),
              // Spacer(
              //   flex: 1,
              // ),
              // Expanded(
              //     flex: 1,
              //     child: Skeleton(
              //       height: double.infinity,
              //       colors: [Colors.white24, Colors.white30, Colors.white24],
              //     ))
            }));
  }
}
