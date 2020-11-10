import 'package:flutter/material.dart';

class Skeleton extends StatefulWidget {
  final double height;
  final double width;
  final int nbLine;
  final List<Color> colors;

  Skeleton(
      {Key key,
      this.height = 15,
      this.width = 200,
      this.nbLine = 1,
      this.colors = const [Colors.black12, Colors.black26, Colors.black12]})
      : super(key: key);

  @override
  SkeletonState createState() => SkeletonState();
}

class SkeletonState extends State<Skeleton>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  Animation gradientPosition;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: Duration(milliseconds: 1500), vsync: this);

    gradientPosition = Tween<double>(
      begin: -3,
      end: 10,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    )..addListener(() {
        setState(() {});
      });

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var list = List<int>.generate(widget.nbLine, (i) => i + 1);
    return Column(
      children: list.map((e) => skeleton()).toList(),
    );
  }

  Widget skeleton() {
    return Padding(
        padding: EdgeInsets.all(4),
        child: Container(
            width: double.infinity,
            height: widget.height,
            decoration: BoxDecoration(
                color: Colors.white,
                gradient: LinearGradient(
                    begin: Alignment(gradientPosition.value, 0),
                    end: Alignment(-1, 0),
                    colors: widget.colors))));
  }
}
