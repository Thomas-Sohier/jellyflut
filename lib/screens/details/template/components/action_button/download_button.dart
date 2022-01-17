part of '../action_button.dart';

class DownloadButton extends StatefulWidget {
  final Item item;
  final double maxWidth;

  const DownloadButton({Key? key, required this.item, this.maxWidth = 150})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DownloadButtonState();
  }
}

class _DownloadButtonState extends State<DownloadButton> {
  late var fToast;
  late final BehaviorSubject<int> percentDownload;
  late final Future<bool> isDownloaded;
  late final DownloadProvider downloadProvider;
  bool buttonEnabled = true;

  @override
  void initState() {
    downloadProvider = DownloadProvider();
    final isItemDownload =
        downloadProvider.isItemDownloadPresent(widget.item.id);
    if (isItemDownload) {
      percentDownload =
          downloadProvider.getItemDownloadProgress(widget.item.id);
      buttonEnabled = false;
    } else {
      percentDownload = BehaviorSubject<int>();
    }
    isDownloaded = FileService.isItemDownloaded(widget.item.id);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO have a better handling of removal of items downloaded (show agan download icon on delete)
    return PaletteButton('download'.tr(), onPressed: () {
      setState(() => buttonEnabled = false);
      downloadProvider
          .downloadItem(widget.item, percentDownload, dialogRedownload)
          .catchError((e) => SnackbarUtil.message(
              'Error while downloading. ${e.toString()}',
              Icons.file_download_off,
              Colors.red))
          .whenComplete(
              () => mounted ? setState(() => buttonEnabled = true) : {});
    },
        minWidth: 40,
        maxWidth: widget.maxWidth,
        borderRadius: 4,
        enabled: buttonEnabled,
        trailing: trailing());
  }

  Widget trailing() {
    return FutureBuilder<bool>(
        future: isDownloaded,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return trailingBuilder(snapshot.data!);
          }
          return const SizedBox();
        });
  }

  Widget trailingBuilder(bool isDownloaded) {
    if (isDownloaded) {
      return Padding(
          padding: const EdgeInsets.only(left: 4),
          child: DownloadAnimation(
              percentDownload: percentDownload,
              child: Icon(Icons.download_done, color: Colors.green.shade900)));
    }
    return Padding(
        padding: const EdgeInsets.only(left: 4),
        child: DownloadAnimation(
            percentDownload: percentDownload,
            child: Icon(Icons.download, color: Colors.black87)));
  }

  Future<bool?> dialogRedownload() async {
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
                          text: widget.item.name,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(fontStyle: FontStyle.italic)),
                      TextSpan(
                          text:
                              ' seems to be already downloaded would you like to downlodad it again ?',
                          style: Theme.of(context).textTheme.bodyText1),
                      TextSpan(text: '\n\n'),
                      TextSpan(
                          text:
                              ' It will overwrite any files with the name ${FileService.getItemStorageName(widget.item)}',
                          style: Theme.of(context).textTheme.bodyText1),
                    ]))),
            actions: [
              CancelButton(onPressed: () => customRouter.pop<bool>(false)),
              DeleteButton(onPressed: () {
                AppDatabase()
                    .getDatabase
                    .downloadsDao
                    .getDownloadById(widget.item.id)
                    .then(downloadProvider.deleteDownloadedFile);
                customRouter.pop<bool>(false);
              }),
              SubmitButton(onPressed: () => customRouter.pop<bool>(true))
            ],
          );
        });
  }
}
