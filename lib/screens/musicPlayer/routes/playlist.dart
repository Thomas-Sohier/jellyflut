import 'package:flutter/material.dart';

class Playlist extends StatelessWidget {
  const Playlist({Key? key, required this.body}) : super(key: key);

  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title:
                Text('Playlist', style: Theme.of(context).textTheme.headline5)),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: body);
  }
}
