import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_flutter_app/controller/banController.dart';
import 'package:my_flutter_app/controller/championController.dart';
import 'package:my_flutter_app/class/champion.dart';
import 'package:my_flutter_app/controller/timeController.dart';
import 'package:my_flutter_app/widget/bansWidget.dart';

class ChampionsView extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();

  Widget _buildChampionGrid() {
    final controller = Get.put(ChampionsController());
    final banController = Get.find<BanController>();
    return Stack(
      children: [
        ScrollbarTheme(
          data: ScrollbarThemeData(
            thumbColor: MaterialStateProperty.all(Colors.grey), // 스크롤바 색상 설정
            thickness: MaterialStateProperty.all(6), // 스크롤바 두께 설정
            radius: const Radius.circular(10), // 스크롤바 모서리 둥근 정도 설정
          ),
          child: Scrollbar(
            controller: _scrollController, // 스크롤 컨트롤러 추가
            child: Obx(() {
              return GridView.builder(
                controller: _scrollController, // 스크롤 컨트롤러 사용
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
                      GestureDetector(
                        onTap: () {
                          if(banController.isBanPhase.value){
                              if(banController.currentStep.isOdd && banController.currentStep <= 6){
                               banController. blueTeamBans[5 - (banController.currentStep + 1) ~/ 2]['champion'] = '${champion.id}';
                              }
                              else if (banController.currentStep.isEven && banController.currentStep <= 6){
                                banController.redTeamBans[(banController.currentStep ~/ 2) - 1]['champion'] = '${champion.id}';
                              }
                              else if(banController.currentStep > 6 && banController.currentStep <= 12){
                                  if (banController.currentStep == 7) {
                                    banController.blueTeamPlayers[4]['champion'] = '${champion.id}';

                                  } else if (banController.currentStep == 8) {
                                    banController.redTeamPlayers[0]['champion'] = '${champion.id}';

                                  } else if (banController.currentStep == 9) {
                                    banController.redTeamPlayers[1]['champion'] = '${champion.id}';

                                  } else if (banController.currentStep == 10) {
                                    banController.blueTeamPlayers[3]['champion'] = '${champion.id}';
                                  }
                                    else if (banController.currentStep == 11) {
                                    banController.blueTeamPlayers[2]['champion'] = '${champion.id}';

                                  } else if (banController.currentStep == 12) {
                                    banController.redTeamPlayers[2]['champion'] = '${champion.id}';
                                  }
                                }
                          }
                        },
                        child: Container(
                          width: 70.0,
                          height: 70.0,
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
                        style:
                            const TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ],
                  );
                },
              );
            }),
          ),
        ),
        Positioned(
          bottom: 80,
          left: 0,
          right: 0,
          child: Center(
            child: SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  final TimerController timerController = Get.find<TimerController>();
                  timerController.resetTimer(); // 타이머를 초기화하는 메서드 호출
                  if(banController.currentStep.isOdd && banController.currentStep <= 6){
                      banController.blueTeamBans[5 - (banController.currentStep + 1) ~/ 2]['state'] = 'normal';
                      banController.proceedToNextStep();
                    }
                  else if (banController.currentStep.isEven && banController.currentStep <= 6){
                      banController.redTeamBans[(banController.currentStep ~/ 2) - 1]['state'] = 'normal';
                      banController.proceedToNextStep();
                    }
                  else if(banController.currentStep > 6 && banController.currentStep <= 12){
                      if (banController.currentStep == 7) {
                        banController.blueTeamPlayers[4]['state'] = 'normal';

                      } else if (banController.currentStep == 8) {
                        banController.redTeamPlayers[0]['state'] = 'normal';

                      } else if (banController.currentStep == 9) {
                        banController.redTeamPlayers[1]['state'] = 'normal';

                      } else if (banController.currentStep == 10) {
                        banController.blueTeamPlayers[3]['state'] = 'normal';
                      }
                        else if (banController.currentStep == 11) {
                        banController.blueTeamPlayers[2]['state'] = 'normal';

                      } else if (banController.currentStep == 12) {
                        banController.redTeamPlayers[2]['state'] = 'normal';
                      }
                      banController.proceedToNextStep();
                  }

                },
                child: Text("선택"),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                // 여기서 constraints.maxHeight가 GridView의 최대 높이입니다.
                return _buildChampionGrid();
              },
            ),
          ),
          // 추가적인 하단 위젯들
        ],
      ),
    );
  }




}
