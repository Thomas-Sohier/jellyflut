part of '../action_button.dart';

class PlayButton extends StatelessWidget {
  final Item item;
  final double maxWidth;

  const PlayButton({super.key, required this.item, this.maxWidth = 150});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Future<List<Color>>>(
        stream:
            BlocProvider.of<DetailsBloc>(context).detailsInfos.dominantColor,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return PaletteButton(
              'play'.tr(),
              onPressed: item.playItem,
              borderRadius: 4,
              minWidth: 40,
              maxWidth: maxWidth,
              icon: Icon(Icons.play_arrow, color: Colors.black87),
              dominantColorFuture: snapshot.data,
            );
          }
          return PaletteButton('play'.tr(),
              onPressed: item.playItem,
              borderRadius: 4,
              minWidth: 40,
              maxWidth: maxWidth,
              icon: Icon(Icons.play_arrow, color: Colors.black87));
        });
  }
}
