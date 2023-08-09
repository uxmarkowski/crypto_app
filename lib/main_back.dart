import 'dart:async';
import 'dart:isolate';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:crypto_app/hive_metod.dart';
import 'package:crypto_app/home_plus.dart';
import 'package:crypto_app/local_notification_servise.dart';
import 'package:flutter/material.dart';
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


//
// // Be sure to annotate your callback function to avoid issues in release mode on Flutter >= 3.3.0
// @pragma('vm:entry-point')
// void printHello() async{
// final DateTime now = DateTime.now();late final LocalNotificationService service; var model = hive_example();service = LocalNotificationService();service.intialize();
// final int isolateId = Isolate.current.hashCode;
// print("[$now] Hello, world! isolate=${isolateId} function='$printHello'");
//
//
// // int messageNum = 0;
// //
// //   final socket = WebsocketManager('wss://stream.binance.com:9443/stream?streams=btcusdt');
// //
// //   socket.onClose((dynamic message) {
// //     print('close');
// //   });
// //
// //   socket.onMessage((dynamic message) {
// //     print('recv: $message');
// //     messageNum += 1;
// //     final String msg = '$messageNum: ${DateTime.now()}';
// //     print('send: $msg');
// //     socket.send(msg);
// //     });
// // // Connect to server
// //   socket.connect();
// //
// //   await Future.delayed(Duration(seconds: 10));
// //   socket.close();
// //
// // service.showNotification(id: 1, title: "SUUU ", body: "body");
//
//
// //
// // model.saveTest(DateTime.now().minute.toString());
// // var data= await model.getTest();
//
// // service.showNotification(id: 1, title: "title2 "+data.toString(), body: "body");
// }





void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // await AndroidAlarmManager.initialize();
  runApp(const MyApp());


  // final int helloAlarmID = 0;
  // await AndroidAlarmManager.cancel(helloAlarmID);
  // await AndroidAlarmManager.cancel(99);

  // await AndroidAlarmManager.cancel(908850588);
  // AndroidAlarmManager.periodic(const Duration(minutes: 1), helloAlarmID, printHello,wakeup: true,rescheduleOnReboot: true);
  // await AndroidAlarmManager.oneShot(Duration(minutes: 1), 99, printHello,wakeup: true,rescheduleOnReboot: true);

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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
