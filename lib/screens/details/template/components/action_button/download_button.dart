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

  @override
  void initState() {
    fToast = FToast();
    // ignore: unnecessary_this
    fToast.init(this.context);
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
        icon: Icon(Icons.download, color: Colors.black87));
  }

  void downloadItem() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
          content: Row(children: [
            Text('functionnality_not_implemented'.tr()),
            Spacer(),
            Icon(Icons.file_download_off, color: Colors.red)
          ]),
          width: 600));
  }
}
