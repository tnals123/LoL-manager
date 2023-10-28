import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_flutter_app/controller/timeController.dart';

class TimerBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TimerController controller = Get.put(TimerController());
    return Obx(() => Container(
          height: 10,
          width: double.infinity,
          child: Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.black
                ),
              ),
              Positioned(
                left: MediaQuery.of(context).size.width * (1 - controller.progress.value) / 2,
                right: MediaQuery.of(context).size.width * (1 - controller.progress.value) / 2,
                child: Container(
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
