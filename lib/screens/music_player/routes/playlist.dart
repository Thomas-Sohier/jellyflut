import 'package:flutter/material.dart';

class Playlist extends StatelessWidget {
  const Playlist({super.key, required this.body});

  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Playlist', style: Theme.of(context).textTheme.headlineSmall)),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: body);
  }
}
