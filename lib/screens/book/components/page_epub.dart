import 'package:epubx/epubx.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_html/flutter_html.dart';

class PageEpub extends StatelessWidget {
  final EpubTextContentFile? content;
  const PageEpub({Key? key, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final height = MediaQuery.of(context).size.height;
    // final nbLines = height / 18;
    final html = Html(
      data: content?.Content ?? '',
      style: {
        'html': Style(
            backgroundColor: Color.fromARGB(255, 251, 240, 217),
            color: Colors.black,
            // maxLines: nbLines.round(),
            // textOverflow: TextOverflow.ellipsis,
            fontFamily: 'Times new roman',
            fontSize: FontSize(18)),
      },
    );
    return Container(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
      decoration: BoxDecoration(color: Color.fromARGB(255, 251, 240, 217)),
      child: SingleChildScrollView(child: html),
    );
  }
}
