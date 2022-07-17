part of '../action_button.dart';

class TrailerButton extends StatelessWidget {
  final double maxWidth;

  @override
  const TrailerButton({super.key, this.maxWidth = 150});

  @override
  Widget build(BuildContext context) {
    return PaletteButton('trailer'.tr(),
        onPressed: () => trailersDialog(context),
        minWidth: 40,
        maxWidth: maxWidth,
        borderRadius: 4,
        icon: Icon(Icons.movie, color: Colors.black87));
  }

  void playTrailer(BuildContext context, MediaUrl trailer) async {
    final state = context.read<DetailsBloc>().state;
    try {
      final url = await state.item.getYoutubeTrailerUrl(trailer);
      await context.router.root.push(r.StreamPage(url: url.toString(), item: state.item));
    } catch (exception) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
            content: Row(
                children: [Flexible(child: Text(exception.toString())), Icon(Icons.play_disabled, color: Colors.red)]),
            width: 600));
    }
  }

  void trailersDialog(BuildContext context) {
    final state = context.read<DetailsBloc>().state;
    final trailers = state.item.remoteTrailers;
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (_) {
          return Theme(
              data: state.theme,
              child: Builder(
                  // Create an inner BuildContext so that we can refer to
                  // the Theme with Theme.of().
                  builder: (BuildContext dialogContext) => AlertDialog(
                        title: Text('trailer'.tr()),
                        titlePadding: const EdgeInsets.only(left: 8, top: 16, bottom: 12),
                        contentPadding: const EdgeInsets.all(0),
                        actions: [TextButton(onPressed: context.router.root.pop, child: Text('cancel'.tr()))],
                        content: Container(
                          decoration: BoxDecoration(
                            border: Border.symmetric(horizontal: BorderSide(width: 1)),
                          ),
                          width: 600,
                          height: 200,
                          child: ListView.builder(
                              itemCount: trailers.length,
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              itemBuilder: (_, index) {
                                return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4),
                                    child: TrailerDialogButton(
                                        playTrailer: playTrailer, theme: state.theme, trailer: trailers[index]));
                              }),
                        ),
                      )));
        });
  }
}

class TrailerDialogButton extends StatelessWidget {
  final void Function(BuildContext, MediaUrl) playTrailer;
  final ThemeData theme;
  final MediaUrl trailer;

  const TrailerDialogButton({super.key, required this.playTrailer, required this.theme, required this.trailer});

  @override
  Widget build(BuildContext context) {
    return OutlinedButtonSelector(
      onPressed: () => playTrailer(context, trailer),
      padding: const EdgeInsets.only(left: 2, top: 4, bottom: 4),
      primary: theme.colorScheme.onBackground,
      child: Row(
        children: [
          const Icon(Icons.camera_roll_outlined),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(trailer.name ?? '',
                    maxLines: 2, style: theme.textTheme.bodyText1, overflow: TextOverflow.ellipsis),
                Text(trailer.url ?? '',
                    style: TextStyle(color: theme.colorScheme.secondary), overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
