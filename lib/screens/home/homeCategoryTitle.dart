import 'package:flutter/material.dart';
import 'package:jellyflut/models/item.dart';

class HomeCategoryTitle extends StatefulWidget {
  HomeCategoryTitle(this.item, {@required this.onTap});

  final Item item;
  final VoidCallback onTap;

  @override
  _HomeCategoryTitleState createState() => _HomeCategoryTitleState();
}

class _HomeCategoryTitleState extends State<HomeCategoryTitle>
    with SingleTickerProviderStateMixin {
  final BoxShadow boxShadowColor1 =
      BoxShadow(blurRadius: 4, color: Colors.black12, spreadRadius: 2);
  final BoxShadow boxShadowColor2 =
      BoxShadow(blurRadius: 4, color: Colors.black12, spreadRadius: 2);
  String heroTag;
  FocusNode _node;
  Color _focusColor;

  Widget image;

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
    return RawMaterialButton(
        onPressed: widget.onTap,
        focusNode: _node,
        focusColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        focusElevation: 0,
        autofocus: false,
        child: Container(
            decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(width: 2, color: _focusColor),
                borderRadius: BorderRadius.all(Radius.circular(5))),
            child: Row(children: [
              Text(
                widget.item.name,
                style: TextStyle(color: Colors.white, fontSize: 28),
              ),
              Spacer(),
              InkWell(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  child: Icon(Icons.chevron_right_rounded,
                      color: Colors.white, size: 42),
                  onTap: widget.onTap),
            ])));
  }
}
