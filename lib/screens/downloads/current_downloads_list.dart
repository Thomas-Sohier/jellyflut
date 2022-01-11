import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut/models/downloads/item_download.dart';
import 'package:jellyflut/providers/downloads/download_provider.dart';
import 'package:jellyflut/screens/downloads/current_download_item.dart';
import 'package:provider/provider.dart';

class CurrentDownloadList extends StatefulWidget {
  CurrentDownloadList({Key? key}) : super(key: key);

  @override
  _CurrentDownloadListState createState() => _CurrentDownloadListState();
}

class _CurrentDownloadListState extends State<CurrentDownloadList> {
  late final ScrollController scrollController;
  late final DownloadProvider _downloadProvider;
  late final Set<ItemDownload> _downloadsList;
  late final int _listLength;
  late final GlobalKey<AnimatedListState> _key;
  late final StreamSubscription<DownloadEvent> sub;

  @override
  void initState() {
    super.initState();
    _key = GlobalKey();
    scrollController = ScrollController();
    _downloadProvider = DownloadProvider();
    _listLength = _downloadProvider.getDownloads.length;
    _downloadsList = Set<ItemDownload>.from(_downloadProvider.getDownloads);
    sub = _downloadProvider.addedDownloadsStream.stream.listen((d) {});
    sub.onData(_listenToDownloadStream);
  }

  @override
  void dispose() {
    sub.cancel();
    super.dispose();
  }

  void _listenToDownloadStream(DownloadEvent d) {
    switch (d.eventType) {
      case DownloadEventType.ADDED:
        _insertItem(d.download);
        break;
      case DownloadEventType.DELETED:
        _removeItem(d.download);
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Consumer<DownloadProvider>(builder: (c, dp, _) => builder()));
  }

  Widget builder() {
    if (_downloadsList.isNotEmpty) {
      return AnimatedList(
          key: _key,
          shrinkWrap: true,
          controller: scrollController,
          initialItemCount:
              _listLength > 0 ? _listLength - 1 : 0, // why ? i don't know
          scrollDirection: Axis.vertical,
          itemBuilder: (c, i, a) {
            final download = _downloadProvider.getDownloads.elementAt(i);
            return _buildItem(download, a, i);
          });
    }
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [Icon(Icons.download), Text('empty_collection'.tr())]));
  }

  Widget _buildItem(
      ItemDownload download, Animation<double> animation, int index) {
    return SizeTransition(
      sizeFactor: animation,
      child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 200),
          child: CurrentDownloadItem(
              itemDownload: download,
              callbackOnDelete: () => _removeItem(download))),
    );
  }

  void _removeItem(ItemDownload download) {
    final i = _downloadsList.toList().indexOf(download);
    _downloadsList.remove(download);
    _key.currentState?.removeItem(i, _itemBuilder(download, i),
        duration: Duration(milliseconds: 400));
  }

  void _insertItem(ItemDownload download) {
    _downloadsList.add(download);
    final i = _downloadsList.toList().indexOf(download);
    _key.currentState?.insertItem(i, duration: Duration(milliseconds: 400));
  }

  AnimatedListRemovedItemBuilder _itemBuilder(
      ItemDownload download, int index) {
    return (context, animation) {
      return _buildItem(download, animation, index);
    };
  }
}
