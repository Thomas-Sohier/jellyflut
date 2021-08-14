import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/screens/details/template/large_screens/components/items_collection/outlinedButtonSelector.dart';
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
    return OutlinedButtonSelector(
        node: _node, onPressed: widget.onPressed, child: listItem(widget.item));
  }

  Widget listItem(Item item) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Column(
        children: [
          if (item.indexNumber != null) Text(item.indexNumber.toString()),
          Row(
            children: [
              Text(item.name,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Theme.of(context).textTheme.bodyText1!.color,
                      fontSize: 18,
                      fontWeight: FontWeight.w600))
            ],
          ),
          if (item.hasArtists())
            Row(
              children: [
                Text(item.concatenateArtists().toString(),
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyText2!.color,
                        fontSize: 16))
              ],
            ),
          SizedBox(
            height: 12,
          ),
          Row(
            children: [
              Text(printDuration(Duration(microseconds: item.getDuration())),
                  style: TextStyle(
                      color: Theme.of(context).textTheme.bodyText2!.color,
                      fontSize: 16))
            ],
          ),
        ],
      ),
    );
  }
}
