import 'package:flutter/material.dart';


class SlashPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2;

    // 대각선 그리기 (오른쪽 상단에서 왼쪽 하단으로)
    canvas.drawLine(Offset(size.width - 10, 10), Offset(10, size.height - 10), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}