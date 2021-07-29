import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jellyflut/api/user.dart';
import 'package:jellyflut/main.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/shared/toast.dart';

class ViewedButton extends StatefulWidget {
  final Item item;
  final EdgeInsetsGeometry padding;

  const ViewedButton(this.item,
      {Key? key, this.padding = const EdgeInsets.all(10)})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ViewedButtonState();
  }
}

class _ViewedButtonState extends State<ViewedButton> {
  late var fToast;
  late FocusNode _node;
  late Color _focusColor;

  @override
  void initState() {
    _focusColor = Colors.transparent;
    _node = FocusNode(descendantsAreFocusable: false, skipTraversal: false);
    _node.addListener(_onFocusChange);
    fToast = FToast();
    fToast.init(navigatorKey.currentState!.context);
    super.initState();
  }

  void _onFocusChange() {
    if (_node.hasFocus) {
      setState(() {
        _focusColor = Colors.green;
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
            child: button()));
  }

  Widget button() {
    if (widget.item.isPlayed()) {
      return InkWell(
          focusNode: _node,
          borderRadius: BorderRadius.all(Radius.circular(30)),
          onTap: () => unsetItemViewed(),
          child: Padding(
            padding: widget.padding,
            child: Icon(
              Icons.check,
              color: Colors.green,
            ),
          ));
    } else {
      return InkWell(
          focusNode: _node,
          borderRadius: BorderRadius.all(Radius.circular(30)),
          onTap: () => setItemViewed(),
          child: Padding(
            padding: widget.padding,
            child: Icon(
              Icons.check,
              color: Colors.black,
            ),
          ));
    }
  }

  void setItemViewed() {
    viewItem(widget.item.id).then((Map<String, dynamic> json) => {
          setState(() {
            widget.item.userData?.played = json['Played'];
          }),
          showToast('${widget.item.name} marked as viewed', fToast)
        });
  }

  void unsetItemViewed() {
    unviewItem(widget.item.id).then((Map<String, dynamic> json) => {
          setState(() {
            widget.item.userData?.played = json['Played'];
          }),
          showToast('${widget.item.name} marked as unviewed', fToast)
        });
  }
}
