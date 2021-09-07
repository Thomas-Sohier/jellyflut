part of '../action_button.dart';

class TrailerButton extends StatelessWidget {
  final Item item;
  final double maxWidth;

  const TrailerButton({Key? key, required this.item, this.maxWidth = 150})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PaletteButton('Trailer',
        onPressed: () => playTrailer(context),
        minWidth: 40,
        maxWidth: maxWidth,
        borderRadius: 4,
        icon: Icon(Icons.movie, color: Colors.black87));
  }

  void playTrailer(BuildContext context) async {
    final url = await item.getYoutubeTrailerUrl();
    await customRouter.push(StreamRoute(url: url.toString(), item: item));
  }
}
