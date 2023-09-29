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

  Widget _buildBanSection() {
    return Row(
      children: [
        Expanded(child: _buildBannedChampions(true)),
        Expanded(
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
      children: List.generate(5, (index) => Icon(Icons.block, color: Colors.red)),
    );
  }

  Widget _buildPlayerList(bool isLeftSide) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        final playerIndex = isLeftSide ? index : index + 5;
        return Column(
          children : [
            SizedBox(height : 10),
            _buildPlayerItem(playerIndex, isLeftSide),
            SizedBox(height:10),
            Divider(color : Colors.yellow)
          ]
        );
      },
    );
  }

  Widget _buildPlayerItem(int playerIndex, bool isLeftSide) {
    return Container(
      height: 60, 
      padding: EdgeInsets.symmetric(horizontal: 16.0), 
      child: Row(
        mainAxisAlignment: 
            isLeftSide ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (!isLeftSide) ...[ 
            Text('Player ${playerIndex + 1}', style: TextStyle(color: Colors.white)),
            SizedBox(width: 10),
          ],
          Container(
            width: 75.0, 
            height: 75.0, 
            decoration: BoxDecoration(
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
            SizedBox(width: 10),
            Text('Player ${playerIndex + 1}', style: TextStyle(color: Colors.white)),
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
              Icon(Icons.shield),
              SizedBox(width: 10),
            ],
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: '챔피언 검색',
                  fillColor: Colors.grey[800],
                  filled: true,
                  border: OutlineInputBorder(),
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
    if (controller.champions.isEmpty) {
      return Center(child: CircularProgressIndicator());
    } else {
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 2 / 3,
        ),
        itemCount: controller.champions.length,
        itemBuilder: (context, index) {
          Champion champion = controller.champions[index];
          return Column(
            children: [
              ClipOval(
                child: Image.network(
                  'https://ddragon.leagueoflegends.com/cdn/11.22.1/img/champion/${champion.image}',
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 8),
              Text(
                champion.name,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
            ],
          );
        },
      );
    }
  });
}
}
