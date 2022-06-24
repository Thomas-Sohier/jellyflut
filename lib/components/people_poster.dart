import 'package:flutter/material.dart';

import 'package:jellyflut/components/async_image.dart';
import 'package:jellyflut/mixins/absorb_action.dart';
import 'package:jellyflut_models/jellyflut_models.dart';
import 'package:uuid/uuid.dart';

class PeoplePoster extends StatefulWidget {
  final Person person;
  final bool clickable;
  final bool bigPoster;
  final Function(String)? onPressed;

  PeoplePoster(
      {super.key,
      required this.person,
      this.onPressed,
      this.bigPoster = false,
      this.clickable = true});

  @override
  State<PeoplePoster> createState() => _PeoplePosterState();
}

class _PeoplePosterState extends State<PeoplePoster> with AbsordAction {
  // Dpad navigation
  late FocusNode _node;
  late String posterHeroTag;
  late final heroTag;

  @override
  void initState() {
    _node = FocusNode();
    heroTag = '${widget.person.id}-${Uuid().v1()}-person';
    super.initState();
  }

  @override
  void dispose() {
    _node.dispose();
    super.dispose();
  }

  Future<void> onTap() {
    if (widget.onPressed != null) {
      return widget.onPressed!(heroTag);
    }
    return Future.value(null);
  }

  @override
  Widget build(BuildContext context) {
    final finalPoster = widget.bigPoster ? bigPoster(heroTag) : poster(heroTag);
    if (widget.clickable) {
      return OutlinedButton(
          onPressed: () => action(onTap),
          autofocus: false,
          focusNode: _node,
          style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4))),
                  backgroundColor: Colors.transparent)
              .copyWith(side: buttonBorderSide())
              .copyWith(elevation: buttonElevation()),
          child: finalPoster);
    }
    return finalPoster;
  }

  Widget poster(String heroTag) {
    return Hero(
        tag: heroTag,
        child: AspectRatio(
            aspectRatio: 2 / 3,
            child: AsyncImage(
              item: widget.person.asItem(),
              boxFit: BoxFit.contain,
              placeholder: (_) => Container(
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Center(
                  child: Icon(Icons.person),
                ),
              ),
            )));
  }

  Widget bigPoster(String heroTag) {
    return Hero(
        tag: heroTag,
        child: AspectRatio(
          aspectRatio: 2 / 3,
          child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  AsyncImage(
                    item: widget.person.asItem(),
                    boxFit: BoxFit.contain,
                    placeholder: (_) => Container(
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: Center(
                        child: Icon(Icons.person),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.zero,
                    padding: EdgeInsets.zero,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black,
                          Colors.black87,
                          Colors.transparent,
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        stops: [0, 0.1, 0.25],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            widget.person.name,
                            overflow: TextOverflow.clip,
                            softWrap: false,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          if (widget.person.role != null)
                            Text(
                              widget.person.role!,
                              overflow: TextOverflow.clip,
                              softWrap: false,
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 12),
                            )
                        ],
                      ),
                    ),
                  ),
                ],
              )),
        ));
  }

  MaterialStateProperty<double> buttonElevation() {
    return MaterialStateProperty.resolveWith<double>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.hovered) ||
            states.contains(MaterialState.focused)) {
          return 2;
        }
        return 0; // defer to the default
      },
    );
  }

  MaterialStateProperty<BorderSide> buttonBorderSide() {
    return MaterialStateProperty.resolveWith<BorderSide>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.focused)) {
          return BorderSide(
            width: 2,
            color: Colors.white,
          );
        }
        return BorderSide(
            width: 0, color: Colors.transparent); // defer to the default
      },
    );
  }
}
