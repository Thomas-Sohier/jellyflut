part of 'list_items_skeleton.dart';

class SkeletonItemPoster extends StatelessWidget {
  final double height;
  final double aspectRatio;
  final EdgeInsets padding;

  const SkeletonItemPoster(
      {super.key, this.height = double.infinity, this.aspectRatio = 2 / 3, this.padding = EdgeInsets.zero});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Padding(
        padding: padding,
        child: AspectRatio(
          aspectRatio: aspectRatio,
          child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              child: Container(
                height: height,
                width: double.infinity,
                color: Colors.white30,
              )),
        ),
      ),
    );
  }
}
