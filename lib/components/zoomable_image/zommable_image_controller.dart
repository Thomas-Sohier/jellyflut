import 'package:flutter/animation.dart';

class ZoomableImageController {
  AnimationController? controller;
  double scale = 1.0;

  ZoomableImageController();

  void zoomOut() {
    controller?.reverse();
  }

  void zoom() {
    controller?.forward();
  }
}
