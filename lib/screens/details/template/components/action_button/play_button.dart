part of '../action_button.dart';

class PlayButton extends StatelessWidget {
  final double maxWidth;

  const PlayButton({super.key, this.maxWidth = 150});

  @override
  Widget build(BuildContext context) {
    return PaletteButton(
      'play'.tr(),
      onPressed: () => _ontap(context),
      borderRadius: 4,
      minWidth: 40,
      maxWidth: maxWidth,
      icon: Icon(Icons.play_arrow, color: Colors.black87),
      gradient: [
        ownDetailsTheme(context).primary,
        ownDetailsTheme(context).secondary,
        ownDetailsTheme(context).tertiary
      ],
    );
  }

  void _ontap(BuildContext context) {
    final item = context.read<DetailsBloc>().state.item;
    switch (item.type) {
      case ItemType.MusicAlbum:
        context.read<MusicPlayerBloc>().add(PlayPlaylistRequested(item: item));
        break;
      case ItemType.Audio:
      case ItemType.AudioBook:
        context.read<MusicPlayerBloc>().add(PlaySongRequested(item: item));
        break;
      case ItemType.Book:
        context.router.push(r.EpubPage(item: item));
        break;
      default:
        context.router.push(r.StreamPage(item: item));
    }
  }
}
