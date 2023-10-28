import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_flutter_app/widget/bansWidget.dart';
import 'package:my_flutter_app/widget/timeBar.dart';
import 'package:my_flutter_app/widget/championGrid.dart';

//flutter run -d web-server --web-port 8080
// lsof -i :8080
// kill -9 8080

class ChampionController extends GetxController {
  var selectedChampions = List<String?>.filled(10, null).obs;

  void selectChampion(int index, String championName) {
    selectedChampions[index] = championName;
  }
}

class PickPage extends StatelessWidget {
  final championController = Get.put(ChampionController());

  final List<String> roleImages = [
    'assets/image/top.png',
    'assets/image/jungle.png',
    'assets/image/mid.png',
    'assets/image/bottom.png',
    'assets/image/supporter.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.9),
      body: Column(
        children: [
          const SizedBox(height: 30),
          Expanded(
              flex: 4,
              child: Row(
                children: [
                  const Expanded(
                    flex: 3,
                    child: SizedBox(),
                  ),
                  Expanded(flex: 4, child: ChampionsView()),
                  const Expanded(flex: 3, child: SizedBox())
                ],
              )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [BansWidget(),BansWidget()],
              ),
          TimerBar(), // 타임 바
          Expanded(
              flex: 1,
              child: Container(
                color: const Color(0xFF1D1728),
                child: Row(
                  // 팀 박스들이 모인 부분을 Row로 변경
                  children: [
                    Expanded(flex: 1, child: _buildPlayerList(true)), // 파란팀
                    Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(top: 10, bottom: 10),
                      width: 300,
                      // 팀 이름 창의 너비
                      decoration: const BoxDecoration(
                        border: Border(
                          left: BorderSide(
                              color: Color(0xFF342E41), width: 2.0), // 왼쪽 선
                          right: BorderSide(
                              color: Color(0xFF342E41), width: 2.0), // 오른쪽 선
                        ),
                      ),
                      child: _buildTeamNamesSection(),
                    ),
                    Expanded(flex: 1, child: _buildPlayerList(false)), // 빨간팀
                  ],
                ),
              )),
        ],
      ),
    );
  }



  Widget _buildTeamNamesSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch, // 가로축을 꽉 채우도록
      children: [
        // 상단에 위치할 텍스트들
        Text("GRAND FINALS",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold)),
        Text("PATCH 13.20",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 13)),
        Expanded(
          child: Center(
            // Center 위젯으로 감싸서 중앙에 위치하도록 함
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "팀 A",
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
                SizedBox(width: 20), // 팀 이름 사이 간격
                Text(
                  "팀 B",
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ],
            ),
          ),
        ),
        Padding(padding: EdgeInsets.only(bottom: 20))
      ],
    );
  }

  Widget _buildBanSection() {
    return Row(
      children: [
        Expanded(child: _buildBannedChampions(true)),
        const Expanded(
          flex: 2,
          child: Column(
            children: [
              Text('다른 플레이어를 기다려 주세요'),
            ],
          ),
        ),
        Expanded(child: _buildBannedChampions(false)),
      ],
    );
  }

  Widget _buildBannedChampions(bool isLeftSide) {
    return Column(
      children: [
        Row(
          mainAxisAlignment:
              isLeftSide ? MainAxisAlignment.start : MainAxisAlignment.end,
          children: List.generate(
            5,
            (index) => Row(
              children: [
                SizedBox(
                  width: 40.0,
                  height: 40.0,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFF474545), // 회색 테두리
                        width: 1.0, // 테두리 두께
                      ),
                    ),
                    child: Image.asset('assets/image/beforeBan.png'),
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10), // 간격 조정
        const LinearProgressIndicator(value: 0.7, color: Colors.red),
        const SizedBox(height: 10) // 추가된 LinearProgressIndicator
      ],
    );
  }

  Widget _buildPlayerList(bool isBlueTeam) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10), // 여기에서 패딩 적용
      child: Row(
        children: List.generate(5 * 2 - 1, (index) {
          if (index % 2 == 1) {
            return VerticalDivider(
              width: 1,
              color: Color(0xFF342E41),
            );
          }
          return Expanded(
            child: _buildPlayerItem(index ~/ 2, isBlueTeam),
          );
        }),
      ),
    );
}


  Widget _buildPlayerItem(int playerIndex, bool isBlueTeam) {
    return Container(
      color: const Color(0xFF1D1728),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Stack(
        children: [
          Positioned.fill(
            child: Obx(() {
              final championId =
                  championController.selectedChampions[playerIndex];
              if (championId != null) {
                return Transform.scale(
                  scale: 0.95,
                  child: Image.network(
                    'http://ddragon.leagueoflegends.com/cdn/img/champion/loading/${championId}_0.jpg',
                    fit: BoxFit.cover,
                    alignment: const Alignment(0, -0.68),
                  ),
                );
              } else {
                return Container();
              }
            }),
          ),
          Align(
            alignment:
                isBlueTeam ? Alignment.centerLeft : Alignment.centerRight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Text('Player ${playerIndex + 1}',
                    style: const TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChampionSelection() {
    return Column(
      children: [
        Row(
          children: [
            // for (int i = 0; i < 5; i++) ...[
            //   Container(
            //     width: 15,
            //     height: 15,
            //     child: Image.asset('assets/image/beforeBan.png'),
            //   ),
            //   const SizedBox(width: 20),
            // ],
            // Expanded(
            //   child: TextField(
            //     decoration: InputDecoration(
            //       hintText: '챔피언 검색',
            //       fillColor: Colors.grey[800],
            //       filled: true,
            //       border: const OutlineInputBorder(),
            //     ),
            //   ),
            // )
          ],
        ),
        Expanded(child: ChampionsView()),
      ],
    );
  }


}
