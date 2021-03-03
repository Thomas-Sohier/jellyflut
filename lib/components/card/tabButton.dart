import 'package:flutter/material.dart';
import 'package:jellyflut/shared/theme.dart';

class TabButton extends StatefulWidget {
  final EdgeInsetsGeometry padding;
  final Icon icon;

  const TabButton(
      {Key key, @required this.icon, this.padding = const EdgeInsets.all(10)})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TabButtonState();
  }
}

class _TabButtonState extends State<TabButton> {
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
        _focusColor = jellyLightPurple;
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
    return Focus(
        focusNode: _node,
        child: Container(
            padding: EdgeInsets.all(2),
            foregroundDecoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(width: 2, color: _focusColor)),
            child: Tab(icon: widget.icon)));
  }
}
