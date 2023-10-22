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
          _buildTeamNamesSection(), // 팀 이름 부분 추가
          _buildBanSection(),
          Expanded(
            child: Row(
              children: [
                Expanded(child: _buildPlayerList(true)),
                Expanded(flex: 2, child: _buildChampionSelection()),
                Expanded(
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: _buildPlayerList(false)))
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

  Widget _buildPlayerList(bool isLeftSide) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Expanded(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Column(
                children: [
                  _buildPlayerItem(
                      index, isLeftSide, constraints.maxWidth - 110),
                  Align(
                    alignment: isLeftSide
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    child: Divider(
                      color: Color(0xFF9d8d7f),
                      thickness: 0.5,
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildPlayerItem(int playerIndex, bool isLeftSide, double itemWidth) {
    return Container(
      height: Get.height/5-40,
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
                  //'https://ddragon.leagueoflegends.com/cdn/img/champion/loading/${championId}_0.jpg',
                  fit: BoxFit.cover,
                  alignment: const Alignment(0,-0.68),
                ));
              } else {
                return Container(); // 아무 챔피언도 선택되지 않았을 때의 기본 위젯
              }
            }),
          ),
          Align(
            alignment:
                isLeftSide ? Alignment.centerRight : Alignment.centerLeft,
            child: Row(
              mainAxisAlignment:
                  isLeftSide ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                if (!isLeftSide) ...[
                  const SizedBox(width: 0),
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: GestureDetector(
                          child: Container(
                            color: Colors.white,
                            width: 25,
                            height: 25,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: Get.height / 5 - 85,
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Text('Player ${playerIndex + 1}',
                            style: const TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                  SizedBox(width: itemWidth),
                ],
                if (isLeftSide) ...[
                  SizedBox(width: itemWidth),
                  Column(children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        child: Container(
                          color: Colors.white,
                          width: 25,
                          height: 25,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Get.height / 5 - 85,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text('Player ${playerIndex + 1}',
                          style: const TextStyle(color: Colors.white)),
                    )
                  ])
                ],
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
