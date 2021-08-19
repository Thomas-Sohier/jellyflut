import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/screens/stream/initStream.dart';

class TrailerButton extends StatefulWidget {
  final Item item;
  final EdgeInsetsGeometry padding;
  final double size;
  final Color color;
  final Color backgroundFocusColor;

  const TrailerButton(this.item,
      {this.padding = const EdgeInsets.all(10),
      this.size = 26,
      this.color = Colors.blue,
      this.backgroundFocusColor = Colors.black12});

  @override
  State<StatefulWidget> createState() {
    return _TrailerButtonState();
  }
}

class _TrailerButtonState extends State<TrailerButton> {
  var fToast;
  late FocusNode _node;
  late Color _focusColor;

  @override
  void initState() {
    _focusColor = Colors.transparent;
    _node = FocusNode(descendantsAreFocusable: false, skipTraversal: false);
    _node.addListener(_onFocusChange);
    fToast = FToast();
    fToast.init(context);
    super.initState();
  }

  void _onFocusChange() {
    if (_node.hasFocus) {
      setState(() {
        _focusColor = widget.color;
      });
    } else {
      setState(() {
        _focusColor = Colors.transparent;
      });
    }
  }

  @override
  void dispose() {
    _node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
          foregroundDecoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(width: 2, color: _focusColor)),
          child: InkWell(
              focusNode: _node,
              focusColor: widget.backgroundFocusColor,
              hoverColor: widget.backgroundFocusColor,
              borderRadius: BorderRadius.all(Radius.circular(30)),
              onTap: () => playTrailer(context),
              child: Padding(
                padding: widget.padding,
                child:
                    Icon(Icons.movie, color: widget.color, size: widget.size),
              ))),
    );
  }

  void playTrailer(BuildContext context) async {
    final url = await widget.item.getYoutubeTrailerUrl();
    InitStreamingUrlUtil.initFromUrl(
        url: url.toString(), streamName: widget.item.name);
  }
}
