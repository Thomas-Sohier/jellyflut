part of '../action_button.dart';

class LikeButton extends StatefulWidget {
  final Item item;
  final double maxWidth;

  const LikeButton({super.key, required this.item, this.maxWidth = 150});

  @override
  State<StatefulWidget> createState() {
    return _LikeButtonState();
  }
}

class _LikeButtonState extends State<LikeButton> {
  late FToast fToast;

  @override
  void didChangeDependencies() {
    fToast = FToast();
    fToast.init(context);
    super.didChangeDependencies();
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
    context.read<ItemsRepository>().favItem(widget.item.id).then((UserData userData) => {
          setState(() {
            widget.item.userData!.isFavorite = userData.isFavorite;
          }),
          showToast('add_item_favorite'.tr(args: [widget.item.name]), fToast, duration: Duration(seconds: 3))
        });
  }

  void unsetItemFav() {
    context.read<ItemsRepository>().unfavItem(widget.item.id).then((UserData userData) => {
          setState(() {
            widget.item.userData!.isFavorite = userData.isFavorite;
          }),
          showToast('remove_item_favorite'.tr(args: [widget.item.name]), fToast, duration: Duration(seconds: 3))
        });
  }
}
