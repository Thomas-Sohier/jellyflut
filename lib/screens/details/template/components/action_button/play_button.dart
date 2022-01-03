part of '../action_button.dart';

class PlayButton extends StatelessWidget {
  final Item item;
  final Future<Color> dominantColorFuture;
  final double maxWidth;

  const PlayButton(
      {Key? key,
      required this.item,
      required this.dominantColorFuture,
      this.maxWidth = 150})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PaletteButton(
      'play'.tr(),
      onPressed: item.playItem,
      borderRadius: 4,
      minWidth: 40,
      maxWidth: maxWidth,
      icon: Icon(Icons.play_arrow, color: Colors.black87),
      dominantColorFuture: dominantColorFuture,
    );
  }
}
