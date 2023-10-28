import 'dart:async';
import 'package:get/get.dart';

class TimerController extends GetxController {
  RxDouble progress = 1.0.obs;
  int totalTime = 30; // 총 시간 (초)
  Timer? timer;

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(milliseconds: 50), (Timer t) {
      if (progress.value > 0) {
        progress.value -= 0.05 / 30; // 매 50ms마다 감소
      } else {
        timer?.cancel();
      }
    });
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }
}
