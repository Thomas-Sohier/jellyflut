import 'package:flutter/cupertino.dart';

enum TargetPlatformExtended {
  /// Android: <https://www.android.com/>
  android,

  /// Fuchsia: <https://fuchsia.dev/fuchsia-src/concepts>
  fuchsia,

  /// iOS: <https://www.apple.com/ios/>
  iOS,

  /// Linux: <https://www.linux.org>
  linux,

  /// macOS: <https://www.apple.com/macos>
  macOS,

  /// Windows: <https://www.windows.com>
  windows,

  /// Web
  web;

  static TargetPlatformExtended? fromTargetPlatform(TargetPlatform target) {
    return TargetPlatformExtended.values.firstWhere((e) => e.name == target.name);
  }
}
