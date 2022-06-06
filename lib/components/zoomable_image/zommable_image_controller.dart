import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';

class ZoomableImageController {
  bool _animationControllerMounted = false;
  AnimationController? _controller;
  double scale = 1.0;

  AnimationController? get controller => _controller;

  void setController(AnimationController? controller, [Key? key]) {
    _controller = controller;
    _animationControllerMounted = true;
    print('$key has been mounted !');
  }

  ZoomableImageController();

  void zoomOut() {
    if (_animationControllerMounted) _controller?.reverse();
  }

  void zoom() {
    if (_animationControllerMounted) controller?.forward();
  }

  void dispose([Key? key]) {
    print('$key has been unmounted !');
    _animationControllerMounted = false;
  }
}
