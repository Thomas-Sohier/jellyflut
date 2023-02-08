part of '../action_button.dart';

class DownloadButton extends StatelessWidget {
  final double maxWidth;
  final buttonEnable = ValueNotifier(true);

  DownloadButton({super.key, this.maxWidth = 150});

  @override
  Widget build(BuildContext context) {
    // TODO have a better handling of removal of items downloaded (show agan download icon on delete)
    final item = context.read<DetailsBloc>().state.item;
    return BlocBuilder<DetailsDownloadCubit, DetailsDownloadState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (_, state) => PaletteButton(
              'download'.tr(),
              minWidth: 40,
              maxWidth: maxWidth,
              borderRadius: 4,
              enabled: !state.status.isDownloading,
              trailing: const _DownloadTrailingState(),
              onPressed: () => downloadItem(context, item),
            ));
  }

  Future<void> downloadItem(BuildContext context, Item item) async {
    final navigatorKey = context.router.navigatorKey;
    try {
      final file = await context.read<DetailsDownloadCubit>().downloadItem();
      SnackbarUtil.message(
          messageTitle: 'File "${item.name}" successfully downloaded',
          messageDetails: 'Path : ${file.path}',
          icon: Icons.download_done,
          context: navigatorKey.currentContext ?? context);
    } catch (e) {
      SnackbarUtil.message(
          messageTitle: 'Error while downloading file : "${item.name}"',
          messageDetails: e.toString(),
          icon: Icons.file_download_off,
          context: navigatorKey.currentContext ?? context);
    }
  }

  Future<bool?> dialogRedownload(BuildContext context) async {
    final state = context.read<DetailsBloc>().state;
    return showDialog<bool?>(
        context: context,
        barrierDismissible: false,
        useSafeArea: true,
        builder: (c) {
          return AlertDialog(
            title: Text('Overwrite file ?'),
            actionsAlignment: MainAxisAlignment.end,
            content: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 600),
                child: RichText(
                    textAlign: TextAlign.left,
                    text: TextSpan(children: <TextSpan>[
                      TextSpan(
                          text: state.item.name,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontStyle: FontStyle.italic)),
                      TextSpan(
                          text: ' seems to be already downloaded would you like to downlodad it again ?',
                          style: Theme.of(context).textTheme.bodyLarge),
                      TextSpan(text: '\n\n'),
                      TextSpan(
                          text:
                              ' It will overwrite any files with the name ${FileService.getItemStorageName(state.item)}',
                          style: Theme.of(context).textTheme.bodyLarge),
                    ]))),
            actions: [
              TextButton(onPressed: () => context.router.root.pop<bool>(false), child: Text('cancel'.tr())),
              TextButton(
                  onPressed: () {
                    // AppDatabase()
                    //     .getDatabase
                    //     .downloadsDao
                    //     .getDownloadById(state.item.id)
                    //     .then(downloadProvider.deleteDownloadedFile);
                    // context.router.root.pop<bool>(false);
                  },
                  child: Text('delete'.tr())),
              TextButton(onPressed: () => context.router.root.pop<bool>(true), child: Text('download'.tr()))
            ],
          );
        });
  }
}

class _DownloadTrailingState extends StatelessWidget {
  const _DownloadTrailingState();

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.only(left: 4), child: trailingBuilder(context));
  }

  Widget trailingBuilder(BuildContext context) {
    return BlocBuilder<DetailsDownloadCubit, DetailsDownloadState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (_, state) {
          switch (state.status) {
            case DownloadStatus.downloading:
              return const _DownloadingProgressIcon();
            case DownloadStatus.downloaded:
              return const _DownloadedIcon();
            case DownloadStatus.initial:
            case DownloadStatus.notDownloaded:
            default:
              return const _DownloadIcon();
          }
        });
  }
}

class _DownloadedIcon extends StatelessWidget {
  const _DownloadedIcon();

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 4), child: Icon(Icons.download_done, color: Colors.green.shade900));
  }
}

class _DownloadIcon extends StatelessWidget {
  const _DownloadIcon();

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.only(left: 4), child: Icon(Icons.download, color: Colors.black87));
  }
}

class _DownloadingProgressIcon extends StatelessWidget {
  const _DownloadingProgressIcon();

  @override
  Widget build(BuildContext context) {
    final state = context.read<DetailsDownloadCubit>().state;
    return Padding(
        padding: const EdgeInsets.only(left: 4, top: 8, bottom: 8),
        child: AspectRatio(
          aspectRatio: 1,
          child: StreamBuilder<int>(
              stream: state.stateOfDownload,
              builder: (_, snapshot) {
                final progress = snapshot.hasData ? (snapshot.data! / 100) : 0.0;
                return CircularProgressIndicator(
                  color: Colors.green.shade700,
                  value: progress == 1 ? null : progress, // If at 100% we show undeterminate progress indicator
                  backgroundColor: Colors.transparent.withOpacity(0.4),
                  strokeWidth: 6,
                );
              }),
        ));
  }
}
