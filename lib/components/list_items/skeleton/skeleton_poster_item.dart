part of 'list_items_skeleton.dart';

class SkeletonItemPoster extends StatelessWidget {
  final double height;
  final EdgeInsets padding;

  const SkeletonItemPoster(
      {Key? key, this.height = double.infinity, this.padding = EdgeInsets.zero})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Padding(
        padding: padding,
        child: AspectRatio(
          aspectRatio: 2 / 3,
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
