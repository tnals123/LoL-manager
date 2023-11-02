// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:my_flutter_app/pickPage.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

final logger = Logger();

void someFunction() {
  logger.d("This is a debug message");
}

void main() async {
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight]);
  someFunction();
  runApp(MyApp2());
}

class MyApp2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'League of Legends Pick Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PickPage(),
    );
  }
}
