import 'package:flutter/material.dart';
import 'package:jellyflut/api/user.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/shared/shared.dart';

class FavButton extends StatefulWidget {
  final Item item;
  const FavButton(this.item);

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
    if (isFav)
      return Padding(
          padding: const EdgeInsets.only(right: 10),
          child: InkWell(
            radius: 6,
            onTap: () => unsetItemFav(widget.item.id),
            child: Icon(
              Icons.favorite,
              color: Colors.red,
            ),
          ));
    else
      return Padding(
          padding: const EdgeInsets.only(right: 10),
          child: InkWell(
            radius: 6,
            onTap: () => setItemFav(widget.item.id),
            child: Icon(
              Icons.favorite_border,
              color: Colors.red,
            ),
          ));
  }

  void setItemFav(String itemId) {
    favItem(itemId).then((Map<String, dynamic> json) => {
          setState(() {
            isFav = json["IsFavorite"];
          }),
          showToast("Item fav")
        });
  }

  void unsetItemFav(String itemId) {
    unfavItem(itemId).then((Map<String, dynamic> json) => {
          setState(() {
            isFav = json["IsFavorite"];
          }),
          showToast("Item unfav")
        });
  }
}
