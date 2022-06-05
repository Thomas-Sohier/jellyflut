import 'package:flutter/animation.dart';
import 'package:flutter/rendering.dart';

class ZoomableImageController {
  AnimationController? _controller;
  double _scale = 1.0;

  double get scale => _scale;
  set scale(double scale) {
    _scale = scale;
  }

  AnimationController? get controller => _controller;
  set controller(AnimationController? controller) {
    _controller = controller;
  }

  ZoomableImageController();

  void zoomOut() {
    _controller?.reverse();
  }

  void zoom() {
    _controller?.forward();
  }

  void dispose() {
    _controller?.dispose();
  }
}
