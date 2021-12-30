import 'package:flutter/material.dart';

class Playlist extends StatelessWidget {
  const Playlist({Key? key, required this.body}) : super(key: key);

  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Playlist')),
        backgroundColor: Theme.of(context).backgroundColor,
        body: body);
  }
}
