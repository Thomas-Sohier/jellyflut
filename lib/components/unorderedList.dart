import 'dart:ui';

import 'package:flutter/material.dart';

class UnorderedList extends StatelessWidget {
  final List<String> texts;
  final Color textColor;
  final double textSize;

  const UnorderedList(
      {required this.texts, this.textColor = Colors.black, this.textSize = 16});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: texts.length,
      shrinkWrap: true,
      padding: EdgeInsets.only(top: 0, left: 10),
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        var text = texts[index];
        return Text(
          '• $text',
          style: TextStyle(color: textColor, fontSize: textSize),
        );
      },
    );
  }
}
