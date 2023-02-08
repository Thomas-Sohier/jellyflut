import 'package:flutter/widgets.dart';
import 'package:jellyflut/globals.dart';

/// LayoutBuilder but with a complementary property.
///
/// It adds a [LayoutType] property which help identify current screen type.
///
/// It allow developer to rely on app wide breakpoint. But it's not necessary
/// to use this property for responsiveness based on content or layout.
///
/// Be aware that androidTv layoutType is no based on screen size but rather on
/// property loaded during [main] execution. It can helps building layout depending on
/// specific devices too.
class LayoutBuilderScreen extends StatelessWidget {
  final Widget Function(BuildContext, BoxConstraints, LayoutType) builder;
  const LayoutBuilderScreen({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return builder(context, constraints, guessLayoutType(constraints));
    });
  }

  LayoutType guessLayoutType(BoxConstraints constraints) {
    if (isAndroidTv) return LayoutType.androidTv;
    if (constraints.maxWidth < 600) return LayoutType.mobile;
    if (constraints.maxWidth < 960) return LayoutType.tablet;
    return LayoutType.desktop;
  }
}

enum LayoutType {
  mobile,
  tablet,
  androidTv,
  desktop;

  const LayoutType();

  bool get isMobile => this == mobile;
  bool get isTablet => this == tablet;
  bool get isDesktop => this == desktop;
  bool get isAndroidTv => this == androidTv;
}
