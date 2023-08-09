import 'dart:async';
import 'dart:isolate';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:crypto_app/hive_metod.dart';
import 'package:crypto_app/home_plus.dart';
import 'package:crypto_app/local_notification_servise.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:web_socket_channel/io.dart';
// import 'package:websocket_manager/websocket_manager.dart';
import 'home.dart';
import 'package:flutter/services.dart';
import 'package:workmanager/workmanager.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/src/widgets/framework.dart';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:candlesticks/candlesticks.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';



class ChartData {final int x;final double? y;ChartData(this.x, this.y);}



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await FlutterBackground.initialize();

  runApp(const MyApp());

  final androidConfig = FlutterBackgroundAndroidConfig(
    notificationTitle: "flutter_background example app",
    notificationText: "Background notification for keeping the example app running in the background",
    notificationImportance: AndroidNotificationImportance.Default,
    notificationIcon: AndroidResource(name: 'ic_stat_all_inclusive', defType: 'drawable'), // Default is ic_launcher from folder mipmap
  );
  bool success = await FlutterBackground.initialize(androidConfig: androidConfig);

}







class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: HomePageSFor(),
    );
  }
}
