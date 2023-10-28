import 'package:flutter/material.dart';

class BansWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5 * 2 - 1, (index) {
        if (index % 2 == 1) {
          return Container(
            color: Colors.black.withOpacity(0.75),
            height: 60,
            child: Container(
              margin: const EdgeInsets.only(top: 4, bottom: 4),
              width: 1,
              color: Color(0xFF5F5E59),
            )
             // 여기에 상단 및 하단 마진 추가
          );
        }
        return Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.75),
          ),
          child: CustomPaint(
            painter: SlashPainter(),
          ),
        );
      }),
    );
  }
}

class SlashPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Color(0xFF5F5E59)
      ..strokeWidth = 2;

    var startPoint = Offset(size.width * 0.2, size.height * 0.2);
    var endPoint = Offset(size.width * 0.8, size.height * 0.8);

    canvas.drawLine(startPoint, endPoint, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
