import 'package:flutter/material.dart';
import 'package:jellyflut/components/back_button.dart' as back_button;

class DetailHeaderBar extends StatelessWidget {
  final double height;
  final Color color;
  final bool showDarkGradient;

  DetailHeaderBar(
      {Key? key,
      required this.height,
      required this.color,
      this.showDarkGradient = true})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final paddingTop = MediaQuery.of(context).padding.top;
    return Stack(children: [
      IgnorePointer(child: gradientBackground()),
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
                back_button.BackButton(
                  shadow: true,
                )
              ],
            ),
          ],
        ),
      ),
    ]);
  }

  Widget gradientBackground() {
    return Container(
        height: height,
        padding: EdgeInsets.only(left: 10, right: 10),
        decoration: showDarkGradient
            ? BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black54,
                    Colors.black45,
                    Colors.transparent,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0, 0.6, 1],
                ),
              )
            : BoxDecoration());
  }
}
