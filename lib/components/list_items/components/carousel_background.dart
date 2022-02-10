part of '../list_items_parent.dart';

class CarouselBackground extends StatelessWidget {
  final Widget child;
  const CarouselBackground({Key? key, this.child = const SizedBox()})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
        child: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background.withAlpha(170)),
            child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
                child: Container(
                    decoration:
                        BoxDecoration(color: Colors.white.withOpacity(0.0)),
                    child: child))));
  }
}
