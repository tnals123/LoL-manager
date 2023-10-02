import 'dart:convert';
import 'package:flutter/services.dart';
import '/class/champion.dart';
import 'package:get/get.dart';

class ChampionsController extends GetxController {
  var champions = <Champion>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchChampionsFromAsset();
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
