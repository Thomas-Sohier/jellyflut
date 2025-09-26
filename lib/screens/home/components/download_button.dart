import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:jellyflut/components/outlined_button_selector.dart';
import 'package:jellyflut/routes/router.dart';

class DownloadButton extends StatelessWidget {
  const DownloadButton({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButtonSelector(
      shape: CircleBorder(),
      padding: EdgeInsets.all(8),
      onPressed: () => context.router.root.push(DownloadsRoute()),
      child: Icon(Icons.download_for_offline_outlined, size: 26, color: Theme.of(context).colorScheme.onSurface),
    );
  }
}
