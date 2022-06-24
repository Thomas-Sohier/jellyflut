import 'package:flutter/material.dart';

import 'package:jellyflut/components/critics.dart';
import 'package:jellyflut/components/poster/poster.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/mixins/absorb_action.dart';
import 'package:jellyflut/routes/router.gr.dart';
import 'package:jellyflut/components/outlined_button_selector.dart';
import 'package:jellyflut/shared/shared.dart';
import 'package:jellyflut_models/jellyflut_models.dart';
import 'package:uuid/uuid.dart';

class EpisodeItem extends StatefulWidget {
  final bool clickable;
  final Item item;
  final BoxFit boxFit;
  final Widget Function(BuildContext)? placeholder;

  const EpisodeItem(
      {super.key,
      required this.item,
      this.placeholder,
      this.clickable = true,
      this.boxFit = BoxFit.cover});

  @override
  State<EpisodeItem> createState() => _EpisodeItemState();
}

class _EpisodeItemState extends State<EpisodeItem> with AbsordAction {
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

  Future<void> _onTap() {
    return customRouter
        .push(DetailsRoute(item: widget.item, heroTag: posterHeroTag));
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButtonSelector(
        onPressed: () => action(_onTap), child: epsiodeItem());
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
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (constraints.maxWidth > 350)
              ConstrainedBox(
                  constraints: BoxConstraints(
                      minWidth: 20, maxWidth: constraints.maxWidth * 0.4),
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
                            if (widget.item.hasRatings())
                              Critics(item: widget.item),
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
      );
    });
  }

  Widget poster() {
    return AspectRatio(
      aspectRatio: widget.item.getPrimaryAspectRatio(),
      child: Poster(
          key: ValueKey(widget.item),
          tag: ImageType.PRIMARY,
          heroTag: posterHeroTag,
          clickable: false,
          placeholder: widget.placeholder,
          width: double.infinity,
          height: double.infinity,
          boxFit: widget.boxFit,
          item: widget.item),
    );
  }

  Widget title() {
    final title = widget.item.indexNumber != null
        ? '${widget.item.indexNumber} - ${widget.item.name}'
        : widget.item.name;
    final style = Theme.of(context)
        .textTheme
        .bodyText1!
        .copyWith(fontWeight: FontWeight.bold)
        .apply(fontSizeFactor: 1.2);

    return Text(title,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.left,
        maxLines: 2,
        style: style);
  }

  Widget duration() {
    return Flexible(
        child: Text(
            printDuration(Duration(microseconds: widget.item.getDuration())),
            maxLines: 1,
            style:
                Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 18)));
  }

  Widget overview() {
    return Flexible(
      child: Text(
        widget.item.overview!,
        textAlign: TextAlign.justify,
        style: Theme.of(context).textTheme.bodyText2!,
      ),
    );
  }
}
