import 'package:flutter/material.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/components/outlined_button_selector.dart';

class BackButton extends StatefulWidget {
  final bool shadow;
  final VoidCallback? onPressedCallback;

  const BackButton({super.key, this.shadow = false, this.onPressedCallback});

  @override
  State<BackButton> createState() => _BackButtonState();
}

class _BackButtonState extends State<BackButton> {
  late final FocusNode _node;
  late List<BoxShadow> shadows;

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
        shape: CircleBorder(),
        onPressed: customRouter.pop,
        padding: EdgeInsets.all(8),
        primary: Colors.white,
        child: Icon(
          Icons.arrow_back,
          color: Colors.white,
          size: 28,
        ));
  }
}
