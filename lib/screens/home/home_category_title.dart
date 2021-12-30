import 'package:flutter/material.dart';
import 'package:jellyflut/models/jellyfin/item.dart';

class HomeCategoryTitle extends StatefulWidget {
  HomeCategoryTitle(this.item, {required this.onTap});

  final Item item;
  final VoidCallback onTap;

  @override
  _HomeCategoryTitleState createState() => _HomeCategoryTitleState();
}

class _HomeCategoryTitleState extends State<HomeCategoryTitle>
    with SingleTickerProviderStateMixin {
  late FocusNode _node;

  @override
  void initState() {
    _node = FocusNode(descendantsAreFocusable: false, skipTraversal: false);
    super.initState();
  }

  @override
  void dispose() {
    _node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return title();

    // TODO see if make the title clickable is a good UX Idea
    // return OutlinedButton(
    //   onPressed: widget.onTap,
    //   autofocus: false,
    //   focusNode: _node,
    //   style: OutlinedButton.styleFrom(
    //           padding: EdgeInsets.zero,
    //           shape: RoundedRectangleBorder(
    //             borderRadius: BorderRadius.all(Radius.circular(4)),
    //           ),
    //           backgroundColor: Colors.transparent)
    //       .copyWith(side: buttonBorderSide())
    //       .copyWith(padding: buttonPadding()),
    //   child: title(),
    // );
  }

  Widget title({final bool clickable = false}) {
    return Row(children: [
      Text(
        widget.item.name,
        style: TextStyle(color: Colors.white, fontSize: 28),
      ),
      Spacer(),
      if (clickable)
        InkWell(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          onTap: widget.onTap,
          child:
              Icon(Icons.chevron_right_rounded, color: Colors.white, size: 42),
        ),
    ]);
  }

  MaterialStateProperty<BorderSide> buttonBorderSide() {
    return MaterialStateProperty.resolveWith<BorderSide>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.focused)) {
          return BorderSide(
            width: 2,
            color: Colors.white,
          );
        }
        return BorderSide(width: 0, color: Colors.transparent);
      },
    );
  }

  MaterialStateProperty<EdgeInsetsGeometry> buttonPadding() {
    return MaterialStateProperty.resolveWith<EdgeInsetsGeometry>(
        (Set<MaterialState> states) {
      if (states.contains(MaterialState.focused)) {
        return EdgeInsets.only(left: 8);
      }
      return EdgeInsets.zero;
    });
  }
}
