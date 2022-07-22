part of '../action_button.dart';

class DownloadButton extends StatefulWidget {
  final double maxWidth;

  const DownloadButton({super.key, this.maxWidth = 150});

  @override
  State<StatefulWidget> createState() {
    return _DownloadButtonState();
  }
}

class _DownloadButtonState extends State<DownloadButton> {
  bool buttonEnabled = true;

  @override
  void initState() {
    final state = context.read<DetailsBloc>().state;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO have a better handling of removal of items downloaded (show agan download icon on delete)
    final state = context.read<DetailsBloc>().state;
    return PaletteButton('download'.tr(),
        minWidth: 40,
        maxWidth: widget.maxWidth,
        borderRadius: 4,
        enabled: buttonEnabled,
        trailing: trailing(),
        onPressed: () => SnackbarUtil.message(
            messageTitle: 'Downloads are being reworked', icon: Icons.construction, context: context));
  }

  Widget trailing() {
    return Padding(padding: const EdgeInsets.only(left: 4), child: Icon(Icons.download, color: Colors.black87));
  }

  Widget trailingBuilder(bool isDownloaded) {
    return const SizedBox();
    // if (isDownloaded) {
    //   return Padding(
    //       padding: const EdgeInsets.only(left: 4),
    //       child: DownloadAnimation(
    //           percentDownload: percentDownload, child: Icon(Icons.download_done, color: Colors.green.shade900)));
    // }
    // return Padding(
    //     padding: const EdgeInsets.only(left: 4),
    //     child: DownloadAnimation(percentDownload: percentDownload, child: Icon(Icons.download, color: Colors.black87)));
  }

  Future<bool?> dialogRedownload() async {
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
