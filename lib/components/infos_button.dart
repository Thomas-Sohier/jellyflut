import 'package:flutter/material.dart';

class InfosButton extends StatefulWidget {
  final EdgeInsetsGeometry padding;
  final VoidCallback onTap;

  const InfosButton(
      {required this.onTap, this.padding = const EdgeInsets.all(10)});

  @override
  State<StatefulWidget> createState() {
    return _InfosButtonState();
  }
}

class _InfosButtonState extends State<InfosButton> {
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
        _focusColor = Colors.blue;
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
    return Material(
        color: Colors.transparent,
        child: Container(
            foregroundDecoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(width: 2, color: _focusColor)),
            child: button()));
  }

  Widget button() {
    return InkWell(
        focusNode: _node,
        borderRadius: BorderRadius.all(Radius.circular(30)),
        onTap: widget.onTap,
        child:
            Padding(padding: widget.padding, child: Icon(Icons.info_outline)));
  }
}
