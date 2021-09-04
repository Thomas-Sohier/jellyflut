import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/components/asyncImage.dart';
import 'package:jellyflut/models/jellyfin/person.dart';

class PeoplePoster extends StatefulWidget {
  final Person person;
  final int index;
  final bool clickable;
  final bool bigPoster;
  final VoidCallback? onPressed;

  PeoplePoster(
      {Key? key,
      required this.person,
      required this.index,
      this.onPressed,
      this.bigPoster = false,
      this.clickable = true})
      : super(key: key);

  @override
  _PeoplePosterState createState() => _PeoplePosterState();
}

class _PeoplePosterState extends State<PeoplePoster>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  // Dpad navigation
  late FocusNode _node;
  late String posterHeroTag;
  late Widget finalPoster;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    finalPoster = widget.bigPoster ? bigPoster() : poster();
    _node = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (widget.clickable) {
      return OutlinedButton(
          onPressed: widget.onPressed,
          autofocus: false,
          focusNode: _node,
          style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                  backgroundColor: Colors.transparent)
              .copyWith(side: buttonBorderSide())
              .copyWith(elevation: buttonElevation()),
          child: finalPoster);
    }
    return finalPoster;
  }

  Widget poster() {
    return Hero(
        tag: '${widget.person.id}-${widget.index}-person',
        child: AspectRatio(
            aspectRatio: 2 / 3,
            child: AsyncImage(
              widget.person.id,
              widget.person.primaryImageTag,
              widget.person.imageBlurHashes,
              boxFit: BoxFit.contain,
              placeholder: Container(
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Center(
                  child: Icon(Icons.person),
                ),
              ),
            )));
  }

  Widget bigPoster() {
    return Hero(
        tag: '${widget.person.id}-${widget.index}-person',
        child: AspectRatio(
          aspectRatio: 2 / 3,
          child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  AsyncImage(
                    widget.person.id,
                    widget.person.primaryImageTag,
                    widget.person.imageBlurHashes,
                    boxFit: BoxFit.contain,
                    placeholder: Container(
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
                          Text(
                            widget.person.role,
                            overflow: TextOverflow.clip,
                            softWrap: false,
                            style:
                                TextStyle(color: Colors.white70, fontSize: 12),
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
