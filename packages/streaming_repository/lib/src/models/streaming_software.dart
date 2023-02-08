import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'target_platform_extended.dart';

enum StreamingSoftware {
  VLC('VLC', [
    TargetPlatformExtended.android,
    TargetPlatformExtended.iOS,
    TargetPlatformExtended.linux,
    TargetPlatformExtended.macOS,
    TargetPlatformExtended.windows
  ]),
  HTMLPlayer('HTMLPlayer', [TargetPlatformExtended.web]),
  EXOPLAYER('Exoplayer', [TargetPlatformExtended.android]),
  AVPLAYER('AVPlayer', [TargetPlatformExtended.iOS]),
  MPV('MPV', []);

  final List<TargetPlatformExtended> _supportedPlatforms;
  final String _name;

  const StreamingSoftware(this._name, this._supportedPlatforms);

  List<TargetPlatformExtended> get supportedPlatforms => _supportedPlatforms;
  String get name => _name;

  /// Get video player options depending on current platform.
  /// You can provide a BuildContext or let function get it from global navigatorKey
  /// return [List<StreamingSoftware>], empty if no player available
  static List<StreamingSoftware> getVideoPlayerOptions(BuildContext context) {
    final currentPlatform =
        kIsWeb ? TargetPlatformExtended.web : TargetPlatformExtended.fromTargetPlatform(Theme.of(context).platform);

    return StreamingSoftware.values.where((soft) => soft._supportedPlatforms.contains(currentPlatform)).toList();
  }

  /// Get [StreamingSoftware] from name value
  static StreamingSoftware fromString(String name) {
    return StreamingSoftware.values.firstWhere((soft) => soft.name.toLowerCase() == name.toLowerCase());
  }
}
