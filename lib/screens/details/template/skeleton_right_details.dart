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
          children: const [
            _Buttons(),
            SizedBox(height: 36),
            Center(child: _TagLine()),
            SizedBox(height: 36),
            _Title(),
            SizedBox(height: 24),
            _Infos(),
            SizedBox(height: 24),
            _Overview(),
            SizedBox(height: 24),
            _Providers(),
            SizedBox(height: 36),
            _Title(),
            SizedBox(height: 24),
            _Peoples()
          ],
        ),
      ),
    );
  }
}

class _Buttons extends StatelessWidget {
  const _Buttons();

  @override
  Widget build(BuildContext context) {
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
                    borderRadius:
                        BorderRadius.all(Radius.circular(borderRadius)),
                    child: SizedBox(
                      height: height,
                      width: width,
                      child: ColoredBox(color: Colors.white30),
                    )))));
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
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
}

class _TagLine extends StatelessWidget {
  const _TagLine();

  @override
  Widget build(BuildContext context) {
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
}

class _Infos extends StatelessWidget {
  const _Infos();

  @override
  Widget build(BuildContext context) {
    const height = 40.0;
    return SizedBox(
      height: height,
      child: Row(
        children: const [
          _Info(),
          _Info(),
          _Info(),
          Spacer(),
          _Info(),
          _Info(),
        ],
      ),
    );
  }
}

class _Info extends StatelessWidget {
  const _Info();

  @override
  Widget build(BuildContext context) {
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
            )));
  }
}

class _Overview extends StatelessWidget {
  const _Overview();

  @override
  Widget build(BuildContext context) {
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
                    borderRadius:
                        BorderRadius.all(Radius.circular(borderRadius)),
                    child: SizedBox(
                      height: height,
                      width: double.maxFinite,
                      child: ColoredBox(color: Colors.white30),
                    )))));
  }
}

class _Providers extends StatelessWidget {
  const _Providers();

  @override
  Widget build(BuildContext context) {
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
                    borderRadius:
                        BorderRadius.all(Radius.circular(borderRadius)),
                    child: SizedBox(
                      height: height,
                      width: width,
                      child: ColoredBox(color: Colors.white30),
                    )))));
  }
}

class _Peoples extends StatelessWidget {
  const _Peoples();

  @override
  Widget build(BuildContext context) {
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
                    borderRadius:
                        BorderRadius.all(Radius.circular(borderRadius)),
                    child: SizedBox(
                      height: height,
                      width: width,
                      child: ColoredBox(color: Colors.white30),
                    )))));
  }
}
