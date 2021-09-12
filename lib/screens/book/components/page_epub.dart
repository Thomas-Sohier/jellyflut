import 'package:epubx/epubx.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:html/parser.dart' as htmlparser;
import 'package:html/dom.dart' as dom;
import 'package:flutter_html/flutter_html.dart';
import 'package:xml/xml.dart';

class PageEpub extends StatelessWidget {
  final EpubTextContentFile? content;
  const PageEpub({Key? key, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final nbLines = height / 18;
    // final document = htmlparser.parse(content?.Content ?? '',
    //     generateSpans: false, encoding: 'Utf-8');
    // final text = document.body?.text.trim() ?? '';
    // final regexTwoSpaces = r'[ ]{2,}';
    // final regExpTwoSpaces = RegExp(regexTwoSpaces);
    // final regexTwoLineBreaks = r'\n\n\n+';
    // final regExpTwoLineBreaks = RegExp(regexTwoLineBreaks);
    // final parsedContent = text
    //     .replaceAll('	', '')
    //     .replaceAll(regExpTwoSpaces, '')
    //     // .replaceAll(regExpTwoLineBreaks, '\n')
    //     .trim();
    Widget html = Html(
      data: content?.Content ?? '',
      style: {
        'html': Style(
            backgroundColor: Colors.yellow.shade100,
            color: Colors.grey.shade900,
            maxLines: nbLines.round(),
            textOverflow: TextOverflow.ellipsis,
            fontFamily: 'Times new roman',
            fontSize: FontSize(18)),
      },
    );
    return Container(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
      decoration: BoxDecoration(color: Colors.yellow.shade100),
      child: SingleChildScrollView(
          child: Column(
        children: [
          // SizedBox(height: 24),
          html,
          // Text(
          //   parsedContent,
          //   style: TextStyle(color: Colors.grey.shade900),
          //   softWrap: false,
          //   textAlign: TextAlign.justify,
          //   maxLines: nbLines.round(),
          // ),
          // SizedBox(
          //   height: 16,
          // )
        ],
      )),
    );
  }
}
