part of '../action_button.dart';

class DownloadButton extends StatelessWidget {
  final double maxWidth;
  final buttonEnable = ValueNotifier(true);

  DownloadButton({super.key, this.maxWidth = 150});

  @override
  Widget build(BuildContext context) {
    // TODO have a better handling of removal of items downloaded (show agan download icon on delete)
    final item = context.read<DetailsBloc>().state.item;
    return ValueListenableBuilder<bool>(
        valueListenable: buttonEnable,
        builder: (_, value, __) => PaletteButton(
              'download'.tr(),
              minWidth: 40,
              maxWidth: maxWidth,
              borderRadius: 4,
              enabled: value,
              trailing: trailing(context),
              onPressed: () => downloadItem(context, item),
            ));
  }

  Future<void> downloadItem(BuildContext context, Item item) async {
    buttonEnable.value = false;
    try {
      final fileBytes = await context.read<DownloadsRepository>().downloadItem(itemId: item.id);
      final file = await context.read<DownloadsRepository>().saveFile(bytes: fileBytes, item: item);
      SnackbarUtil.message(
          messageTitle: 'File "${item.name}" has been successfully downloaded',
          messageDetails: 'Path : ${file.path}',
          icon: Icons.download_done,
          context: context);
    } catch (e) {
      SnackbarUtil.message(
          messageTitle: 'Error while downloading file : "${item.name}"',
          messageDetails: e.toString(),
          icon: Icons.file_download_off,
          context: context);
    }
    buttonEnable.value = true;
  }

  Widget trailing(BuildContext context) {
    return Padding(padding: const EdgeInsets.only(left: 4), child: trailingBuilder(context));
  }

  Widget trailingBuilder(BuildContext context) {
    final item = context.read<DetailsBloc>().state.item;
    final isDownloadedFuture = context.read<DownloadsRepository>().isItemDownloaded(item.id);
    return FutureBuilder<bool>(
      future: isDownloadedFuture,
      initialData: false,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData && snapshot.data) {
          return Padding(
              padding: const EdgeInsets.only(left: 4), child: Icon(Icons.download_done, color: Colors.green.shade900));
        }
        return Padding(padding: const EdgeInsets.only(left: 4), child: Icon(Icons.download, color: Colors.black87));
      },
    );
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
                          style: Theme.of(context).textTheme.bodyText1?.copyWith(fontStyle: FontStyle.italic)),
                      TextSpan(
                          text: ' seems to be already downloaded would you like to downlodad it again ?',
                          style: Theme.of(context).textTheme.bodyText1),
                      TextSpan(text: '\n\n'),
                      TextSpan(
                          text:
                              ' It will overwrite any files with the name ${FileService.getItemStorageName(state.item)}',
                          style: Theme.of(context).textTheme.bodyText1),
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
