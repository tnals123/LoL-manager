import 'package:get/get.dart';
import 'dart:async';

class BanController extends GetxController {
  // 드래프트의 현재 단계를 추적합니다.
  int currentStep = 0;
  // 이거 토대로 ui짜자 
  RxBool isBanPhase = false.obs;

  // 각 팀에 대한 벤 및 픽 리스트
  RxList<Map<String, String>> blueTeamBans = List.generate(
    5,
    (_) => {'champion': '', 'state': 'normal'},
  ).obs;

  RxList<Map<String, String>> redTeamBans = List.generate(
    5,
    (_) => {'champion': '', 'state': 'normal'},
  ).obs;

  RxList<Map<String, dynamic>> blueTeamPlayers = List.generate(
    5,
    (_) => {'champion': '', 'state': 'normal'},
  ).obs;

  RxList<Map<String, dynamic>> redTeamPlayers = List.generate(
    5,
    (_) => {'champion': '', 'state': 'normal'},
  ).obs;

  List<String> blueTeamPicks = [];
  List<String> redTeamPicks = [];
  var isBlinking = false.obs;

  @override
  void onInit() {
    super.onInit();
    // 1초마다 isBlinking 상태를 변경
    Timer.periodic(Duration(seconds: 1), (timer) {
      isBlinking.value = !isBlinking.value;
    });
    
    startDraft();
  }


  // 드래프트 시작
  void startDraft() async {

    // 초기화
    currentStep = 0;

    blueTeamPicks.clear();
    redTeamPicks.clear();
    isBanPhase(true);

    for (var i = 0; i < 5; i++) {
      blueTeamBans[i]['state'] = 'blinking';
      redTeamBans[i]['state'] = 'blinking';
      blueTeamPlayers[i]['state'] = 'blinking';
      redTeamPlayers[i]['state'] = 'blinking';
    }

    await Future.delayed(Duration(seconds: 1));
      for (var i = 0; i < 5; i++) {
        blueTeamBans[i]['state'] = 'normal';
        redTeamBans[i]['state'] = 'normal';
        blueTeamPlayers[i]['state'] = 'normal';
        redTeamPlayers[i]['state'] = 'normal';
    }

    // redTeamBans[currentStep]['state'] = 'blinking';
    
    // 드래프트 과정 시작
    proceedToNextStep();
  }

  // 다음 단계로 진행
  void proceedToNextStep() {
    currentStep++;

    switch (currentStep) {
      case 1: // 첫 번째 벤
      case 2: // 두 번째 벤 
      case 3: // 세 번째 벤
      case 4: // 네 번째 벤
      case 5: // 다섯 번째 벤
      case 6: // 여섯번째 벤
        _banPhase();
        break;
      case 7: // 두 번째와 세 번째 픽
      case 8: // 네 번째와 다섯 번째 픽
      case 9: // 여섯 번째 픽
      case 10: // 추가 벤
      case 11: // 일곱 번째 픽
      case 12: // 여덟 번째와 아홉 번째 픽
      _pickPhase();
        break;
      case 13: // 열 번째 픽
        _finalPickPhase();
        break;
      default:
        print("드래프트 완료");
    }
  }

  void _banPhase() {
    if(currentStep.isOdd){
      blueTeamBans[5 - (currentStep + 1) ~/ 2]['state'] = 'blinking';
    }
    else{
      redTeamBans[(currentStep ~/ 2) - 1]['state'] = 'blinking';
    }
  }

  void _pickPhase() {

    if (currentStep == 7) {
      blueTeamPlayers[4]['state'] = 'blinking';

    } else if (currentStep == 8) {
      redTeamPlayers[0]['state'] = 'blinking';

    } else if (currentStep == 9) {
      redTeamPlayers[1]['state'] = 'blinking';

    } else if (currentStep == 10) {
      blueTeamPlayers[3]['state'] = 'blinking';
    }
      else if (currentStep == 11) {
      blueTeamPlayers[2]['state'] = 'blinking';

    } else if (currentStep == 12) {
      redTeamPlayers[2]['state'] = 'blinking';
    }
  }


  void _additionalBanPhase() {
    // 추가 벤 로직 구현
  }

  void _finalPickPhase() {
    // 최종 픽 로직 구현
  }

  // 챔피언 벤
  // void banChampion(String champion, bool isBlueTeam) {
  //   if (isBlueTeam) {
  //     blueTeamBans.add(champion);
  //   } else {
  //     redTeamBans.add(champion);
  //   }
  //   _proceedToNextStep();
  // }

  // 챔피언 픽
  void pickChampion(String champion, bool isBlueTeam) {
    if (isBlueTeam) {
      blueTeamPicks.add(champion);
    } else {
      redTeamPicks.add(champion);
    }
    proceedToNextStep();
  }
}
