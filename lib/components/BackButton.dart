import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/screens/details/template/large_screens/components/items_collection/outlinedButtonSelector.dart';

class BackButton extends StatefulWidget {
  final bool shadow;

  const BackButton({Key? key, this.shadow = false}) : super(key: key);

  @override
  _BackButtonState createState() => _BackButtonState();
}

class _BackButtonState extends State<BackButton> {
  late final FocusNode _node;
  late final List<BoxShadow> shadows;

  @override
  void initState() {
    _node = FocusNode(descendantsAreFocusable: false, skipTraversal: false);
    shadows = widget.shadow
        ? [
            BoxShadow(
                blurRadius: 28,
                color: Colors.black.withAlpha(20),
                spreadRadius: 8),
            BoxShadow(blurRadius: 24, color: Colors.black12, spreadRadius: 1),
            BoxShadow(blurRadius: 22, color: Colors.black26, spreadRadius: 0)
          ]
        : [];
    super.initState();
  }

  @override
  void dispose() {
    _node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButtonSelector(
      node: _node,
      shape: CircleBorder(),
      onPressed: () => customRouter.pop(),
      child: Container(
          decoration: BoxDecoration(boxShadow: shadows),
          padding: const EdgeInsets.all(6),
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 28,
          )),
    );
  }
}
