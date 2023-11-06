import 'dart:async';
import 'package:get/get.dart';

class TimerController extends GetxController {
  RxDouble progress = 1.0.obs;
  RxInt totalTime = 30.obs; // 총 시간 (초)
  Timer? timer;

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  void startTimer() {
    // 타이머가 이미 존재하면 취소합니다.
    timer?.cancel();
    // 진행 상태를 리셋합니다.
    progress.value = 1.0;
    // 새 타이머를 시작합니다.
    timer = Timer.periodic(Duration(milliseconds: 50), (Timer t) {
      if (progress.value > 0) {
        progress.value -= 0.05 / totalTime.value; // 매 50ms마다 감소
      } else {
        // 타이머가 종료되면 취소합니다.
        timer?.cancel();
      }
    });
  }

  void resetTimer() {
    // 타이머를 취소하고 progress를 1.0 (100%)으로 재설정
    timer?.cancel();
    progress.value = 1.0;
    totalTime.value = 30; // 총 시간을 다시 30초로 설정
    
    // 타이머를 다시 시작
    startTimer();
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }
}
