import 'package:flutter/material.dart';

class LeftBanner extends CustomPainter {
  Color color;

  LeftBanner({this.color});

  @override
  void paint(Canvas canvas, Size size) {
    var paint_1 = Paint()
      ..color = color
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
