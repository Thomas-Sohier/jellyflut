import 'dart:math';
import 'dart:ui';

// Thanks to jamesblasco for this repo for the original code
// https://github.com/jamesblasco/flutter_lava_clock
// The code has been updated to Flutter 2.0

class ForcePoint<T extends double> {
  var x, y;

  T get magnitude => x * x + y * y;

  ForcePoint(this.x, this.y);

  double computed = 0;
  double force = 0;

  ForcePoint<T> add(ForcePoint<T> point) => ForcePoint(point.x + x, point.y + y);

  ForcePoint copyWith({T? x, T? y}) => ForcePoint(x ?? this.x, y ?? this.y);
}

class Ball {
  late ForcePoint velocity;
  late ForcePoint pos;
  late double size;

  Ball(Size size) {
    double vel({double ratio = 1}) => (Random().nextDouble() > .5 ? 1 : -1) * (.2 + .25 * Random().nextDouble());
    velocity = ForcePoint(vel(ratio: 0.25), vel());

    var i = .1;
    var h = 1.5;

    double calculatePosition(double fullSize) => Random().nextDouble() * fullSize;
    pos = ForcePoint(calculatePosition(size.width), calculatePosition(size.height));

    this.size = size.shortestSide / 15 + (Random().nextDouble() * (h - i) + i) * (size.shortestSide / 15);
  }

  void moveIn(Size size) {
    if (pos.x >= size.width - this.size) {
      if (pos.x > 0) velocity.x = -velocity.x;
      pos = pos.copyWith(x: size.width - this.size);
    } else if (pos.x <= this.size) {
      if (velocity.x < 0) velocity.x = -velocity.x;
      pos.x = this.size;
    }
    if (pos.y >= size.height - this.size) {
      if (velocity.y > 0) velocity.y = -velocity.y;
      pos.y = size.height - this.size;
    } else if (pos.y <= this.size) {
      if (velocity.y < 0) velocity.y = -velocity.y;
      pos.y = this.size;
    }
    pos = pos.add(velocity);
  }
}
