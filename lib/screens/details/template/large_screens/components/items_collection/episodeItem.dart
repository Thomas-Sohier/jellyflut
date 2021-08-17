import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/components/critics.dart';
import 'package:jellyflut/components/poster/itemPoster.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/routes/router.gr.dart';
import 'package:jellyflut/screens/details/template/large_screens/components/items_collection/outlinedButtonSelector.dart';
import 'package:jellyflut/shared/shared.dart';
import 'package:uuid/uuid.dart';

class EpisodeItem extends StatefulWidget {
  final bool clickable;
  final Item item;

  const EpisodeItem({Key? key, required this.item, this.clickable = true})
      : super(key: key);

  @override
  _EpisodeItemState createState() => _EpisodeItemState();
}

class _EpisodeItemState extends State<EpisodeItem>
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
    customRouter.push(DetailsRoute(item: widget.item, heroTag: heroTag));
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButtonSelector(
        node: _node,
        onPressed: () => _onTap(posterHeroTag),
        child: epsiodeItem());
  }

  Widget epsiodeItem() {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 120, maxHeight: 160),
      child: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10, left: 2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ItemPoster(
              widget.item,
              boxFit: BoxFit.cover,
              widgetAspectRatio: 16 / 9,
              clickable: false,
              showLogo: false,
              showParent: false,
              showName: false,
            ),
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      title(),
                      Padding(
                        padding: const EdgeInsets.only(top: 4, bottom: 4),
                        child: Row(
                          children: [
                            if (widget.item.hasRatings())
                              Critics(
                                item: widget.item,
                                fontSize: 18,
                              ),
                            if (widget.item.getDuration() != 0) duration()
                          ],
                        ),
                      ),
                      if (widget.item.overview != null) overview()
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }

  Widget title() {
    return Text('${widget.item.indexNumber} - ${widget.item.name}',
        textAlign: TextAlign.left,
        style: Theme.of(context)
            .textTheme
            .bodyText1!
            .copyWith(fontSize: 20, fontWeight: FontWeight.bold));
  }

  Widget duration() {
    return Text(
        printDuration(Duration(microseconds: widget.item.getDuration())),
        style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 18));
  }

  Widget overview() {
    return Expanded(
      child: Text(widget.item.overview!,
          textAlign: TextAlign.justify,
          style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 18)),
    );
  }
}
