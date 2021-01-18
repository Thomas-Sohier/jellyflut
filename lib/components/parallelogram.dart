import 'package:flutter/material.dart';

class MyParallelogram extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // var paint_0 = Paint()
    //   ..color = Colors.red
    //   ..style = PaintingStyle.stroke
    //   ..strokeWidth = 0.5;

    // var path_0 = Path();
    // path_0.moveTo(0, 0);
    // path_0.lineTo(size.width, 0);
    // path_0.lineTo(size.width, size.height);
    // path_0.lineTo(0, size.height);
    // path_0.lineTo(0, 0);
    // path_0.close();

    // canvas.drawPath(path_0, paint_0);

    var paint_1 = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    var path_1 = Path();
    path_1.moveTo(size.width * 0.0, size.height * 0.13);
    path_1.lineTo(size.width * 0.95, size.height * 0.13);
    path_1.lineTo(size.width * 0.80, size.height * 0.87);
    path_1.lineTo(size.width * 0.0, size.height * 0.87);
    path_1.lineTo(size.width * 0.0, size.height * 0.13);
    path_1.close();

    canvas.drawPath(path_1, paint_1);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
