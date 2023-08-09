import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:intl/intl.dart';


class LocalNotificationService {

  String testVar='';
  LocalNotificationService();

  final _localNotificationService = FlutterLocalNotificationsPlugin();
  final BehaviorSubject<String?> onNotificationClick = BehaviorSubject();

  Future<void> intialize() async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings androidInitializationSettings =
    AndroidInitializationSettings('@drawable/ic_stat_all_inclusive');


    IOSInitializationSettings iosInitializationSettings =
    IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    final InitializationSettings settings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    final details2= await _localNotificationService.getNotificationAppLaunchDetails();
    if(details2 != null && details2.didNotificationLaunchApp) {
      onNotificationClick.add(details2.payload);
    }

    await _localNotificationService.initialize(
      settings,
      onSelectNotification: onSelectNotification,
    );
  }

  Future<NotificationDetails> _notificationDetails(String audioName) async {
    final audio="";
    AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(audioName, audioName,
        channelDescription: audioName,
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
        sound: RawResourceAndroidNotificationSound(audioName)
        );

    IOSNotificationDetails iosNotificationDetails =
    IOSNotificationDetails(sound: audioName+'.wav');

    return NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    final details = await _notificationDetails("cash");
    await _localNotificationService.show(id, title, body, details);
  }

  Future<void> showNotificationRepeat({
    required int id,
    required String title,
    required String body,
  }) async {
    final details = await _notificationDetails("cash");
    RepeatInterval intervalchik=RepeatInterval.everyMinute;
    await _localNotificationService.periodicallyShow(id, title, body, RepeatInterval.everyMinute, details);
  }

  Future<void> deleteAllNotification({
    required int id,
  }) async {
    await _localNotificationService.cancelAll();
  }

  Future<void> closeNotification({
    required int id,
  }) async {
    for(int i=id;i<id+40;i++){
      await _localNotificationService.cancel(i);
    }
  }

  Future<void> closeAllNotification() async {
    await _localNotificationService.cancelAll();
  }


  Future<void> showScheduledNotification(
      {required int id,
        required String title,
        required String body,
        required int seconds}) async {
    final details = await _notificationDetails("cash");
    await _localNotificationService.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(
        DateTime.now().add(Duration(seconds: 2)),
        tz.local,
      ),
      details,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
    );
    print("Уведомление прищло");

  }

  Future<void> showScheduledNotificationRep(
      {required int id,
        required String title,
        required String body,
        required int minutes,
        required int ConstMinutes,
        required int indexx,
        required List timePosle,
        required List timeDo,
        required String SoundName}) async {

    String RawSoundName="";
    if(SoundName=="Вселенная") {
      RawSoundName="vselenaya";
    } else if (SoundName=="Космос") {
      RawSoundName="kosmos";
    } else if (SoundName=="Перелив") {
      RawSoundName="pereliv";
    } else if (SoundName=="Синусоида") {
      RawSoundName="sinus";
    } else if (SoundName=="Meditify") {
      RawSoundName="meditify";
    } else if (SoundName=="Meditify 2") {
      RawSoundName="meditify2";
    } else if (SoundName=="Meditify 3") {
      RawSoundName="meditify3";
    } else if (SoundName=="Meditify 4") {
      RawSoundName="meditify4";
    } else if (SoundName=="Meditify 5") {
      RawSoundName="meditify5";
    }




    final details = await _notificationDetails(RawSoundName);

    String ToTimeString(value) {
      if(value<10) {
        return ("0"+value.toString());
      }
      else return value.toString();
    };

    await _localNotificationService.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(
        DateTime.now().add(Duration(seconds: minutes)),
        tz.local,
      ),
      details,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
    );
    var moonLanding = DateTime.parse('2022-09-29 11:49:04Z'); // 8:18pm

    String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    var TimeLimitDo=DateTime.parse(currentDate+' '+ToTimeString(timeDo[0])+":"+ToTimeString(timeDo[1])+":04Z"); // 8:18pm
    var TimeLimitPosle=DateTime.parse(currentDate+' '+ToTimeString(timePosle[0])+":"+ToTimeString(timePosle[1])+":04Z"); // 8:18pm
    print("Время после — "+TimeLimitDo.toString());
    print("Время до — "+TimeLimitPosle.toString());
    print("DataNow — "+DateTime.now().toString());

    bool Display=true;

    if(DateTime.now().hour>TimeLimitDo.hour&&DateTime.now().hour<TimeLimitPosle.hour){
      print("Нельзя показывать");
      Display=false;
    }

    if(DateTime.now().hour==TimeLimitDo.hour){
      if(DateTime.now().minute<TimeLimitDo.hour) {
        print("Нельзя показывать");
        Display=false;
      }
    }

    if(DateTime.now().hour==TimeLimitDo.hour){
      if(DateTime.now().minute>TimeLimitDo.hour) {
        print("Нельзя показывать");
        Display=false;
      }
    }
    //

    if(indexx<30) {
      print("Порядок");
      showScheduledNotificationRep(id: id+1, title: title, body: body, minutes: minutes+ConstMinutes,ConstMinutes: ConstMinutes,indexx: indexx+1,timePosle: timePosle,timeDo: timeDo, SoundName: SoundName);
    }


  }

  Future<void> showNotificationWithPayload(
      {required int id,
        required String title,
        required String body,
        required String payload}) async {
    final details = await _notificationDetails("wavsound");
    await _localNotificationService.show(id, title, body, details,
        payload: payload);
  }

  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {
    print('id $id');
  }

  void onSelectNotification(String? payload) {
    print('payload $payload');
    if (payload != null && payload.isNotEmpty) {
      onNotificationClick.add(payload);
    }
  }
}