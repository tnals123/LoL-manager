import 'package:get/get.dart';
import 'class/champion.dart';

class ChampionsController extends GetxController {
  var champions = <Champion>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchChampionsData();
  }

  Future<void> fetchChampionsData() async {
    try {
      List<Champion> championsData = await fetchChampionsFromAPI();
      champions.value = championsData;
    } catch (e) {
      print(e);
    }
  }
}
