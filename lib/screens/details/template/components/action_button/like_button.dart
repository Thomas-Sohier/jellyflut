import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jellyflut/components/palette_button.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/services/item/item_service.dart';
import 'package:jellyflut/shared/toast.dart';

class LikeButton extends StatefulWidget {
  final Item item;
  final double maxWidth;

  const LikeButton({Key? key, required this.item, this.maxWidth = 150})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LikeButtonState();
  }
}

class _LikeButtonState extends State<LikeButton> {
  late var fToast;

  @override
  void initState() {
    fToast = FToast();
    fToast.init(context);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PaletteButton(
      'Like',
      onPressed: () => widget.item.isFavorite() ? unsetItemFav() : setItemFav(),
      borderRadius: 4,
      minWidth: 40,
      maxWidth: widget.maxWidth,
      icon: widget.item.isFavorite()
          ? Icon(Icons.favorite, color: Colors.red.shade900)
          : Icon(Icons.favorite_border, color: Colors.black87),
    );
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
