import 'package:downloads_repository/downloads_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/screens/downloads/current_download_item.dart';

class CurrentDownloadList extends StatefulWidget {
  CurrentDownloadList({super.key});

  @override
  State<CurrentDownloadList> createState() => _CurrentDownloadListState();
}

class _CurrentDownloadListState extends State<CurrentDownloadList> {
  late final GlobalKey<AnimatedListState> _key;

  @override
  void initState() {
    super.initState();
    _key = GlobalKey();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<OngoingDownload>>(
      stream: context.read<DownloadsRepository>().getOnGoingsDownloads(),
      initialData: const [],
      builder: (_, snapshot) {
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          final downloads = snapshot.data!;
          return AnimatedList(
              key: _key,
              controller: ScrollController(),
              initialItemCount: downloads.isNotEmpty ? downloads.length - 1 : 0, // why ? i don't know
              scrollDirection: Axis.vertical,
              itemBuilder: (_, i, a) {
                final download = downloads.elementAt(i);
                return _buildItem(download, a, i);
              });
        }
        return Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [Icon(Icons.download), Text('empty_collection'.tr())]));
      },
    );
  }

  Widget _buildItem(OngoingDownload download, Animation<double> animation, int index) {
    return SizeTransition(
      sizeFactor: animation,
      child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 200),
          child: CurrentDownloadItem(ongoingDownload: download, callbackOnDelete: () => _removeItem(download))),
    );
  }

  Future<void> _removeItem(OngoingDownload download) async {
    final index = context.read<DownloadsRepository>().removeOngoingDownload(download);
    _key.currentState?.removeItem(index, _itemBuilder(download, index), duration: Duration(milliseconds: 400));
  }

  AnimatedRemovedItemBuilder _itemBuilder(OngoingDownload download, int index) {
    return (context, animation) {
      return _buildItem(download, animation, index);
    };
  }
}
