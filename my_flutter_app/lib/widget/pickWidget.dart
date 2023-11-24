import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_flutter_app/controller/banController.dart';
import 'package:my_flutter_app/controller/championController.dart';

String _getImageForPlayer(int playerIndex, bool isBlueTeam) {
  List<String> blueTeamOrder = [    
    'assets/image/supporter.png',
    'assets/image/bottom.png',
    'assets/image/mid.png',
    'assets/image/jungle.png',
    'assets/image/top.png'];
  List<String> redTeamOrder = [
    'assets/image/top.png',
    'assets/image/jungle.png',
    'assets/image/mid.png',
    'assets/image/bottom.png',
    'assets/image/supporter.png'
  ];

  if (isBlueTeam) {
    return blueTeamOrder[playerIndex];
  } else {
    return redTeamOrder[playerIndex];
  }
}

class PickWidget extends StatelessWidget {
  final bool isBlueTeam;
  final int playerIndex;

  PickWidget({Key? key, required this.isBlueTeam, required this.playerIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BanController banController = Get.find<BanController>();
    final ChampionsController championController = Get.find<ChampionsController>();

    void toggleSelection() {
      if (isBlueTeam) {
        championController.leftSelectedChampions[playerIndex] = !championController.leftSelectedChampions[playerIndex];
      } else {
        championController.rightSelectedChampions[playerIndex] = !championController.rightSelectedChampions[playerIndex];
      }
    }
    return Container(
      color: const Color(0xFF171220), // 백그라운드 색상
      child: Obx(() {
        var playerData = isBlueTeam ? banController.blueTeamPlayers[playerIndex] : banController.redTeamPlayers[playerIndex];
        return Stack(
          children: [

          Align(
            alignment: Alignment.center,
            child: Image.asset(_getImageForPlayer(playerIndex, isBlueTeam)),
          ),
          Positioned.fill(
            child: Obx(() {
              var playerData = isBlueTeam ? banController.blueTeamPlayers[playerIndex] : banController.redTeamPlayers[playerIndex];
              if (playerData['champion'].isNotEmpty) {
                return Transform.scale(
                  scale: 1,
                  child: Image.network(
                    'https://ddragon.leagueoflegends.com/cdn/img/champion/loading/${playerData['champion']}_0.jpg',
                    fit: BoxFit.cover,
                    alignment: const Alignment(0, -0.68),
                  ),
                );
              } else {
                return Container();
              }
            }),
          ),


            // 반짝이는 효과를 위한 컨테이너
          Positioned.fill(
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 300),
              opacity: playerData['state'] == 'blinking' && banController.isBlinking.value ? 1.0 : 0.0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                      colors:  [
                        isBlueTeam ?const Color(0xFF5D4EC5) : const Color(0xFF92252A), // 아래쪽 색상 (불투명)
                        isBlueTeam ?const Color(0xFF5D4EC5).withOpacity(0.75) : const  Color(0xFF92252A).withOpacity(0.75),
                        isBlueTeam ?const Color(0xFF5D4EC5).withOpacity(0.625) : const Color(0xFF92252A).withOpacity(0.625),
                        isBlueTeam ?const Color(0xFF5D4EC5).withOpacity(0.5) : const Color(0xFF92252A).withOpacity(0.5),
                        isBlueTeam ?const Color(0xFF5D4EC5).withOpacity(0.375) : const Color(0xFF92252A).withOpacity(0.375),
                        isBlueTeam ?const Color(0xFF5D4EC5).withOpacity(0.25) : const Color(0xFF92252A).withOpacity(0.25),
                        isBlueTeam ?const Color(0xFF5D4EC5).withOpacity(0.125) : const Color(0xFF92252A).withOpacity(0.125),
                        isBlueTeam ?const Color(0xFF5D4EC5).withOpacity(0.125) : const Color(0xFF92252A).withOpacity(0.125),
                        isBlueTeam ?const Color(0xFF5D4EC5).withOpacity(0.03) : const Color(0xFF92252A).withOpacity(0.03)// 위쪽 색상 (완전 투명)
                      ],
                    stops: [0.0, 1/8, 2/8, 3/8, 4/8, 5/8, 6/8, 7/8, 1.0],
                  ),
                ),
              ),
            ),
          ),
                    // 플레이어 위치에 따른 이미지
          Align(
            alignment: Alignment.topRight,
            child: Obx(() {
              var playerData = isBlueTeam ? banController.blueTeamPlayers[playerIndex] : banController.redTeamPlayers[playerIndex];
              return InkWell(
                onTap: (){
                  toggleSelection();
                  print("afsdfsadfsafasasf");
                },
                child: Container(
                  width: Get.width * (8 / 375),
                  height: Get.width * (8 / 375),
                  decoration: BoxDecoration(
                    color: (isBlueTeam 
                      ? championController.leftSelectedChampions[playerIndex] 
                      : championController.rightSelectedChampions[playerIndex]) 
                      ? Colors.green : Colors.blueGrey,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.add, size: 18, color: Colors.white),
                ),
              );
            }),
          ),
          
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(height: 10),
                Text('Player ${playerIndex + 1}',
                    style: TextStyle(color: Colors.white, fontSize: Get.width * (3 / 375))),
              ],
            ),
          ),

          ],
        );
      }),
    );


  }
}

