import 'package:flutter/material.dart';

import 'package:jellyflut/theme.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonRightDetails extends StatelessWidget {
  const SkeletonRightDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: shimmerColor1,
      highlightColor: shimmerColor2,
      child: ListView(
        padding: const EdgeInsets.all(8.0),
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: [
          SizedBox(
            height: 64,
          ),
          buttons(),
          SizedBox(
            height: 24,
          ),
          title(),
          SizedBox(
            height: 24,
          ),
          infos(),
          SizedBox(
            height: 24,
          ),
          overview(),
          SizedBox(
            height: 24,
          ),
          title(),
          SizedBox(
            height: 24,
          ),
          peoples()
        ],
      ),
    );
  }

  Widget buttons() {
    return SizedBox(
        height: 40,
        child: ListView.builder(
            itemCount: 4,
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(right: 20),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    child: Container(
                      height: 40,
                      width: 150,
                      color: Colors.white30,
                    )))));
  }

  Widget title() {
    return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        child: Container(
          height: 40,
          width: 250,
          color: Colors.white30,
        ));
  }

  Widget infos() {
    return SizedBox(
      height: 40,
      child: Row(
        children: [
          info(),
          info(),
          info(),
          Spacer(),
          info(),
          info(),
        ],
      ),
    );
  }

  Widget info() {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          child: Container(width: 40, height: 40, color: Colors.white30)),
    );
  }

  Widget overview() {
    return SizedBox(
        height: (40 + 10) * 6,
        child: ListView.builder(
            itemCount: 6,
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    child: Container(
                      height: 40,
                      width: double.maxFinite,
                      color: Colors.white30,
                    )))));
  }

  Widget peoples() {
    return SizedBox(
        height: 160,
        child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: 15,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(right: 10),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    child: Container(
                      width: 120,
                      height: 160,
                      color: Colors.white30,
                    )))));
  }
}
