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
                Expanded(child: Align(alignment: Alignment.centerRight, child: _buildPlayerList(false)))
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
              LinearProgressIndicator(value: 0.7, color: Colors.red)
            ],
          ),
        ),
        Expanded(child: _buildBannedChampions(false)),
      ],
    );
  }

  Widget _buildBannedChampions(bool isLeftSide) {
    return Row(
      mainAxisAlignment: isLeftSide ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: List.generate(5, (index) => const Icon(Icons.block, color: Colors.red)),
    );
  }

  Widget _buildPlayerList(bool isLeftSide) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        final playerIndex = isLeftSide ? index : index + 5;
        return Column(
          children : [
            const SizedBox(height : 10),
            _buildPlayerItem(playerIndex, isLeftSide),
            const SizedBox(height:10),
            const Divider(color : Colors.yellow)
          ]
        );
      },
    );
  }

  Widget _buildPlayerItem(int playerIndex, bool isLeftSide) {
    return Container(
      height: 60, 
      padding: const EdgeInsets.symmetric(horizontal: 16.0), 
      child: Row(
        mainAxisAlignment: 
            isLeftSide ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (!isLeftSide) ...[ 
            Text('Player ${playerIndex + 1}', style: const TextStyle(color: Colors.white)),
            const SizedBox(width: 10),
          ],
          Container(
            width: 75.0, 
            height: 75.0, 
            decoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Obx(() {
                return Text(championController.selectedChampions[playerIndex] ?? "");
              }),
            ),
          ),
          if (isLeftSide) ...[ 
            const SizedBox(width: 10),
            Text('Player ${playerIndex + 1}', style: const TextStyle(color: Colors.white)),
          ],
          
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
              SizedBox(
                  width:10,
                  height: 10,
                            ),


              const SizedBox(width: 10),
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

  return Obx(() {
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
              Container(
                child: Image.network(
                  'https://ddragon.leagueoflegends.com/cdn/11.22.1/img/champion/${champion.id}.png',
                  width: 65,
                  height: 65,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                champion.name,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12,color: Colors.white),
              ),
            ],
          );
        },
      );
  });
}
}
