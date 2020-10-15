import 'package:flutter/material.dart';
import 'package:jellyflut/api/user.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/shared/shared.dart';

class ViewedButton extends StatefulWidget {
  final Item item;
  const ViewedButton(this.item);

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
    if (isViewed)
      return Padding(
          padding: const EdgeInsets.only(right: 10),
          child: InkWell(
            onTap: () => unsetItemViewed(widget.item.id),
            child: Icon(
              Icons.check,
              color: Colors.green,
            ),
          ));
    else
      return Padding(
          padding: const EdgeInsets.only(right: 10),
          child: InkWell(
            onTap: () => setItemViewed(widget.item.id),
            child: Icon(
              Icons.check,
              color: Colors.black,
            ),
          ));
  }

  void setItemViewed(String itemId) {
    viewItem(itemId).then((Map<String, dynamic> json) => {
          setState(() {
            isViewed = json["Played"];
          }),
          showToast("Item viewed")
        });
  }

  void unsetItemViewed(String itemId) {
    unviewItem(itemId).then((Map<String, dynamic> json) => {
          setState(() {
            isViewed = json["Played"];
          }),
          showToast("Item unviewed")
        });
  }
}
