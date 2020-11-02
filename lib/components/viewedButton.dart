import 'package:flutter/material.dart';
import 'package:jellyflut/api/user.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/shared/shared.dart';

class ViewedButton extends StatefulWidget {
  final Item item;
  final EdgeInsetsGeometry padding;

  const ViewedButton(this.item, {this.padding = const EdgeInsets.all(10)});

  @override
  State<StatefulWidget> createState() {
    return _ViewedButtonState();
  }
}

bool isViewed;

class _ViewedButtonState extends State<ViewedButton> {
  @override
  void initState() {
    super.initState();
    isViewed =
        widget.item.userData == null ? false : widget.item.userData.played;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: button(),
    );
  }

  Widget button() {
    if (isViewed) {
      return InkWell(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          onTap: () => unsetItemViewed(widget.item.id),
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
          onTap: () => setItemViewed(widget.item.id),
          child: Padding(
            padding: widget.padding,
            child: Icon(
              Icons.check,
              color: Colors.black,
            ),
          ));
    }
  }

  void setItemViewed(String itemId) {
    viewItem(itemId).then((Map<String, dynamic> json) => {
          setState(() {
            isViewed = json['Played'];
          }),
          showToast('Item viewed')
        });
  }

  void unsetItemViewed(String itemId) {
    unviewItem(itemId).then((Map<String, dynamic> json) => {
          setState(() {
            isViewed = json['Played'];
          }),
          showToast('Item unviewed')
        });
  }
}
