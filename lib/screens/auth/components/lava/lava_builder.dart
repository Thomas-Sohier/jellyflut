import 'package:flutter/material.dart';

import 'lava_painter.dart';

// Thanks to jamesblasco for this repo for the original code
// https://github.com/jamesblasco/flutter_lava_clock
// The code has been updated to Flutter 2.0

/// Lava clock.
class LavaBuilder extends StatefulWidget {
  final AnimationController? animationController;
  final Widget child;

  const LavaBuilder({this.animationController, this.child = const SizedBox()});

  @override
  State<LavaBuilder> createState() => _LavaBuilderState();
}

class _LavaBuilderState extends State<LavaBuilder> with TickerProviderStateMixin {
  late Lava lava;
  late AnimationController _animation;
  late List<Color> colors;
  late TweenSequence<Color?> tweenColors;

  @override
  void initState() {
    super.initState();
    lava = Lava(6);
    _animation = widget.animationController ?? AnimationController(duration: Duration(minutes: 5), vsync: this);
    _animation.repeat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    colors = initColors();
    tweenColors = initTweenColors();
  }

  @override
  void dispose() {
    _animation.dispose();
    super.dispose();
  }

  List<Color> initColors() {
    final colors = <Color>[];
    colors.add(Theme.of(context).colorScheme.primary);
    colors.add(Theme.of(context).colorScheme.tertiary);
    colors.add(Theme.of(context).colorScheme.secondary);
    return colors;
  }

  TweenSequence<Color?> initTweenColors() {
    return TweenSequence<Color?>(colors
        .asMap()
        .map(
          (index, color) => MapEntry(
            index,
            TweenSequenceItem(
              weight: 1.0,
              tween: ColorTween(
                begin: color,
                end: colors[index + 1 < colors.length ? index + 1 : 0],
              ),
            ),
          ),
        )
        .values
        .toList());
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Theme.of(context).colorScheme.brightness == Brightness.light ? Colors.white : Colors.black;
    return LayoutBuilder(
        builder: (context, constraints) => AnimatedContainer(
              duration: Duration(seconds: 1),
              color: backgroundColor,
              child: AnimatedBuilder(
                  animation: _animation,
                  child: widget.child,
                  builder: (BuildContext context, child) {
                    final color = tweenColors.evaluate(AlwaysStoppedAnimation(_animation.value));
                    return Container(
                        color: color!.withOpacity(0.6),
                        child: CustomPaint(painter: LavaPainter(lava, color: color), child: child));
                  }),
            ));
  }
}
