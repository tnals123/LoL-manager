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

import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> fetchChampionsData() async {
  final response = await http.get(
    Uri.parse('https://ddragon.leagueoflegends.com/cdn/11.22.1/data/ko_KR/champion.json'),
    headers: {
      'X-Riot-Token': 'RGAPI-322be88f-8820-40a2-9c4f-ef1d8dc99180', // 여기에 Riot API 키를 입력하세요
    },
  );

  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body);
    var champions = jsonResponse['data'];
    // 필요한 처리 수행
  } else {
    throw Exception('Failed to load champion data');
  }
}



void main(){
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight]);
  runApp(MyApp2());
}

class MyApp2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner : false,
      title: 'League of Legends Pick Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PickPage(),
    );
  }
}

