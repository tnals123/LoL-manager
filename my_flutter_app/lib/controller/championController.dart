import 'dart:convert';
import 'package:flutter/services.dart';
import '/class/champion.dart';
import 'package:get/get.dart';

class ChampionsController extends GetxController {
  var champions = <Champion>[].obs;
  var selectedChampions = List<String?>.filled(10, null).obs;
  var showBlueTeamBoxes = false.obs; // 블루팀 박스 표시 여부
  var showRedTeamBoxes = false.obs; // 레드팀 박스 표시 여부

  @override
  void onInit() {
    super.onInit();
    fetchChampionsFromAsset();
  }

    void toggleTeamBoxes(bool isBlueTeam) {
    if (isBlueTeam) {
      showBlueTeamBoxes.value = !showBlueTeamBoxes.value;
    } else {
      showRedTeamBoxes.value = !showRedTeamBoxes.value;
    }
  }

  Future<void> fetchChampionsFromAsset() async {
    try {

      final jsonString = await rootBundle.loadString('assets/champions.json');
      final Map<String, dynamic> jsonResponse = json.decode(jsonString);
      var championsMap = jsonResponse['data'] as Map<String, dynamic>;
      List<Champion> championsData =
          championsMap.values.map((e) => Champion.fromJson(e)).toList();
      champions.value = championsData;

    } catch (e) {
      print(e);
    }
  }
}
