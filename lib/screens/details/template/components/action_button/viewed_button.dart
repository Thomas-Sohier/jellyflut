part of '../action_button.dart';

class ViewedButton extends StatefulWidget {
  final Item item;

  final double maxWidth;
  const ViewedButton({super.key, required this.item, this.maxWidth = 150});

  @override
  State<StatefulWidget> createState() {
    return _ViewedButtonState();
  }
}

class _ViewedButtonState extends State<ViewedButton> {
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
      'viewed'.tr(),
      onPressed: () => widget.item.isPlayed() ? unsetItemViewed() : setItemViewed(),
      borderRadius: 4,
      minWidth: 40,
      maxWidth: widget.maxWidth,
      icon: widget.item.isPlayed()
          ? Icon(Icons.check_box, color: Colors.green.shade600)
          : Icon(Icons.check_box_outline_blank, color: Colors.black87),
    );
  }

  void setItemViewed() {
    context.read<ItemsRepository>().viewItem(widget.item.id).then((UserData userData) => {
          setState(() {
            widget.item.userData?.played = userData.played;
          }),
          showToast('mark_item_viewed'.tr(args: [widget.item.name]), fToast)
        });
  }

  void unsetItemViewed() {
    context.read<ItemsRepository>().unviewItem(widget.item.id).then((UserData userData) => {
          setState(() {
            widget.item.userData?.played = userData.played;
          }),
          showToast('mark_item_unviewed'.tr(args: [widget.item.name]), fToast)
        });
  }
}
