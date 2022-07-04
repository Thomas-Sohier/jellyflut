import 'package:flutter/material.dart';

import 'package:shimmer/shimmer.dart';

class SkeletonRightDetails extends StatelessWidget {
  const SkeletonRightDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).colorScheme.onBackground.withAlpha(150),
      highlightColor: Theme.of(context).colorScheme.onBackground.withAlpha(100),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 64),
            buttons(),
            const SizedBox(height: 36),
            Center(child: tagline()),
            const SizedBox(height: 36),
            title(),
            const SizedBox(height: 24),
            infos(),
            const SizedBox(height: 24),
            overview(),
            const SizedBox(height: 24),
            providers(),
            const SizedBox(height: 36),
            title(),
            const SizedBox(height: 24),
            peoples()
          ],
        ),
      ),
    );
  }

  Widget buttons() {
    const height = 40.0;
    const borderRadius = 5.0;
    const width = 150.0;
    return SizedBox(
        height: height,
        child: ListView.builder(
            itemCount: 4,
            itemExtent: width,
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => const Padding(
                padding: EdgeInsets.only(right: 20),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
                    child: SizedBox(
                      height: height,
                      width: width,
                      child: ColoredBox(color: Colors.white30),
                    )))));
  }

  Widget title() {
    const height = 40.0;
    const borderRadius = 5.0;
    const width = 250.0;
    return const ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        child: SizedBox(
          height: height,
          width: width,
          child: ColoredBox(color: Colors.white30),
        ));
  }

  Widget tagline() {
    const height = 40.0;
    const borderRadius = 5.0;
    const width = 250.0;
    return const ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        child: SizedBox(
          height: height,
          width: width,
          child: ColoredBox(color: Colors.white30),
        ));
  }

  Widget infos() {
    const height = 40.0;
    return SizedBox(
      height: height,
      child: Row(
        children: [
          info(),
          info(),
          info(),
          const Spacer(),
          info(),
          info(),
        ],
      ),
    );
  }

  Padding info() {
    const padding = 10.0;
    const borderRadius = 5.0;
    return const Padding(
      padding: EdgeInsets.only(right: padding),
      child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          child: SizedBox(
            height: 40,
            width: 40,
            child: ColoredBox(color: Colors.white30),
          )),
    );
  }

  Widget overview() {
    const paddingBottom = 10.0;
    const height = 40.0;
    const borderRadius = 5.0;
    const itemCount = 6;
    const skeletonHeight = (height + paddingBottom) * itemCount;
    return SizedBox(
        height: skeletonHeight,
        child: ListView.builder(
            itemCount: itemCount,
            itemExtent: skeletonHeight,
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(bottom: paddingBottom),
                child: const ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
                    child: SizedBox(
                      height: height,
                      width: double.maxFinite,
                      child: ColoredBox(color: Colors.white30),
                    )))));
  }

  Widget providers() {
    const height = 40.0;
    const borderRadius = 24.0;
    const width = 150.0;
    return SizedBox(
        height: height,
        child: ListView.builder(
            itemCount: 3,
            itemExtent: width,
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => const Padding(
                padding: EdgeInsets.only(right: 20),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
                    child: SizedBox(
                      height: height,
                      width: width,
                      child: ColoredBox(color: Colors.white30),
                    )))));
  }

  Widget peoples() {
    const paddingRight = 10.0;
    const height = 180.0;
    const width = 140.0;
    const borderRadius = 5.0;
    const itemCount = 15;
    return SizedBox(
        height: height,
        child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: itemCount,
            itemExtent: width,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => const Padding(
                padding: EdgeInsets.only(right: paddingRight),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
                    child: SizedBox(
                      height: height,
                      width: width,
                      child: ColoredBox(color: Colors.white30),
                    )))));
  }
}
