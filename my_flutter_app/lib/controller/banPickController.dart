import 'dart:convert';
import 'package:flutter/services.dart';
import '/class/champion.dart';
import 'package:get/get.dart';

// 벤픽의 상태와 순서를 나타내는 모델 클래스
class BanPickModel {
  bool isBlueTurn = true; // 현재 턴이 블루팀인지 여부
  int currentBanCount = 0; // 현재까지 벤된 챔피언 수
  int currentPickCount = 0; // 현재까지 픽된 챔피언 수

  List<String> blueBannedChampions = []; // 블루팀이 벤한 챔피언들의 ID 리스트
  List<String> redBannedChampions = []; // 레드팀이 벤한 챔피언들의 ID 리스트
  
  List<String> bluePickedChampions = []; // 블루팀이 픽한 챔피언들의 ID 리스트
  List<String> redPickedChampions = []; // 레드팀이 픽한 챔피언들의 ID 리스트

  // 챔피언을 벤하는 함수
  void banChampion(String championId) {
    if (isBlueTurn) {
      blueBannedChampions.add(championId);
    } else {
      redBannedChampions.add(championId);
    }
    currentBanCount++;
    toggleTurn();
  }

  // 챔피언을 픽하는 함수
  void pickChampion(String championId) {
    if (isBlueTurn) {
      bluePickedChampions.add(championId);
    } else {
      redPickedChampions.add(championId);
    }
    currentPickCount++;
    toggleTurn();
  }

  // 턴을 바꾸는 함수
  void toggleTurn() {
    isBlueTurn = !isBlueTurn;
  }
}

// GetX 컨트롤러
class BanPickController extends GetxController {
  final BanPickModel model = BanPickModel();

  // 다른 로직들 (예: 컴퓨터 픽/벤 로직, UI 업데이트 로직 등)
}


