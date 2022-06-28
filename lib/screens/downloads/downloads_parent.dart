import 'package:flutter/material.dart';
import 'package:jellyflut/screens/downloads/current_downloads_list.dart';
import 'package:jellyflut/screens/downloads/downloaded_items.dart';

class DownloadsParent extends StatefulWidget {
  DownloadsParent({super.key});

  @override
  State<DownloadsParent> createState() => _DownloadsParentState();
}

class _DownloadsParentState extends State<DownloadsParent> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            extendBodyBehindAppBar: false,
            appBar: AppBar(
                bottom: const TabBar(
              tabs: [Tab(text: 'Saved items'), Tab(text: 'Active downloads')],
            )),
            body: TabBarView(
              children: [DownloadedItemsPage(), CurrentDownloadList()],
            )));
  }
}
