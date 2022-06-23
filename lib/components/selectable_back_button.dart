import 'package:flutter/material.dart';
import 'package:jellyflut/components/outlined_button_selector.dart';
import 'package:jellyflut/globals.dart';

class SelectableBackButton extends StatefulWidget {
  final bool shadow;
  const SelectableBackButton({super.key, this.shadow = false});

  @override
  State<SelectableBackButton> createState() => _SelectableBackButtonState();
}

class _SelectableBackButtonState extends State<SelectableBackButton> {
  late final List<BoxShadow> shadows;

  @override
  void initState() {
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
  Widget build(BuildContext context) {
    return OutlinedButtonSelector(
        shape: const CircleBorder(),
        onPressed: customRouter.pop,
        primary: Colors.white,
        child: ExcludeFocus(child: IgnorePointer(child: const BackButton())));
  }
}
