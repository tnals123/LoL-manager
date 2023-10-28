import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_flutter_app/widget/bansWidget.dart';
import 'package:my_flutter_app/widget/timeBar.dart';
import 'package:my_flutter_app/widget/championGrid.dart';
import 'package:my_flutter_app/controller/championController.dart';

//flutter run -d web-server --web-port 8080
// lsof -i :8080
// kill -9 8080

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


class PickPage extends StatelessWidget {
  final championController = Get.put(ChampionsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.9),
      body: Stack(children: [ Column(
        children: [
                Obx(() => championController.showBlueTeamBoxes.value 
            ? _buildTeamBoxes(isBlueTeam: true) : Container()), // 블루팀 박스
      Obx(() => championController.showRedTeamBoxes.value 
            ? _buildTeamBoxes(isBlueTeam: false) : Container()), 
          Expanded(
              flex: 4,
              child: Row(
                children: [
                  const Expanded(
                    flex: 3,
                    child: SizedBox(),
                  ),
                  Expanded(flex: 4, child:
                  Expanded(
                    flex: 4,
                      child: Transform.translate(
                        offset: Offset(0, 50), // y축으로 50 만큼 이동
                        child: ChampionsView(),
                      ),
            
                  ),),
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
                color: const Color(0xFF171220),
                child: Row(
                  // 팀 박스들이 모인 부분을 Row로 변경
                  children: [
                    Expanded(flex: 5, child: _buildPlayerList(true)), // 파란팀
                    Expanded(flex : 2,child:Container(
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
                    ),),

                    Expanded(flex: 5, child: _buildPlayerList(false)), // 빨간팀
                  ],
                ),
              )),
        ],
      ),],)
    );
  }

  Widget _buildTeamBoxes({required bool isBlueTeam}) {
    // 박스를 표시하는 위젯 구현
    return Container(
      width: double.infinity,
      height: 200, // 박스 높이 설정
      child: ListView.builder(
        itemCount: 5, // 5개의 박스
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          // 박스 내용 구현
          return Container(
            width: 100,
            margin: EdgeInsets.all(10),
            color: isBlueTeam ? Colors.blue : Colors.red,
            // 여기에 선수 정보 등 추가
          );
        },
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
    final championController = Get.put(ChampionsController());
  return Container(
    color: const Color(0xFF171220),
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: Stack(
      children: [
        // 플레이어 위치에 따른 이미지
            Align(
      alignment: Alignment.topRight,
      child: InkWell(
        onTap: () => championController.toggleTeamBoxes(isBlueTeam),
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: Colors.blueGrey, // 버튼 배경 색
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.add, size: 18, color: Colors.white), // 버튼 아이콘
        ))),
        Align(
          alignment: Alignment.center,
          child: Image.asset(_getImageForPlayer(playerIndex, isBlueTeam)),
        ),
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
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
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




}
