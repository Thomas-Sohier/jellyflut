import 'package:flutter/material.dart';

import 'package:jellyflut/globals.dart';
import 'package:jellyflut/routes/router.gr.dart';
import 'package:jellyflut/screens/details/template/components/items_collection/outlined_button_selector.dart';

class DownloadButton extends StatefulWidget {
  @override
  _DownloadButtonState createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<DownloadButton> {
  @override
  Widget build(BuildContext context) {
    return OutlinedButtonSelector(
        shape: CircleBorder(),
        padding: EdgeInsets.all(8),
        onPressed: () => customRouter.push(DownloadsRoute()),
        child: Icon(
          Icons.download_for_offline_outlined,
          size: 26,
          color: Theme.of(context).colorScheme.onBackground,
        ));
  }
}
