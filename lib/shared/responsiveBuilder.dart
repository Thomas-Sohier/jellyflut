import 'package:flutter/widgets.dart';
import 'package:jellyflut/globals.dart';
import 'package:responsive_builder/responsive_builder.dart';

class ResponsiveBuilder {
  static final ScreenBreakpoints _screenBreakpoints =
      ScreenBreakpoints(tablet: 600, desktop: 720, watch: 300);

  static Widget builder(
      {required Widget Function() mobile,
      required Widget Function() tablet,
      required Widget Function() desktop,
      Widget Function()? tv,
      ScreenBreakpoints? breakpoints}) {
    if (isAndroidTv) {
      return tv == null ? desktop() : tv();
    }
    return ScreenTypeLayout.builder(
        breakpoints: breakpoints ?? _screenBreakpoints,
        mobile: (BuildContext context) => mobile(),
        tablet: (BuildContext context) => tablet(),
        desktop: (BuildContext context) => desktop());
  }
}
