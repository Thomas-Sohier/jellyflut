import 'package:epubx/epubx.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:simple_html_css/simple_html_css.dart';

class PageEpub extends StatelessWidget {
  final EpubTextContentFile? content;
  const PageEpub({Key? key, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final myRichText = HTML.toTextSpan(context, content?.Content?.trim() ?? '',
        defaultTextStyle: Theme.of(context)
            .textTheme
            .bodyText2!
            .copyWith(color: Colors.grey.shade900));
    return Container(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
      decoration: BoxDecoration(color: Colors.amber.shade100),
      child: SingleChildScrollView(
          child: Column(
        children: [
          SizedBox(height: 24),
          RichText(
            text: myRichText,
            textAlign: TextAlign.justify,
            softWrap: true,
          ),
          SizedBox(
            height: 16,
          )
        ],
      )),
    );
  }
}
