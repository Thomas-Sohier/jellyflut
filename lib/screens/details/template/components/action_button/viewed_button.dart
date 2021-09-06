part of '../action_button.dart';

class ViewedButton extends StatefulWidget {
  final Item item;

  final double maxWidth;
  const ViewedButton({Key? key, required this.item, this.maxWidth = 150})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ViewedButtonState();
  }
}

class _ViewedButtonState extends State<ViewedButton> {
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
      'Viewed',
      onPressed: () =>
          widget.item.isPlayed() ? unsetItemViewed() : setItemViewed(),
      borderRadius: 4,
      minWidth: 40,
      maxWidth: widget.maxWidth,
      icon: widget.item.isPlayed()
          ? Icon(Icons.check_box, color: Colors.green.shade900)
          : Icon(Icons.check_box_outline_blank, color: Colors.black87),
    );
  }

  void setItemViewed() {
    ItemService.viewItem(widget.item.id).then((Map<String, dynamic> json) => {
          setState(() {
            widget.item.userData?.played = json['Played'];
          }),
          showToast('${widget.item.name} marked as viewed', fToast)
        });
  }

  void unsetItemViewed() {
    ItemService.unviewItem(widget.item.id).then((Map<String, dynamic> json) => {
          setState(() {
            widget.item.userData?.played = json['Played'];
          }),
          showToast('${widget.item.name} marked as unviewed', fToast)
        });
  }
}
