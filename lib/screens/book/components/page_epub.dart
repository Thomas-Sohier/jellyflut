import 'package:flutter/material.dart';

class PageEpub extends StatelessWidget {
  final String? content;
  const PageEpub({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    // final height = MediaQuery.of(context).size.height;
    // final nbLines = height / 18;
    return Container(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
      decoration: BoxDecoration(color: Color.fromARGB(255, 251, 240, 217)),
      child: SingleChildScrollView(child: Text(content ?? '')),
    );
  }
}
