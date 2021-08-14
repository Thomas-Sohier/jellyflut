import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BackButton extends StatefulWidget {
  final bool shadow;

  const BackButton({Key? key, this.shadow = false}) : super(key: key);

  @override
  _BackButtonState createState() => _BackButtonState();
}

class _BackButtonState extends State<BackButton> {
  late final FocusNode _node;
  late final Color _focusColor;
  late final List<BoxShadow> shadows;

  @override
  void initState() {
    _focusColor = Colors.transparent;
    _node = FocusNode(descendantsAreFocusable: false, skipTraversal: false);
    _node.addListener(_onFocusChange);
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
      decoration: BoxDecoration(boxShadow: shadows),
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
