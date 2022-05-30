import 'package:flutter/material.dart';
import 'package:jellyflut/globals.dart';

enum StreamingSoftware {
  VLC('VLC', [
    TargetPlatform.android,
    TargetPlatform.iOS,
    TargetPlatform.linux,
    TargetPlatform.macOS,
    TargetPlatform.windows
  ]),
  EXOPLAYER('Exoplayer', [TargetPlatform.android]),
  AVPLAYER('AVPlayer', [TargetPlatform.iOS]),
  MPV('MPV', []);

  final List<TargetPlatform> _supportedPlatforms;
  final String _name;

  const StreamingSoftware(this._name, this._supportedPlatforms);

  List<TargetPlatform> get supportedPlatforms => _supportedPlatforms;
  String get name => _name;

  /// Get video player options depending on current platform.
  /// You can provide a BuildContext or let function get it from global navigatorKey
  /// return [List<StreamingSoftware>], empty if no player available
  static List<StreamingSoftware> getVideoPlayerOptions(
      [BuildContext? context]) {
    context ??= currentContext;
    final currentPlatform = Theme.of(context).platform;

    return StreamingSoftware.values
        .where((soft) => soft._supportedPlatforms.contains(currentPlatform))
        .toList();
  }

  /// Get [StreamingSoftware] from name value
  static StreamingSoftware fromString(String name) {
    return StreamingSoftware.values
        .firstWhere((soft) => soft.name.toLowerCase() == name.toLowerCase());
  }
}
