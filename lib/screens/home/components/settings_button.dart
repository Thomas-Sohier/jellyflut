import 'package:flutter/material.dart';

import 'package:jellyflut/globals.dart';
import 'package:jellyflut/routes/router.gr.dart';

class SettingsButton extends StatefulWidget {
  @override
  _SettingsButtonState createState() => _SettingsButtonState();
}

class _SettingsButtonState extends State<SettingsButton> {
  late FocusNode _node;
  late Color _focusColor;

  @override
  void initState() {
    _focusColor = Colors.transparent;
    _node = FocusNode(descendantsAreFocusable: false, skipTraversal: false);
    _node.addListener(_onFocusChange);
    super.initState();
  }

  void _onFocusChange() {
    if (_node.hasFocus) {
      setState(() {
        _focusColor = Colors.white;
      });
    } else {
      setState(() {
        _focusColor = Colors.transparent;
      });
    }
  }

  @override
  void dispose() {
    _node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      foregroundDecoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(width: 2, color: _focusColor)),
      child: InkWell(
        focusNode: _node,
        onTap: () => customRouter.push(SettingsRoute()),
        radius: 60,
        borderRadius: BorderRadius.all(Radius.circular(80)),
        child: Padding(
            padding: const EdgeInsets.all(6),
            child: Icon(
              Icons.settings,
              size: 28,
            )),
      ),
    );
  }
}
