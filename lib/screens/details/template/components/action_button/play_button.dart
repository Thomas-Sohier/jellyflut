part of '../action_button.dart';

class PlayButton extends StatelessWidget {
  final double maxWidth;

  const PlayButton({super.key, this.maxWidth = 150});

  @override
  Widget build(BuildContext context) {
    return PaletteButton(
      'play'.tr(),
      onPressed: () => context.router.push(r.StreamPage(item: context.read<DetailsBloc>().state.item)),
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
}
