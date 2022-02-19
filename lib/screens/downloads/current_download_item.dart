import 'package:flutter/material.dart';

import 'package:jellyflut/components/critics.dart';
import 'package:jellyflut/components/poster/poster.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/downloads/item_download.dart';
import 'package:jellyflut/models/enum/image_type.dart';
import 'package:jellyflut/providers/downloads/download_provider.dart';
import 'package:jellyflut/routes/router.gr.dart';
import 'package:jellyflut/components/outlined_button_selector.dart';
import 'package:jellyflut/shared/shared.dart';
import 'package:jellyflut/shared/utils/color_util.dart';
import 'package:uuid/uuid.dart';

class CurrentDownloadItem extends StatefulWidget {
  final ItemDownload itemDownload;
  final void Function()? callbackOnDelete;

  const CurrentDownloadItem(
      {Key? key, required this.itemDownload, this.callbackOnDelete})
      : super(key: key);

  @override
  _CurrentDownloadItemState createState() => _CurrentDownloadItemState();
}

class _CurrentDownloadItemState extends State<CurrentDownloadItem>
    with SingleTickerProviderStateMixin {
  // Dpad navigation
  late final FocusNode _node;
  late final String posterHeroTag;

  @override
  void initState() {
    posterHeroTag = Uuid().v4();
    _node = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _node.dispose();
    super.dispose();
  }

  void _onTap(String heroTag) {
    customRouter
        .push(DetailsRoute(item: widget.itemDownload.item, heroTag: heroTag));
  }

  @override
  Widget build(BuildContext context) {
    return epsiodeItem();
  }

  Widget epsiodeItem() {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      final rightPartPadding = constraints.maxWidth < 350
          ? const EdgeInsets.only(left: 0)
          : const EdgeInsets.only(left: 8);
      return Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Flexible(
                  child: OutlinedButtonSelector(
                      onPressed: () => _onTap(posterHeroTag),
                      child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            if (constraints.maxWidth > 350)
                              ConstrainedBox(
                                  constraints: BoxConstraints(
                                      minWidth: 20,
                                      maxWidth: constraints.maxWidth * 0.4),
                                  child: poster()),
                            Expanded(
                              child: Padding(
                                  padding: rightPartPadding,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      title(),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 4, bottom: 4),
                                        child: Row(
                                          children: [
                                            if (widget.itemDownload.item
                                                .hasRatings())
                                              Critics(
                                                item: widget.itemDownload.item,
                                                fontSize: 18,
                                              ),
                                            if (widget.itemDownload.item
                                                    .getDuration() !=
                                                0)
                                              duration()
                                          ],
                                        ),
                                      ),
                                      if (widget.itemDownload.item.overview !=
                                          null)
                                        overview()
                                    ],
                                  )),
                            ),
                          ]))),
              const SizedBox(width: 12),
              Center(child: downloadProgress())
            ],
          ));
    });
  }

  Widget downloadProgress() {
    return StreamBuilder<int>(
        stream: widget.itemDownload.downloadValueWatcher,
        builder: (context, snapshot) {
          return Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: (snapshot.data?.toDouble() ?? 0) / 100,
                backgroundColor:
                    ColorUtil.lighten(Theme.of(context).colorScheme.background),
                color: Colors.green,
              ),
              IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    widget.callbackOnDelete?.call();
                    widget.itemDownload.cancelToken.cancel();
                    DownloadProvider().removeDownload(widget.itemDownload);
                  },
                  color: Colors.green),
            ],
          );
        });
  }

  Widget poster() {
    return AspectRatio(
      aspectRatio: widget.itemDownload.item.getPrimaryAspectRatio(),
      child: Poster(
          key: ValueKey(widget.itemDownload),
          tag: ImageType.PRIMARY,
          heroTag:
              '${widget.itemDownload.item.id}-${Uuid().v1()}-${widget.itemDownload.item.name}',
          clickable: false,
          width: double.infinity,
          height: double.infinity,
          boxFit: BoxFit.cover,
          showParent: false,
          item: widget.itemDownload.item),
    );
  }

  Widget title() {
    final title = widget.itemDownload.item.indexNumber != null
        ? '${widget.itemDownload.item.indexNumber} - ${widget.itemDownload.item.name}'
        : '${widget.itemDownload.item.name}';

    return Flexible(
      child: Text(title,
          textAlign: TextAlign.left,
          maxLines: 2,
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(fontSize: 20, fontWeight: FontWeight.bold)),
    );
  }

  Widget duration() {
    return Flexible(
        child: Text(
            printDuration(
                Duration(microseconds: widget.itemDownload.item.getDuration())),
            maxLines: 1,
            style:
                Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 18)));
  }

  Widget overview() {
    return Flexible(
      child: Text(
        widget.itemDownload.item.overview!,
        textAlign: TextAlign.justify,
        maxLines: 4,
        style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 18),
      ),
    );
  }
}
