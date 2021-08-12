import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/components/asyncImage.dart';
import 'package:jellyflut/models/person.dart';

class PeoplePoster extends StatefulWidget {
  final Person person;
  final int index;
  final VoidCallback onPressed;
  final bool clickable;
  final bool bigPoster;

  PeoplePoster(
      {Key? key,
      required this.person,
      required this.index,
      required this.onPressed,
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
  late AnimationController _controller;
  late Color _focusColor;
  late String posterHeroTag;
  late Widget finalPoster;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    finalPoster = widget.bigPoster ? bigPoster() : poster();
    _node = FocusNode();
    _focusColor = Colors.transparent;
    _node.addListener(_onFocusChange);
    _controller = AnimationController(
        duration: const Duration(milliseconds: 100),
        vsync: this,
        lowerBound: 0.9,
        upperBound: 1);
    super.initState();
  }

  void _onFocusChange() {
    if (_node.hasFocus) {
      _controller.forward();
      setState(() {
        _focusColor = Colors.white;
      });
    } else {
      _controller.reverse();
      setState(() {
        _focusColor = Colors.transparent;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (widget.clickable) {
      return RawMaterialButton(
          onPressed: widget.onPressed,
          focusNode: _node,
          focusColor: Colors.transparent,
          splashColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          focusElevation: 0,
          autofocus: false,
          child: nodeAction());
    }
    return nodeAction();
  }

  Widget nodeAction() {
    return _node.hasFocus
        ? Container(
            decoration: BoxDecoration(
                border: Border.all(width: 2, color: _focusColor),
                borderRadius: BorderRadius.all(Radius.circular(5))),
            padding: EdgeInsets.all(2),
            child: finalPoster)
        : finalPoster;
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
}
