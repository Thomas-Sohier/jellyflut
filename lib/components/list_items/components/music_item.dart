import 'package:flutter/material.dart';

import 'package:jellyflut/components/fav_button.dart';
import 'package:jellyflut/components/poster/poster.dart';
import 'package:jellyflut/models/enum/image_type.dart';
import 'package:jellyflut/models/enum/item_type.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/components/outlined_button_selector.dart';
import 'package:jellyflut/shared/shared.dart';
import 'package:uuid/uuid.dart';

class MusicItem extends StatefulWidget {
  final Item item;
  MusicItem({super.key, required this.item});

  @override
  _MusicItemState createState() => _MusicItemState();
}

class _MusicItemState extends State<MusicItem> {
  void _onTap() {
    widget.item.playItem();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      final rightPartPadding = constraints.maxWidth < 350
          ? const EdgeInsets.only(left: 0)
          : const EdgeInsets.only(left: 8);
      return Padding(
          padding: const EdgeInsets.all(10),
          child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Expanded(
              child: OutlinedButtonSelector(
                  onPressed: _onTap,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if (constraints.maxWidth > 350)
                        Flexible(flex: 3, child: poster()),
                      Expanded(
                        flex: 6,
                        child: Padding(
                            padding: rightPartPadding,
                            child: listItem(widget.item)),
                      ),
                    ],
                  )),
            ),
            FavButton(
              widget.item,
              color: Colors.red.shade800,
              backgroundFocusColor: Colors.white10,
            ),
          ]));
    });
  }

  Widget listItem(Item item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (item.indexNumber != null) Text(item.indexNumber.toString()),
        title(),
        artists(),
        SizedBox(
          height: 12,
        ),
        duration(),
        titlesInAlbum()
      ],
    );
  }

  Widget poster() {
    return AspectRatio(
      aspectRatio: widget.item.primaryImageAspectRatio ?? 1,
      child: Poster(
          key: ValueKey(widget.item),
          tag: ImageType.PRIMARY,
          heroTag: '${widget.item.id}-${Uuid().v1()}-${widget.item.name}',
          clickable: false,
          dropShadow: false,
          width: double.infinity,
          height: double.infinity,
          boxFit: BoxFit.cover,
          item: widget.item),
    );
  }

  Widget duration() {
    return Row(
      children: [
        Text(printDuration(Duration(microseconds: widget.item.getDuration())),
            style:
                Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 16))
      ],
    );
  }

  Widget titlesInAlbum() {
    if (widget.item.type == ItemType.MUSICALBUM) {
      final numberOfTitle = widget.item.childCount ?? 0;
      return Row(
        children: [
          Text('Contains $numberOfTitle titles',
              style:
                  Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 16))
        ],
      );
    }
    return const SizedBox();
  }

  Widget artists() {
    if (widget.item.hasArtists()) {
      return Row(
        children: [
          Text(widget.item.concatenateArtists().toString(),
              style:
                  Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 18))
        ],
      );
    }
    return const SizedBox();
  }

  Widget title() {
    return Flexible(
      child: Text(widget.item.name,
          textAlign: TextAlign.left,
          maxLines: 2,
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }
}
