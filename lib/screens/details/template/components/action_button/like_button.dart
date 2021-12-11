part of '../action_button.dart';

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
    // ignore: unnecessary_this
    fToast.init(this.context);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PaletteButton(
      'like'.tr(),
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
          showToast('add_item_favorite'.tr(args: [widget.item.name]), fToast,
              duration: Duration(seconds: 3))
        });
  }

  void unsetItemFav() {
    ItemService.unfavItem(widget.item.id).then((Map<String, dynamic> json) => {
          setState(() {
            widget.item.userData!.isFavorite = json['IsFavorite'];
          }),
          showToast('remove_item_favorite'.tr(args: [widget.item.name]), fToast,
              duration: Duration(seconds: 3))
        });
  }
}
