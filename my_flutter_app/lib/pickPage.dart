import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'class/champion.dart';
import 'controller/championController.dart';

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
    backgroundColor: Colors.black,
    body: Column(
      children: [
                Expanded(flex: 4, child: _buildChampionSelection()), // 이 부분은 유지
        Expanded( flex: 1,
          child: Row( // 팀 박스들이 모인 부분을 Row로 변경
            children: [
              Expanded(flex : 1 , child: _buildPlayerList(true)), // 파란팀
              Container(
                width: 100, // 예를 들어 팀 이름 창을 100의 너비로 설정
                child: _buildTeamNamesSection(),
              ),
              Expanded(flex : 1, child: _buildPlayerList(false)), // 빨간팀
            ],
          ),
        ),
      ],
    ),
  );
}

  Widget _buildTeamNamesSection() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "팀 A",
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
          Text(
            "팀 B",
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        ],
      ),
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
  return Row(
    children: List.generate(5 * 2 - 1, (index) { 
      if (index % 2 == 1) {
        return Container(
          color: Colors.black,
          height: double.infinity,
          child: VerticalDivider(
            width: 1, // 구분선의 두께
            color: Colors.white,
            indent: 10, // 구분선의 상단 공백
            endIndent: 10, // 구분선의 하단 공백
          ),
        );
      }
      return Expanded(child: _buildPlayerItem(index ~/ 2, isBlueTeam)); // index를 2로 나눈 몫을 사용하여 플레이어 인덱스를 찾습니다.
    }),
  );
}


Widget _buildPlayerItem(int playerIndex, bool isBlueTeam) {
  return Container(
    color : Colors.black,
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: Stack(
      children: [
        Positioned.fill(
          child: Obx(() {
            final championId = championController.selectedChampions[playerIndex];
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
          alignment: isBlueTeam ? Alignment.centerLeft : Alignment.centerRight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                child: Container(
                  color: Colors.white,
                  width: 25,
                  height: 25,
                ),
              ),
              const SizedBox(height: 10),
              Text('Player ${playerIndex + 1}', style: const TextStyle(color: Colors.white)),
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
            for (int i = 0; i < 5; i++) ...[
              Container(
                width: 15,
                height: 15,
                child: Image.asset('assets/image/beforeBan.png'),
              ),
              const SizedBox(width: 20),
            ],
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: '챔피언 검색',
                  fillColor: Colors.grey[800],
                  filled: true,
                  border: const OutlineInputBorder(),
                ),
              ),
            )
          ],
        ),
        Expanded(child: _buildChampionGrid()),
      ],
    );
  }

  Widget _buildChampionGrid() {
  final controller = Get.put(ChampionsController());

  return Stack(
    children: [
      Obx(() {
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
            childAspectRatio: 2 / 3,
          ),
          itemCount: controller.champions.length,
          itemBuilder: (context, index) {
            Champion champion = controller.champions[index];
            return Column(
              children: [
                SizedBox(
                  width: 70.0,
                  height: 70.0,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.red,
                        width: 1.0,
                      ),
                    ),
                    child: Image.network(
                      'https://ddragon.leagueoflegends.com/cdn/13.19.1/img/champion/${champion.id}.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  champion.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
              ],
            );
          },
        );
      }),
      Positioned(
        bottom: 100, // GridView 바닥에서부터 10 픽셀 떨어지게 함
        left: 0,
        right: 0,
        child: Center(
          child: SizedBox(
            width: 200,
            child: ElevatedButton(
              onPressed: () {
                // 버튼 클릭 시 수행할 로직
              },
              child: Text("선택"),
            ),
          ),
        ),
      ),
    ],
  );
}


}
