import 'package:auto_route/auto_route.dart';
import 'package:downloads_repository/downloads_repository.dart';
import 'package:flutter/material.dart';

import 'package:jellyflut/components/critics.dart';
import 'package:jellyflut/components/poster/poster.dart';
import 'package:jellyflut/routes/router.gr.dart' as r;
import 'package:jellyflut/components/outlined_button_selector.dart';
import 'package:jellyflut/shared/shared.dart';
import 'package:jellyflut/shared/utils/color_util.dart';
import 'package:jellyflut_models/jellyflut_models.dart';
import 'package:uuid/uuid.dart';

class CurrentDownloadItem extends StatefulWidget {
  final OngoingDownload ongoingDownload;
  final void Function()? callbackOnDelete;

  const CurrentDownloadItem({super.key, required this.ongoingDownload, this.callbackOnDelete});

  @override
  State<CurrentDownloadItem> createState() => _CurrentDownloadItemState();
}

class _CurrentDownloadItemState extends State<CurrentDownloadItem> {
  late final String posterHeroTag;

  @override
  void initState() {
    posterHeroTag = Uuid().v4();
    super.initState();
  }

  void _onTap(String heroTag) {
    context.router.root.push(r.DetailsPage(item: widget.ongoingDownload.item, heroTag: heroTag));
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      final rightPartPadding =
          constraints.maxWidth < 350 ? const EdgeInsets.only(left: 0) : const EdgeInsets.only(left: 8);
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
                                  constraints: BoxConstraints(minWidth: 20, maxWidth: constraints.maxWidth * 0.4),
                                  child: poster()),
                            Expanded(
                              child: Padding(
                                  padding: rightPartPadding,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      title(),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4, bottom: 4),
                                        child: Row(
                                          children: [
                                            if (widget.ongoingDownload.item.hasRatings())
                                              Critics(item: widget.ongoingDownload.item),
                                            if (widget.ongoingDownload.item.getDuration() != 0) duration()
                                          ],
                                        ),
                                      ),
                                      if (widget.ongoingDownload.item.overview != null) overview()
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
        stream: widget.ongoingDownload.stateOfDownload,
        builder: (context, snapshot) {
          return Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: (snapshot.data?.toDouble() ?? 0) / 100,
                backgroundColor: ColorUtil.lighten(Theme.of(context).colorScheme.background),
                color: Colors.green,
              ),
              IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    widget.callbackOnDelete?.call();
                  },
                  color: Colors.green),
            ],
          );
        });
  }

  Widget poster() {
    return AspectRatio(
      aspectRatio: widget.ongoingDownload.item.getPrimaryAspectRatio(),
      child: Poster(
          key: ValueKey(widget.ongoingDownload),
          imageType: ImageType.Primary,
          heroTag: '${widget.ongoingDownload.item.id}-${Uuid().v1()}-${widget.ongoingDownload.item.name}',
          clickable: false,
          width: double.infinity,
          height: double.infinity,
          boxFit: BoxFit.cover,
          showParent: false,
          item: widget.ongoingDownload.item),
    );
  }

  Widget title() {
    final title = widget.ongoingDownload.item.indexNumber != null
        ? '${widget.ongoingDownload.item.indexNumber} - ${widget.ongoingDownload.item.name}'
        : widget.ongoingDownload.item.name;

    return Flexible(
      child: Text(title ?? '',
          textAlign: TextAlign.left,
          maxLines: 2,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 20, fontWeight: FontWeight.bold)),
    );
  }

  Widget duration() {
    return Flexible(
        child: Text(printDuration(Duration(microseconds: widget.ongoingDownload.item.getDuration())),
            maxLines: 1, style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 18)));
  }

  Widget overview() {
    return Flexible(
      child: Text(
        widget.ongoingDownload.item.overview!,
        textAlign: TextAlign.justify,
        maxLines: 4,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 18),
      ),
    );
  }
}
