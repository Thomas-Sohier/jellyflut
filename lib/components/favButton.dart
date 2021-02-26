import 'package:flutter/material.dart';
import 'package:jellyflut/api/user.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/shared/shared.dart';

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
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: button(),
    );
  }

  Widget button() {
    if (widget.item.isFavorite()) {
      return InkWell(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          onTap: () => unsetItemFav(),
          child: Padding(
            padding: widget.padding,
            child: Icon(Icons.favorite, color: Colors.red, size: widget.size),
          ));
    } else {
      return InkWell(
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
          showToast('${widget.item.name} added to favorite')
        });
  }

  void unsetItemFav() {
    unfavItem(widget.item.id).then((Map<String, dynamic> json) => {
          setState(() {
            widget.item.userData.isFavorite = json['IsFavorite'];
          }),
          showToast('${widget.item.name} removed from favorite')
        });
  }
}
