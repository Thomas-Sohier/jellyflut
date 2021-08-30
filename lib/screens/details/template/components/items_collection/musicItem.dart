import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/components/favButton.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/screens/details/template/components/items_collection/outlinedButtonSelector.dart';
import 'package:jellyflut/shared/shared.dart';

class MusicItem extends StatefulWidget {
  final VoidCallback onPressed;
  final Item item;
  MusicItem({Key? key, required this.onPressed, required this.item})
      : super(key: key);

  @override
  _MusicItemState createState() => _MusicItemState();
}

class _MusicItemState extends State<MusicItem> {
  late final FocusNode _node;

  @override
  void initState() {
    _node = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 8,
          child: OutlinedButtonSelector(
              node: _node,
              onPressed: widget.onPressed,
              child: listItem(widget.item)),
        ),
        Flexible(
            flex: 1,
            child: Center(
              child: FavButton(
                widget.item,
                color: Colors.red.shade800,
                backgroundFocusColor: Colors.white10,
              ),
            ))
      ],
    );
  }

  Widget listItem(Item item) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Column(
        children: [
          if (item.indexNumber != null) Text(item.indexNumber.toString()),
          Row(
            children: [
              Flexible(
                child: Text(item.name,
                    textAlign: TextAlign.left,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(fontSize: 18, fontWeight: FontWeight.bold)),
              )
            ],
          ),
          if (item.hasArtists())
            Row(
              children: [
                Text(item.concatenateArtists().toString(),
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(fontSize: 18))
              ],
            ),
          SizedBox(
            height: 12,
          ),
          Row(
            children: [
              Text(printDuration(Duration(microseconds: item.getDuration())),
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(fontSize: 16))
            ],
          ),
        ],
      ),
    );
  }
}
