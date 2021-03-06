import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jellyflut/api/user.dart';
import 'package:jellyflut/main.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/shared/toast.dart';

class FavButton extends StatefulWidget {
  final Item item;
  final EdgeInsetsGeometry padding;
  final double size;

  const FavButton(this.item,
      {Key key, this.padding = const EdgeInsets.all(10), this.size = 26})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _FavButtonState();
  }
}

class _FavButtonState extends State<FavButton> {
  var fToast;
  FocusNode _node;
  Color _focusColor;

  @override
  void initState() {
    _focusColor = Colors.transparent;
    _node = FocusNode(descendantsAreFocusable: false, skipTraversal: false);
    _node.addListener(_onFocusChange);
    fToast = FToast();
    fToast.init(navigatorKey.currentState.context);
    super.initState();
  }

  void _onFocusChange() {
    if (_node.hasFocus) {
      setState(() {
        _focusColor = Colors.red;
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
          child: button()),
    );
  }

  Widget button() {
    if (widget.item.isFavorite()) {
      return InkWell(
          focusNode: _node,
          borderRadius: BorderRadius.all(Radius.circular(30)),
          onTap: () => unsetItemFav(),
          child: Padding(
            padding: widget.padding,
            child: Icon(Icons.favorite, color: Colors.red, size: widget.size),
          ));
    } else {
      return InkWell(
        focusNode: _node,
        borderRadius: BorderRadius.all(Radius.circular(30)),
        onTap: () => setItemFav(),
        child: Padding(
          padding: widget.padding,
          child:
              Icon(Icons.favorite_border, color: Colors.red, size: widget.size),
        ),
      );
    }
  }

  void setItemFav() {
    favItem(widget.item.id).then((Map<String, dynamic> json) => {
          setState(() {
            widget.item.userData.isFavorite = json['IsFavorite'];
          }),
          showToast('${widget.item.name} added to favorite', fToast)
        });
  }

  void unsetItemFav() {
    unfavItem(widget.item.id).then((Map<String, dynamic> json) => {
          setState(() {
            widget.item.userData.isFavorite = json['IsFavorite'];
          }),
          showToast('${widget.item.name} removed from favorite', fToast)
        });
  }
}
