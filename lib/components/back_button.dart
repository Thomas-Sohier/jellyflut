import 'package:flutter/material.dart';
import 'package:jellyflut/components/outlined_button_selector.dart';

class SelectableBackButton extends StatefulWidget {
  final bool shadow;
  const SelectableBackButton({super.key, this.shadow = false});

  @override
  State<SelectableBackButton> createState() => _SelectableBackButtonState();
}

class _SelectableBackButtonState extends State<SelectableBackButton> {
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
        shape: const CircleBorder(),
        onPressed: () => {},
        primary: Colors.white,
        child: const BackButton());
  }
}
