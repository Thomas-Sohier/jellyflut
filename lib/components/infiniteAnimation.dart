import 'package:flutter/widgets.dart';

class InfiniteAnimation extends StatefulWidget {
  final Widget child;
  final int durationInSeconds;

  InfiniteAnimation({
    required this.child,
    this.durationInSeconds = 2,
  });

  @override
  _InfiniteAnimationState createState() => _InfiniteAnimationState();
}

class _InfiniteAnimationState extends State<InfiniteAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.durationInSeconds),
    );
    animation = Tween<double>(
      begin: 0,
      end: 12.5664, // 2Radians (360 degrees)
    ).animate(animationController);

    animationController.forward();

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController.repeat();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) => Transform.rotate(
        angle: animation.value,
        child: widget.child,
      ),
    );
  }
}
