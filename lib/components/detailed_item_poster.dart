import 'package:flutter/material.dart';
import 'package:jellyflut/components/async_image.dart';
import 'package:jellyflut/components/poster/item_poster.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/routes/router.gr.dart';
import 'package:jellyflut/shared/shared.dart';
import 'package:jellyflut_models/jellyflut_models.dart';

import 'critics.dart';

class DetailedItemPoster extends StatefulWidget {
  final Item item;
  final Color textColor;
  final String heroTag;

  const DetailedItemPoster({required this.item, required this.textColor, required this.heroTag});

  @override
  State<DetailedItemPoster> createState() => _DetailedItemPosterState();
}

class _DetailedItemPosterState extends State<DetailedItemPoster> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) =>
            Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [
              ItemPoster(widget.item, showOverlay: false, showName: false),
              MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                      onTap: () => customRouter.push(DetailsRoute(item: widget.item, heroTag: widget.heroTag)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(topRight: Radius.circular(4), bottomRight: Radius.circular(4)),
                        child: ConstrainedBox(
                            constraints:
                                BoxConstraints(minWidth: 100, maxWidth: 600, maxHeight: constraints.maxHeight * 0.9),
                            child: Stack(children: [
                              AsyncImage(
                                  item: widget.item,
                                  boxFit: BoxFit.cover,
                                  errorWidget: (_, __, ___) => const SizedBox(),
                                  width: double.infinity,
                                  height: double.infinity,
                                  tag: ImageType.Backdrop),
                              Container(color: Colors.black87),
                              Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        title(),
                                        Row(children: [
                                          Critics(item: widget.item),
                                          Spacer(),
                                          if (widget.item.runTimeTicks != null) duration()
                                        ]),
                                        if (widget.item.overview != null) Divider(),
                                        if (widget.item.overview != null) overview()
                                      ]))
                            ])),
                      )))
            ]));
  }

  Widget title() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: Text(widget.item.name ?? '',
          textAlign: TextAlign.left,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.headline3),
    );
  }

  Widget overview() {
    return Expanded(
        flex: 1,
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Text(removeAllHtmlTags(widget.item.overview!),
                overflow: TextOverflow.clip, style: TextStyle(fontSize: 18))));
  }

  Widget duration() {
    return Text(printDuration(Duration(microseconds: widget.item.getDuration())));
  }
}
