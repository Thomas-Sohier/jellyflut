import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class PlaylistPage extends StatelessWidget {
  const PlaylistPage({super.key, required this.body});

  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Playlist', style: Theme.of(context).textTheme.headlineSmall)),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: body,
    );
  }
}
