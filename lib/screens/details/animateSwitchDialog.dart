import 'package:flutter/material.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/screens/details/itemDialogActions.dart';
import 'package:jellyflut/screens/form/editItemInfos.dart';

class AnimateSwitchDialog extends StatefulWidget {
  final Item item;

  const AnimateSwitchDialog(this.item);

  @override
  State<StatefulWidget> createState() {
    return _CollectionState();
  }
}

const double gapSize = 20;
late bool _first;

class _CollectionState extends State<AnimateSwitchDialog> {
  @override
  void initState() {
    _first = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 500),
      child: x(),
    );
  }

  Widget x() {
    if (_first) {
      return ItemDialogActions(widget.item, () => switchWidget());
    } else {
      return EditItemInfos(widget.item);
    }
  }

  void switchWidget() {
    setState(() {
      _first = !_first;
    });
  }
}
