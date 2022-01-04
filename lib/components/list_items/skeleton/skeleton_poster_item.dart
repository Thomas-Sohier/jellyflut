part of 'list_items_skeleton.dart';

class SkeletonItemPoster extends StatelessWidget {
  const SkeletonItemPoster({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 9),
      child: SizedBox(
          height: listHeight,
          child: AspectRatio(
            aspectRatio: 2 / 3,
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                child: Container(
                  height: listHeight,
                  width: double.infinity,
                  color: Colors.white30,
                )),
          )),
    );
  }
}
