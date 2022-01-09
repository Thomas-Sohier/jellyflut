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
  bool buttonEnabled = true;

  @override
  void initState() {
    fToast = FToast();
    // ignore: unnecessary_this
    fToast.init(this.context);
    percentDownload = BehaviorSubject<int>();
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
        await FileService.downloadFileAndSaveToPath(downloadUrl, downloadPath,
                stateOfDownload: percentDownload)
            .then((_) => message('File saved at $downloadPath',
                Icons.file_download_done, Colors.green))
            .then((_) => saveDownloadToDatabase(downloadPath))
            .whenComplete(() => setState(() => buttonEnabled = true));
      } else {
        message('Do not have enough permission to download file',
            Icons.file_download_off, Colors.red);
      }
    } catch (e) {
      log(e.toString());
      message(e.toString(), Icons.file_download_off, Colors.red);
    }
    setState(() => buttonEnabled = true);
  }

  void saveDownloadToDatabase(String path) {
    final i = widget.item;
    final db = AppDatabase().getDatabase;
    final dc = DownloadsCompanion(
        id: Value(i.id),
        name: Value.ofNullable(i.name),
        item: Value.ofNullable(i.toMap()),
        path: Value.ofNullable(path));
    db.downloadsDao.createDownload(dc);
  }

  void message(String message, IconData icon, Color color) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
          content: Row(children: [
            Flexible(child: Text(message)),
            Icon(icon, color: color)
          ]),
          width: 600));
  }
}
