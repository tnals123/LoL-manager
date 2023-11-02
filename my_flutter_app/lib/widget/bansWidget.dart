import 'package:flutter/material.dart';
import 'package:my_flutter_app/controller/banController.dart';
import 'package:get/get.dart';

class BansWidget extends StatelessWidget {
  final bool isBlueTeam;

  BansWidget({Key? key, required this.isBlueTeam}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BanController controller = Get.put(BanController());

    return Obx(() {
      List<Widget> children = [];
      for (int i = 0; i < 5; i++) {
        // 벤 위젯 추가
        var banData = isBlueTeam ? controller.blueTeamBans[i] : controller.redTeamBans[i];
        children.add(
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: banData['state'] == 'blinking' && controller.isBlinking.value && controller.currentStep > 0
                  ? (isBlueTeam ? Colors.blue : Colors.red)
                  : Colors.transparent,
            ),
            child: Stack(
              children: [
              if (banData['champion']!.isNotEmpty) 
                Positioned.fill(
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 300),
                    opacity: (banData['state'] == 'blinking' && controller.isBlinking.value) && controller.currentStep > 0 ? 0.5 : 1.0, // 깜박임 효과 적용
                    child: Image.network(
                      "https://ddragon.leagueoflegends.com/cdn/13.19.1/img/champion/${banData['champion']}.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned.fill(
                  child: CustomPaint(painter: SlashPainter()),
                ),
              ],
            ),
          ),
        );

        // 마지막 벤이 아니면 구분선 추가
        if (i < 4) {
          children.add(
            Container(
              width: 2,
              height: 60, // 높이를 벤 위젯과 동일하게 설정
              color: Color(0xFF453A3A),
              margin: const EdgeInsets.only(top: 4,bottom: 4),
            ),
          );
        }
      }

      return Row(children: children);
    });
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
