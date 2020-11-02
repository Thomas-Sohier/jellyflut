import 'package:flutter/material.dart';
import 'package:jellyflut/api/user.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/shared/shared.dart';

class FavButton extends StatefulWidget {
  final Item item;
  final EdgeInsetsGeometry padding;

  const FavButton(this.item, {this.padding = const EdgeInsets.all(10)});

  @override
  State<StatefulWidget> createState() {
    return _FavButtonState();
  }
}

bool isFav;

class _FavButtonState extends State<FavButton> {
  @override
  void initState() {
    super.initState();
    isFav =
        widget.item.userData == null ? false : widget.item.userData.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: button(),
    );
  }

  Widget button() {
    if (isFav) {
      return InkWell(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          onTap: () => unsetItemFav(widget.item.id),
          child: Padding(
            padding: widget.padding,
            child: Icon(
              Icons.favorite,
              color: Colors.red,
            ),
          ));
    } else {
      return InkWell(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        onTap: () => setItemFav(widget.item.id),
        child: Padding(
          padding: widget.padding,
          child: Icon(
            Icons.favorite_border,
            color: Colors.red,
          ),
        ),
      );
    }
  }

  void setItemFav(String itemId) {
    favItem(itemId).then((Map<String, dynamic> json) => {
          setState(() {
            isFav = json['IsFavorite'];
          }),
          showToast('Item fav')
        });
  }

  void unsetItemFav(String itemId) {
    unfavItem(itemId).then((Map<String, dynamic> json) => {
          setState(() {
            isFav = json['IsFavorite'];
          }),
          showToast('Item unfav')
        });
  }
}
