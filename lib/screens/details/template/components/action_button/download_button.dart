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
    return PaletteButton('download'.tr(),
        onPressed: downloadItem,
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

  void downloadItem() async {
    try {
      setState(() => buttonEnabled = false);
      final downloadUrl = FileService.getDownloadFileUrl(widget.item.id);
      final canDownload = await FileService.requestStorage();
      final downloadPath = await FileService.getStoragePathItem(widget.item);

      if (canDownload) {
        final fileExist = await FileService.isItemDownloaded(widget.item.id);

        // If file seems to already exist we show a dialog to warn user about possible overwriting of current file
        if (fileExist) {
          final shouldOverwrite = await dialogRedownload();
          if (shouldOverwrite == false) {
            return setState(() => buttonEnabled = true);
          }
        }

        // Add download to provider to keep track of it
        final cancelToken = CancelToken();
        final itemDownload = ItemDownload(
            item: widget.item,
            downloadValueWatcher: percentDownload,
            cancelToken: cancelToken);

        await DownloadProvider().addDownload(
            context: customRouter.navigatorKey.currentContext,
            download: itemDownload,
            downloadPath: downloadPath,
            downloadUrl: downloadUrl,
            callback: () {
              if (mounted) setState(() => buttonEnabled = true);
            },
            percentDownload: percentDownload);
      } else {
        SnackbarUtil.message(
            context,
            'Do not have enough permission to download file',
            Icons.file_download_off,
            Colors.red);
      }
    } catch (e) {
      if (mounted) {
        log(e.toString());
        SnackbarUtil.message(customRouter.navigatorKey.currentContext,
            e.toString(), Icons.file_download_off, Colors.red);
      }
    }
    if (mounted) {
      setState(() => buttonEnabled = true);
    }
  }

  Future<bool?> dialogRedownload() async {
    return showDialog<bool>(
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
              SubmitButton(onPressed: () => customRouter.pop<bool>(true))
            ],
          );
        });
  }
}
