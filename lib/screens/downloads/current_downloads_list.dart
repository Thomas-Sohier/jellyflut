import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  late final int _listLength;
  late final GlobalKey<AnimatedListState> _key;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    _downloadProvider = DownloadProvider();
    _listLength = _downloadProvider.getDownloads.length;
    _key = GlobalKey();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Consumer<DownloadProvider>(builder: (c, dp, _) => builder()));
  }

  Widget builder() {
    return Consumer<DownloadProvider>(
        builder: (context, carrousselProvider, child) {
      if (_downloadProvider.getDownloads.isNotEmpty) {
        return AnimatedList(
            key: _key,
            shrinkWrap: true,
            controller: scrollController,
            initialItemCount: _listLength,
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
    });
  }

  Widget _buildItem(
      ItemDownload download, Animation<double> animation, int index) {
    return SlideTransition(
      position: animation.drive(
          Tween(begin: Offset(2, 0.0), end: Offset(0.0, 0.0))
              .chain(CurveTween(curve: Curves.elasticInOut))),
      child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 200),
          child: CurrentDownloadItem(
              itemDownload: download,
              callbackOnDelete: () => _removeItem(index))),
    );
  }

  void _removeItem(int index) {
    final download = _downloadProvider.getDownloads.elementAt(index);
    final AnimatedListRemovedItemBuilder builder = (context, animation) {
      return _buildItem(download, animation, index);
    };
    _key.currentState
        ?.removeItem(index, builder, duration: Duration(seconds: 2));
  }
}
