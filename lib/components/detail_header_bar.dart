import 'package:flutter/material.dart';
import 'package:jellyflut/components/back_button.dart' as back_button;

class DetailHeaderBar extends StatelessWidget {
  final double height;

  DetailHeaderBar({super.key, required this.height});
  @override
  Widget build(BuildContext context) {
    final paddingTop = MediaQuery.of(context).padding.top == 0
        ? 12.0
        : MediaQuery.of(context).padding.top;
    return Stack(children: [
      SizedBox(
        height: height + paddingTop,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: paddingTop),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                back_button.SelectableBackButton(
                  shadow: true,
                )
              ],
            ),
          ],
        ),
      ),
    ]);
  }
}
