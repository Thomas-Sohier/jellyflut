import 'package:flutter/material.dart';
import 'package:jellyflut/api/user.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/shared/shared.dart';

class ViewedButton extends StatefulWidget {
  final Item item;
  final EdgeInsetsGeometry padding;

  const ViewedButton(this.item,
      {Key key, this.padding = const EdgeInsets.all(10)})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ViewedButtonState();
  }
}

class _ViewedButtonState extends State<ViewedButton> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: button(),
    );
  }

  Widget button() {
    if (widget.item.isPlayed()) {
      return InkWell(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          onTap: () => unsetItemViewed(),
          child: Padding(
            padding: widget.padding,
            child: Icon(
              Icons.check,
              color: Colors.green,
            ),
          ));
    } else {
      return InkWell(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          onTap: () => setItemViewed(),
          child: Padding(
            padding: widget.padding,
            child: Icon(
              Icons.check,
              color: Colors.black,
            ),
          ));
    }
  }

  void setItemViewed() {
    viewItem(widget.item.id).then((Map<String, dynamic> json) => {
          setState(() {
            widget.item.userData.played = json['Played'];
          }),
          showToast('${widget.item.name} marked as viewed')
        });
  }

  void unsetItemViewed() {
    unviewItem(widget.item.id).then((Map<String, dynamic> json) => {
          setState(() {
            widget.item.userData.played = json['Played'];
          }),
          showToast('${widget.item.name} marked as unviewed')
        });
  }
}
