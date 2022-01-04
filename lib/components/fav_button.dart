import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/services/item/item_service.dart';
import 'package:jellyflut/shared/toast.dart';

class FavButton extends StatefulWidget {
  final Item item;
  final EdgeInsetsGeometry padding;
  final double size;
  final Color color;
  final Color backgroundFocusColor;

  const FavButton(this.item,
      {this.padding = const EdgeInsets.all(10),
      this.size = 26,
      this.color = Colors.red,
      this.backgroundFocusColor = Colors.black12});

  @override
  State<StatefulWidget> createState() {
    return _FavButtonState();
  }
}

class _FavButtonState extends State<FavButton> {
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
          child: button()),
    );
  }

  Widget button() {
    if (widget.item.isFavorite()) {
      return InkWell(
          focusNode: _node,
          focusColor: widget.backgroundFocusColor,
          hoverColor: widget.backgroundFocusColor,
          borderRadius: BorderRadius.all(Radius.circular(30)),
          onTap: unsetItemFav,
          child: Padding(
            padding: widget.padding,
            child: Icon(Icons.favorite, color: widget.color, size: widget.size),
          ));
    } else {
      return InkWell(
        focusNode: _node,
        focusColor: widget.backgroundFocusColor,
        hoverColor: widget.backgroundFocusColor,
        borderRadius: BorderRadius.all(Radius.circular(30)),
        onTap: setItemFav,
        child: Padding(
          padding: widget.padding,
          child: Icon(Icons.favorite_border,
              color: widget.color, size: widget.size),
        ),
      );
    }
  }

  void setItemFav() {
    ItemService.favItem(widget.item.id).then((Map<String, dynamic> json) => {
          setState(() {
            widget.item.userData!.isFavorite = json['IsFavorite'];
          }),
          showToast('${widget.item.name} added to favorite', fToast)
        });
  }

  void unsetItemFav() {
    ItemService.unfavItem(widget.item.id).then((Map<String, dynamic> json) => {
          setState(() {
            widget.item.userData!.isFavorite = json['IsFavorite'];
          }),
          showToast('${widget.item.name} removed from favorite', fToast)
        });
  }
}
