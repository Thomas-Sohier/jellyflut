import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/components/critics.dart';
import 'package:jellyflut/components/poster/itemPoster.dart';
import 'package:jellyflut/main.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/screens/details/details.dart';
import 'package:jellyflut/screens/details/template/large_screens/components/items_collection/outlinedButtonSelector.dart';
import 'package:jellyflut/shared/shared.dart';
import 'package:uuid/uuid.dart';

class SeasonItem extends StatefulWidget {
  final bool clickable;
  final Item item;
  SeasonItem({Key? key, required this.item, this.clickable = true})
      : super(key: key);

  @override
  _SeasonItemState createState() => _SeasonItemState();
}

class _SeasonItemState extends State<SeasonItem>
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
    Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(
          builder: (context) => Details(item: widget.item, heroTag: heroTag)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButtonSelector(
        node: _node,
        onPressed: () => _onTap(posterHeroTag),
        child: seasonItem());
  }

  Widget seasonItem() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 2),
      child: SizedBox(
          height: 120,
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
                                Critics(widget.item,
                                    textColor: Colors.white.withAlpha(210)),
                              if (widget.item.getDuration() != 0) duration()
                            ],
                          ),
                        ),
                        if (widget.item.overview != null) overview()
                      ],
                    )),
              )
            ],
          )),
    );
  }

  Widget title() {
    return Text('${widget.item.indexNumber} - ${widget.item.name}',
        textAlign: TextAlign.left,
        style: TextStyle(
            fontSize: 18,
            fontFamily: 'HindMadurai',
            color: Colors.white.withAlpha(210)));
  }

  Widget duration() {
    return Text(
        printDuration(Duration(microseconds: widget.item.getDuration())),
        style: TextStyle(
            fontSize: 18,
            fontFamily: 'HindMadurai',
            color: Colors.white.withAlpha(210)));
  }

  Widget overview() {
    return Expanded(
      child: Text(
        widget.item.overview!,
        textAlign: TextAlign.justify,
        style: TextStyle(
            fontSize: 16,
            fontFamily: 'HindMadurai',
            color: Colors.white.withAlpha(190)),
      ),
    );
  }
}
