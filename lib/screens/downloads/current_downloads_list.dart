import 'package:flutter/material.dart';
import 'package:jellyflut/screens/downloads/current_download_item.dart';
import 'package:jellyflut_models/jellyflut_models.dart';

class CurrentDownloadList extends StatefulWidget {
  CurrentDownloadList({super.key});

  @override
  State<CurrentDownloadList> createState() => _CurrentDownloadListState();
}

class _CurrentDownloadListState extends State<CurrentDownloadList> {
  late final ScrollController scrollController;
  late final GlobalKey<AnimatedListState> _key;

  @override
  void initState() {
    super.initState();
    _key = GlobalKey();
    scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    // TOOD finish download page
    return const SizedBox();
    // return AnimatedList(
    //     key: _key,
    //     controller: scrollController,
    //     initialItemCount: _listLength > 0 ? _listLength - 1 : 0, // why ? i don't know
    //     scrollDirection: Axis.vertical,
    //     itemBuilder: (c, i, a) {
    //       final download = _downloadProvider.getDownloads.elementAt(i);
    //       return _buildItem(download, a, i);
    //     });

    // return Center(
    //     child: Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         crossAxisAlignment: CrossAxisAlignment.center,
    //         children: [Icon(Icons.download), Text('empty_collection'.tr())]));
  }

  Widget _buildItem(ItemDownload download, Animation<double> animation, int index) {
    return SizeTransition(
      sizeFactor: animation,
      child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 200),
          child: CurrentDownloadItem(itemDownload: download, callbackOnDelete: () => _removeItem(download))),
    );
  }

  void _removeItem(ItemDownload download) {
    // final i = _downloadsList.toList().indexOf(download);
    // _downloadsList.remove(download);
    // _key.currentState?.removeItem(i, _itemBuilder(download, i), duration: Duration(milliseconds: 400));
  }

  void _insertItem(ItemDownload download) {
    // _downloadsList.add(download);
    // final i = _downloadsList.toList().indexOf(download);
    // _key.currentState?.insertItem(i, duration: Duration(milliseconds: 400));
  }

  AnimatedListRemovedItemBuilder _itemBuilder(ItemDownload download, int index) {
    return (context, animation) {
      return _buildItem(download, animation, index);
    };
  }
}
