import 'package:flutter/animation.dart';

class ZoomableImageController {
  bool _animationControllerMounted = false;
  AnimationController? _controller;
  double scale = 1.0;

  AnimationController? get controller => _controller;

  void setController(AnimationController? controller) {
    _controller = controller;
    _animationControllerMounted = true;
  }

  ZoomableImageController();

  void zoomOut() {
    if (_animationControllerMounted) _controller?.reverse();
  }

  void zoom() {
    if (_animationControllerMounted) controller?.forward();
  }

  void dispose() {
    _animationControllerMounted = false;
  }
}
