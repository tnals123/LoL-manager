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
        var banData = isBlueTeam ? controller.blueTeamBans[i] : controller.redTeamBans[i];
        children.add(
          Stack(
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                width: Get.width * (15 / 375),
                height: Get.width * (15 / 375),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                child: banData['champion']!.isNotEmpty
                    ? Image.network(
                        "https://ddragon.leagueoflegends.com/cdn/13.19.1/img/champion/${banData['champion']}.png",
                        fit: BoxFit.cover,
                      )
                    : CustomPaint(painter: SlashPainter()),
              ),
              // 반짝이는 효과를 위한 컨테이너
              Positioned.fill(
                child: AnimatedOpacity(
                  duration: Duration(milliseconds: 300),
                  opacity: banData['state'] == 'blinking' && controller.isBlinking.value ? 1.0 : 0.0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      colors: [
                        isBlueTeam ?Color(0xFF5D4EC5) : Color(0xFF92252A), // 아래쪽 색상 (불투명)
                        isBlueTeam ?Color(0xFF5D4EC5).withOpacity(0.75) : Color(0xFF92252A).withOpacity(0.75),
                        isBlueTeam ?Color(0xFF5D4EC5).withOpacity(0.625) : Color(0xFF92252A).withOpacity(0.625),
                        isBlueTeam ?Color(0xFF5D4EC5).withOpacity(0.5) : Color(0xFF92252A).withOpacity(0.5),
                        isBlueTeam ?Color(0xFF5D4EC5).withOpacity(0.375) : Color(0xFF92252A).withOpacity(0.375),
                        isBlueTeam ? Color(0xFF5D4EC5).withOpacity(0.25) : Color(0xFF92252A).withOpacity(0.25),
                        isBlueTeam ? Color(0xFF5D4EC5).withOpacity(0.125) : Color(0xFF92252A).withOpacity(0.125),
                        isBlueTeam ?Color(0xFF5D4EC5).withOpacity(0.125) : Color(0xFF92252A).withOpacity(0.125),
                        isBlueTeam ?Color(0xFF5D4EC5).withOpacity(0.03) : Color(0xFF92252A).withOpacity(0.03)// 위쪽 색상 (완전 투명)
                      ],
                    stops: [0.0, 1/8, 2/8, 3/8, 4/8, 5/8, 6/8, 7/8, 1.0],

                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );

        // 마지막 벤이 아니면 구분선 추가
        if (i < 4) {
          children.add(
            Container(
              width: 2,
              height: Get.width * (15 / 375),
              color: Color(0xFF453A3A),
              margin: const EdgeInsets.only(top: 4, bottom: 4),
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
