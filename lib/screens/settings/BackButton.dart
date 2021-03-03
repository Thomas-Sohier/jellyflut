import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/components/slideRightRoute.dart';
import 'package:jellyflut/screens/settings/settings.dart';

class BackButton extends StatefulWidget {
  @override
  _BackButtonState createState() => _BackButtonState();
}

class _BackButtonState extends State<BackButton> {
  FocusNode _node;
  Color _focusColor;

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
        onTap: () => Navigator.of(context).pop(),
        radius: 60,
        borderRadius: BorderRadius.all(Radius.circular(80)),
        child: Padding(
            padding: const EdgeInsets.all(6),
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 28,
            )),
      ),
    );
  }
}
