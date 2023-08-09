import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Interval;
import 'package:flutter/services.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:web_socket_channel/io.dart';

import 'details.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:crypto_app/hive_metod.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:workmanager/workmanager.dart';
import 'local_notification_servise.dart';
import 'socket.dart';




class HomePageSFor extends StatefulWidget {
  HomePageSFor({Key? key}) : super(key: key);
  @override
  State<HomePageSFor> createState() => _HomePageSForState();
}

class _HomePageSForState extends State<HomePageSFor> with WidgetsBindingObserver {

  var SocketChannel = IOWebSocketChannel.connect(Uri.parse('wss://stream.binance.com:9443/stream?streams=btcusdt'));
  var SocketChannel2 = IOWebSocketChannel.connect(Uri.parse('wss://stream.binance.com:9443/stream?streams=btcusdt'));
  var SocketChannel3 = IOWebSocketChannel.connect(Uri.parse('wss://stream.binance.com:9443/stream?streams=btcusdt'));
  var SocketChannel4 = IOWebSocketChannel.connect(Uri.parse('wss://stream.binance.com:9443/stream?streams=btcusdt'));

  var UpDateTime=DateTime.now();
  var tests=0;

  var SortValue=0;
  var Values=[]; var Values1=[]; var Values2=[]; // Массивы для пампа булиша и бирлиша
  var initalValue=0; // Начало работы только в начале

  var lastClosePrice = "0.000000000"; var BTCpercent="0.00"; List TextStyles=[TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w300),TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w600)];

  var StartStop=0; // Индекс кнопки старт стоп
  var TypeOfDataIndex=0; // Тип функции
  var timeIntervals=["1 мин.", "3 мин.", "5 мин.", "15 мин.", "30 мин.", "1 час", "1 день"]; var timeIntervals2=["7 дней", "14 дней", "1 месяц"]; var timeIntervalsHttp=["1m", "3m", "5m", "15m", "30m", "1h", "1d",];var durationsList=[Duration(minutes: 1), Duration(minutes: 3), Duration(minutes: 5), Duration(minutes: 15), Duration(minutes: 30), Duration(hours: 1), Duration(days: 1),]; var durationsList2=[Duration(days: 7), Duration(days: 14), Duration(days: 28)];
  var saveInFutureIndexPump=3; var saveInFutureIndexBullish=3; var saveInFutureIndexBearlish=3; var saveInFutureIndexListing=1; // Переменные хранения времени для функции
  var changerVarIndex=0; bool boolTest=false; bool boolTest2=false; bool boolTest3=false; bool boolTest4=false; Duration animationDuration=Duration(milliseconds: 500);

  dynamic FinalPercent=[2.4,2.5,1.4,-7.9];
  dynamic FinalDate=[0,3,2,5]; var BackgroundIndex=[0,0,0,0]; // Проценты и время для каждого типа
  var NotifyColIndex=[0,0,0,0];
  var TextStyleValue1=1; var TextStyleValue2=0; var TextStyleValue3=0; var TextStyleValue4=0;
  late final LocalNotificationService service; // Сервис
  var model = hive_example();

  void LoadAnimate (type) async{
    
    if(type==0&&boolTest==false) {
      setState(() {boolTest=true;});
      await Future.delayed(Duration(milliseconds: 500));
      setState(() {boolTest=false;});
    }
    if(type==1&&boolTest2==false) {
      setState(() {boolTest2=true;});
      await Future.delayed(Duration(milliseconds: 500));
      setState(() {boolTest2=false;});
    }
    if(type==2&&boolTest3==false) {
      setState(() {boolTest3=true;});
      await Future.delayed(Duration(milliseconds: 500));
      setState(() {boolTest3=false;});
    }
    if(type==3&&boolTest4==false) {
      setState(() {boolTest4=true;});
      await Future.delayed(Duration(milliseconds: 500));
      setState(() {boolTest4=false;});
    }

  }

  void LoadOptionsFromHive() async{
    var dataOptions=await model.getOptions() as List;
    var dataCoinsF=await model.getCoinsDataF();
    var dataCoinsS=await model.getCoinsDataS();
    var dataCoinsT=await model.getCoinsDataT();
    var timer1data=await model.getCoinsTimer1();
    var timer2data=await model.getCoinsTimer2();
    var timer3data=await model.getCoinsTimer3();
    var timer4data=await model.getCoinsTimer4();
    setState(() {
      saveInFutureIndexPump=timer1data;
      saveInFutureIndexBullish=timer2data;
      saveInFutureIndexBearlish=timer3data;
      saveInFutureIndexListing=timer4data;
    });

    if(dataCoinsF!=[]){
      setState(() {Values=dataCoinsF;});
    }
    if(dataCoinsS!=[]){
      setState(() {Values1=dataCoinsS;});
    }
    if(dataCoinsT!=[]){
      setState(() {Values2=dataCoinsT;});
    }

    print("dataOptions "+dataOptions.toString());
    print("dataOptions type "+dataOptions.runtimeType.toString());
    if(dataOptions.isNotEmpty){
      setState(() {
        print("Лишний Шаг");
        FinalPercent[0]=dataOptions[0];
        FinalPercent[1]=dataOptions[1];
        FinalPercent[2]=dataOptions[2];
        FinalPercent[3]=dataOptions[3];
        FinalDate[0]=dataOptions[4];
        FinalDate[1]=dataOptions[5];
        FinalDate[2]=dataOptions[6];
        FinalDate[3]=dataOptions[7];
      });

    }

    CryptoSocket(FinalPercent[0],FinalPercent[1],FinalDate[0],FinalDate[1],0,[saveInFutureIndexPump,saveInFutureIndexBullish,saveInFutureIndexBearlish,saveInFutureIndexListing],Values);
    CryptoSocket(FinalPercent[1],FinalPercent[2],FinalDate[1],FinalDate[2],1,[saveInFutureIndexPump,saveInFutureIndexBullish,saveInFutureIndexBearlish,saveInFutureIndexListing],Values1);
    CryptoSocket(FinalPercent[3],FinalPercent[3],FinalDate[3],FinalDate[3],2,[saveInFutureIndexPump,saveInFutureIndexBullish,saveInFutureIndexBearlish,saveInFutureIndexListing],Values2);

  }

  @override
  void initState() {
    service = LocalNotificationService();
    service.intialize();
    LoadOptionsFromHive();
    WidgetsBinding.instance.addObserver(this);



    // Листинг постоянный
    Timer.periodic(Duration(minutes: 10), (timer) {
      print("Shiiishh :p");
      ListingFunc(changerVarIndex,FinalPercent,FinalDate,TypeOfDataIndex);
    });

    Future.delayed(Duration(seconds: 1)).then((value) => setState(() {}));

    Values.removeWhere((element) => ((element['saveDate'] as DateTime).difference(DateTime.now())).inSeconds<=0);
    Values1.removeWhere((element) => ((element['saveDate'] as DateTime).difference(DateTime.now())).inSeconds<=0);
    Values2.removeWhere((element) => ((element['saveDate'] as DateTime).difference(DateTime.now())).inSeconds<=0);

    Future.delayed(Duration(seconds: 1)).then((value) => setState(() {}));



    Timer.periodic(Duration(seconds: 30), (timer) {
      UpdateList();

      print("Values do "+Values.toString());
      model.saveCoinsData(Values,Values1,Values2,saveInFutureIndexPump,saveInFutureIndexBullish,saveInFutureIndexBearlish,saveInFutureIndexListing);

      // for(int i=0;i<Values.length;i++) {
      //   if(((Values[i]['saveDate'] as DateTime).difference(DateTime.now())).inSeconds<=0){
      //     Values.removeAt(i); // Удаление истекших дат
      //   }
      // }

      Values.removeWhere((element) => ((element['saveDate'] as DateTime).difference(DateTime.now())).inSeconds<=0);
      Values1.removeWhere((element) => ((element['saveDate'] as DateTime).difference(DateTime.now())).inSeconds<=0);
      Values2.removeWhere((element) => ((element['saveDate'] as DateTime).difference(DateTime.now())).inSeconds<=0);

      Future.delayed(Duration(seconds: 1)).then((value) => setState(() {}));

      print("Values posle "+Values.toString());

      print("Сохранено");
    });

    // var timer2=0;
    // Timer.periodic(Duration(seconds: 1),(timer) {
    //   timer2=timer2+1;
    //   print("Print "+timer2.toString());
    // });

    Timer.periodic(Duration(minutes: 3), (timer) {


      print("Values do "+Values.toString());
      model.saveCoinsData(Values,Values1,Values2,saveInFutureIndexPump,saveInFutureIndexBullish,saveInFutureIndexBearlish,saveInFutureIndexListing);
      SocketChannel.sink.close();
      SocketChannel2.sink.close();
      SocketChannel3.sink.close();
      SocketChannel4.sink.close();

      Future.delayed(Duration(seconds: 1)).then((value) => setState(() {}));

      LoadOptionsFromHive();
      print("Values posle "+Values.toString());

      print("Сохранено");
    });

    // TODO: implement initState
    super.initState();
  }

  void CryptoSocket(percent1,percent2,date1,date2,type,saveIndex,valuesSocket) async{

    final res = await http.get(Uri.parse('https://api.binance.com/api/v3/ticker/24hr'));
    var resData = (jsonDecode(res.body) as List); // Получение списка монет
    var CoinsCorrect=[]; resData.forEach((element) {
      if(element['symbol']=="BTCUSDT"){
        setState(() {
          lastClosePrice=element['lastPrice'];
          BTCpercent=((double.parse(element['openPrice'].toString())/double.parse(element['lastPrice'].toString())-1.0)*100).toString();
        });
      };
      CoinsCorrect.add(element['symbol']);
    });
    var CoinsCorrectFiltered=CoinFilter(CoinsCorrect);
    var coinsLink=""; CoinsCorrectFiltered.forEach((element) {coinsLink=coinsLink+(element.toString().toLowerCase()+"@kline_"+timeIntervalsHttp[date1]+"/");}); // Создание массива монет
    var coinsLink2=""; CoinsCorrectFiltered.forEach((element) {coinsLink2=coinsLink2+(element.toString().toLowerCase()+"@kline_"+timeIntervalsHttp[date2]+"/");}); // Создание массива монет 2
    print("coinsLink "+coinsLink.toString()); coinsLink=coinsLink.substring(0,coinsLink.length-1); coinsLink2=coinsLink2.substring(0,coinsLink2.length-1); // Удаление последнего символа
    var NotificationLimitIndexInMinute=0; // Ограничение уведомлений


    if(type==0) {
      SocketChannel = IOWebSocketChannel.connect(Uri.parse('wss://stream.binance.com:9443/stream?streams=$coinsLink'));
      SocketChannel.stream.listen((message) async {

        var a=double.parse(jsonDecode(message)['data']['k']['o'].toString()); var b=double.parse(jsonDecode(message)['data']['k']['c'].toString());
        var PourcantCompare=(b/a-1)*100; // Подсчет процента
        print((type.toString()+" "+date1.toString()+" Symbol: "+jsonDecode(message)['data']['s'].toString()+" Price:"+jsonDecode(message)['data']['k']['c'].toString()).toString()+" Percent: "+PourcantCompare.toString()+" OpenPrice:"+(jsonDecode(message)['data']['k']['o'].toString()).toString());
        List<bool> BoolsList=[(PourcantCompare>percent1),(PourcantCompare>percent1||(PourcantCompare>percent2)),(PourcantCompare<percent1),];
        var NewIndex=1; // Проверка на новизну
        

        if(BoolsList[type]){ // Поиск монеты если подходит условиям
          print(jsonDecode(message)['data']['s'].toString()+" "+jsonDecode(message)['data']['k']['c'].toString());
          print("Подходит ");

          for(int i=0;i<valuesSocket.length;i++) {

            if(((valuesSocket[i]['saveDate'] as DateTime).difference(DateTime.now())).inSeconds<=0){
              if(type==0){Values.removeAt(i);};if(type==1){Values1.removeAt(i);};if(type==2){Values2.removeAt(i);};
              valuesSocket.removeAt(i); // Удаление истекших дат
            }

            if(((valuesSocket[i]['graphData'] as List).length<3&&valuesSocket[i]['graphDataIndexCheck']==0)){

              valuesSocket[i]['graphDataIndexCheck']=1;
              final uri = Uri.parse('https://api.binance.com/api/v3/uiKlines?symbol='+valuesSocket[i]['coin'].toString().toUpperCase()+'&interval='+timeIntervalsHttp[date1]+'&limit=30');
              final res = await http.get(uri);
              var resData = (jsonDecode(res.body) as List);
              for(int ii = 0;ii<resData.length;ii++){
                valuesSocket[i]['graphData'].add(ChartData(valuesSocket[i]['graphData'].length+1, double.parse(resData[ii][4].toString())));
              }
              print("График "+resData.toString());
              print("График leng "+resData.toString());
              setState(() {

              });

            }

            if(valuesSocket[i]['coin']==jsonDecode(message)['data']['s']&&jsonDecode(message)['data']['k']['c']!=null) {
              // Обновление монеты если найден дубль

              if(jsonDecode(message)['data']['s'].toString()=="BTCUSDT"){
                setState(() {
                  lastClosePrice=jsonDecode(message)['data']['k']['c'].toString();
                  BTCpercent=PourcantCompare.toString();
                });
              }

              valuesSocket[i]['price']=jsonDecode(message)['data']['k']['c'].toString();
              valuesSocket[i]['percant']=PourcantCompare.toString();
              valuesSocket[i]['date']=date1;
              var len=valuesSocket[i]['graphData'].length+1;
              if(valuesSocket[i]['graphDataMinutes']!=DateTime.now().minute){
                valuesSocket[i]['graphDataMinutes']=DateTime.now().minute;
                valuesSocket[i]['graphData'].add(ChartData(len, double.parse(jsonDecode(message)['data']['k']['c'].toString())));
              }
              valuesSocket[i]['newcard']=0;

              NewIndex=0;
            }
          }


          setState(() { // Добавление нового элемента
            if(NewIndex==1){ // Проверка на наличие элемента в массиве
              if(BackgroundIndex[type]==1) {


                if(NotificationLimitIndexInMinute!=DateTime.now().minute) {
                  NotifyColIndex[type]=0;
                  NotificationLimitIndexInMinute=DateTime.now().minute;
                }
                if(NotifyColIndex[type]<5) {
                  NotifyColIndex[type]=NotifyColIndex[type]+1;
                  service.showNotification(id: 12, title: jsonDecode(message)['data']['s'].toString()+" | "+PourcantCompare.toString().substring(0,5)+"%", body: "\$"+jsonDecode(message)['data']['k']['c'].toString());
                }
              }

              if(jsonDecode(message)['data']['s'].toString()=="BTCUSDT"){
                setState(() {
                  lastClosePrice=jsonDecode(message)['data']['k']['c'].toString();
                  BTCpercent=PourcantCompare.toString();
                });
              }
              if (jsonDecode(message)['data']['k']['c']!=null) {
                valuesSocket.add(
                  {
                    'coin':jsonDecode(message)['data']['s'].toString(),
                    'price':jsonDecode(message)['data']['k']['c'].toString(),
                    'percant':PourcantCompare.toString(),
                    'date':date1,
                    'BullishIndex':0,
                    'graphDataMinutes':0,
                    'graphDataIndexCheck':0,
                    'graphData':[ChartData(1, double.parse(jsonDecode(message)['data']['k']['c'].toString()))],
                    'newcard':1,
                    'saveDate':DateTime.now().add(durationsList[saveIndex[type]]),
                  },
                );
                LoadAnimate(0);
              }
            }
          });

          if(NewIndex==1){
            for(int i=0;i<valuesSocket.length;i++) {
              if(((valuesSocket[i]['graphData'] as List).length<3&&valuesSocket[i]['graphDataIndexCheck']==0)){

                valuesSocket[i]['graphDataIndexCheck']=1;
                final uri = Uri.parse('https://api.binance.com/api/v3/uiKlines?symbol='+valuesSocket[i]['coin'].toString().toUpperCase()+'&interval='+timeIntervalsHttp[date1]+'&limit=30');
                final res = await http.get(uri);
                var resData = (jsonDecode(res.body) as List);
                for(int ii = 0;ii<resData.length;ii++){
                  valuesSocket[i]['graphData'].add(ChartData(valuesSocket[i]['graphData'].length+1, double.parse(resData[ii][4].toString())));
                }
                print("График "+resData.toString());
                print("График leng "+resData.toString());
                setState(() {


                });

              }
            }
          }

        }



      });
    }

    if(type==1) {
      SocketChannel2 = IOWebSocketChannel.connect(Uri.parse('wss://stream.binance.com:9443/stream?streams=$coinsLink2'));
      await Future.delayed(Duration(seconds: 1));
      SocketChannel2.stream.listen((message) async {

        var a=double.parse(jsonDecode(message)['data']['k']['o'].toString()); var b=double.parse(jsonDecode(message)['data']['k']['c'].toString());
        var PourcantCompare=(b/a-1)*100; // Подсчет процента
        print((type.toString()+" "+date1.toString()+" Symbol: "+jsonDecode(message)['data']['s'].toString()+" Price:"+jsonDecode(message)['data']['k']['c'].toString()).toString()+" Percent: "+PourcantCompare.toString()+" OpenPrice:"+(jsonDecode(message)['data']['k']['o'].toString()).toString());
        List<bool> BoolsList=[(PourcantCompare>percent1),(PourcantCompare>percent1||(PourcantCompare>percent2)),(PourcantCompare<percent1),];
        var NewIndex=1;


        if(BoolsList[type]){ // Поиск монеты если подходит условиям
          print(jsonDecode(message)['data']['s'].toString()+" "+jsonDecode(message)['data']['k']['c'].toString());

          for(int i=0;i<valuesSocket.length;i++) {

            if(((valuesSocket[i]['saveDate'] as DateTime).difference(DateTime.now())).inSeconds<=0){
              if(type==0){Values.removeAt(i);};if(type==1){Values1.removeAt(i);};if(type==2){Values2.removeAt(i);};
              valuesSocket.removeAt(i); // Удаление истекших дат
            }

            if(((valuesSocket[i]['graphData'] as List).length<3&&valuesSocket[i]['graphDataIndexCheck']==0)){

              valuesSocket[i]['graphDataIndexCheck']=1;
              final uri = Uri.parse('https://api.binance.com/api/v3/uiKlines?symbol='+valuesSocket[i]['coin'].toString().toUpperCase()+'&interval='+timeIntervalsHttp[date1]+'&limit=30');
              final res = await http.get(uri);
              var resData = (jsonDecode(res.body) as List);
              for(int ii = 0;ii<resData.length;ii++){
                valuesSocket[i]['graphData'].add(ChartData(valuesSocket[i]['graphData'].length+1, double.parse(resData[ii][4].toString())));
              }
              print("График "+resData.toString());
              print("График leng "+resData.toString());
              setState(() { });
            }

            if(valuesSocket[i]['coin']==jsonDecode(message)['data']['s']&&jsonDecode(message)['data']['k']['c']!=null) {
              // Обновление монеты если найден дубль

              if(jsonDecode(message)['data']['s'].toString()=="BTCUSDT"){
                setState(() {
                  lastClosePrice=jsonDecode(message)['data']['k']['c'].toString();
                  BTCpercent=PourcantCompare.toString();
                });
              }

              valuesSocket[i]['price']=jsonDecode(message)['data']['k']['c'].toString();
              valuesSocket[i]['percant']=PourcantCompare.toString();
              valuesSocket[i]['date']=3;
              var len=valuesSocket[i]['graphData'].length+1;
              if(valuesSocket[i]['graphDataMinutes']!=DateTime.now().minute){
                valuesSocket[i]['graphDataMinutes']=DateTime.now().minute;
                valuesSocket[i]['graphData'].add(ChartData(len, double.parse(jsonDecode(message)['data']['k']['c'].toString())));
              }
              valuesSocket[i]['newcard']=0;

              NewIndex=0;
            }
          }

          setState(() { // Добавление нового элемента
            if(NewIndex==1){ // Проверка на наличие элемента в массиве
              if(BackgroundIndex[type]==1) {

                if(NotificationLimitIndexInMinute!=DateTime.now().minute) {
                  NotifyColIndex[type]=0;
                  NotificationLimitIndexInMinute=DateTime.now().minute;
                }
                if(NotifyColIndex[type]<5) {
                  NotifyColIndex[type]=NotifyColIndex[type]+1;
                  service.showNotification(id: 12, title: jsonDecode(message)['data']['s'].toString()+" | "+PourcantCompare.toString().substring(0,5)+"%", body: "\$"+jsonDecode(message)['data']['k']['c'].toString());
                }
              }

              if(jsonDecode(message)['data']['s'].toString()=="BTCUSDT"){
                setState(() {
                  lastClosePrice=jsonDecode(message)['data']['k']['c'].toString();
                  BTCpercent=PourcantCompare.toString();
                });
              }

              if (jsonDecode(message)['data']['k']['c']!=null) {
                valuesSocket.add(
                  {
                    'coin':jsonDecode(message)['data']['s'].toString(),
                    'price':jsonDecode(message)['data']['k']['c'].toString(),
                    'percant':PourcantCompare.toString(),
                    'date':date1,
                    'BullishIndex':0,
                    'graphDataMinutes':0,
                    'graphDataIndexCheck':0,
                    'graphData':[ChartData(1, double.parse(jsonDecode(message)['data']['k']['c'].toString()))],
                    'newcard':1,
                    'saveDate':DateTime.now().add(durationsList[saveIndex[type]]),
                  },
                );
                LoadAnimate(1);
              }

            }
          });

          if(NewIndex==1){
            for(int i=0;i<valuesSocket.length;i++) {
              if(((valuesSocket[i]['graphData'] as List).length<3&&valuesSocket[i]['graphDataIndexCheck']==0)){

                valuesSocket[i]['graphDataIndexCheck']=1;
                final uri = Uri.parse('https://api.binance.com/api/v3/uiKlines?symbol='+valuesSocket[i]['coin'].toString().toUpperCase()+'&interval='+timeIntervalsHttp[date1]+'&limit=30');
                final res = await http.get(uri);
                var resData = (jsonDecode(res.body) as List);
                for(int ii = 0;ii<resData.length;ii++){
                  valuesSocket[i]['graphData'].add(ChartData(valuesSocket[i]['graphData'].length+1, double.parse(resData[ii][4].toString())));
                }
                print("График "+resData.toString());
                print("График leng "+resData.toString());
                setState(() {


                });

              }
            }
          }

        }

      });

      SocketChannel3 = IOWebSocketChannel.connect(Uri.parse('wss://stream.binance.com:9443/stream?streams=$coinsLink'));
      SocketChannel3.stream.listen((message) async {

        var a=double.parse(jsonDecode(message)['data']['k']['o'].toString()); var b=double.parse(jsonDecode(message)['data']['k']['c'].toString());
        var PourcantCompare=(b/a-1)*100; // Подсчет процента
        print((type.toString()+" "+date1.toString()+" Symbol: "+jsonDecode(message)['data']['s'].toString()+" Price:"+jsonDecode(message)['data']['k']['c'].toString()).toString()+" Percent: "+PourcantCompare.toString()+" OpenPrice:"+(jsonDecode(message)['data']['k']['o'].toString()).toString());
        List<bool> BoolsList=[(PourcantCompare>percent1),(PourcantCompare>percent1||(PourcantCompare>percent2)),(PourcantCompare<percent1),];
        var NewIndex=1; // Проверка на новизну



        if(BoolsList[type]){ // Поиск монеты если подходит условиям
          print(jsonDecode(message)['data']['s'].toString()+" "+jsonDecode(message)['data']['k']['c'].toString());
          print("Подходит ");

          for(int i=0;i<valuesSocket.length;i++) {

            if(((valuesSocket[i]['saveDate'] as DateTime).difference(DateTime.now())).inSeconds<=0){
              if(type==0){Values.removeAt(i);};if(type==1){Values1.removeAt(i);};if(type==2){Values2.removeAt(i);};
              valuesSocket.removeAt(i); // Удаление истекших дат
            }

            if(((valuesSocket[i]['graphData'] as List).length<3&&valuesSocket[i]['graphDataIndexCheck']==0)){

              valuesSocket[i]['graphDataIndexCheck']=1;
              final uri = Uri.parse('https://api.binance.com/api/v3/uiKlines?symbol='+valuesSocket[i]['coin'].toString().toUpperCase()+'&interval='+timeIntervalsHttp[date1]+'&limit=30');
              final res = await http.get(uri);
              var resData = (jsonDecode(res.body) as List);
              for(int ii = 0;ii<resData.length;ii++){
                valuesSocket[i]['graphData'].add(ChartData(valuesSocket[i]['graphData'].length+1, double.parse(resData[ii][4].toString())));
              }
              print("График "+resData.toString());
              print("График leng "+resData.toString());
              setState(() {

              });

            }

            if(valuesSocket[i]['coin']==jsonDecode(message)['data']['s']&&jsonDecode(message)['data']['k']['c']!=null) {
              // Обновление монеты если найден дубль

              if(jsonDecode(message)['data']['s'].toString()=="BTCUSDT"){
                setState(() {
                  lastClosePrice=jsonDecode(message)['data']['k']['c'].toString();
                  BTCpercent=PourcantCompare.toString();
                });
              }

              valuesSocket[i]['price']=jsonDecode(message)['data']['k']['c'].toString();
              valuesSocket[i]['percant']=PourcantCompare.toString();
              valuesSocket[i]['date']=date1;
              var len=valuesSocket[i]['graphData'].length+1;
              if(valuesSocket[i]['graphDataMinutes']!=DateTime.now().minute){
                valuesSocket[i]['graphDataMinutes']=DateTime.now().minute;
                valuesSocket[i]['graphData'].add(ChartData(len, double.parse(jsonDecode(message)['data']['k']['c'].toString())));
              }
              valuesSocket[i]['newcard']=0;

              NewIndex=0;
            }
          }

          setState(() { // Добавление нового элемента
            if(NewIndex==1){ // Проверка на наличие элемента в массиве
              if(BackgroundIndex[type]==1) {

                if(NotificationLimitIndexInMinute!=DateTime.now().minute) {
                  NotifyColIndex[type]=0;
                  NotificationLimitIndexInMinute=DateTime.now().minute;
                }
                if(NotifyColIndex[type]<5) {
                  NotifyColIndex[type]=NotifyColIndex[type]+1;
                  service.showNotification(id: 12, title: jsonDecode(message)['data']['s'].toString()+" | "+PourcantCompare.toString().substring(0,5)+"%", body: "\$"+jsonDecode(message)['data']['k']['c'].toString());
                }
              }

              if(jsonDecode(message)['data']['s'].toString()=="BTCUSDT"){
                setState(() {
                  lastClosePrice=jsonDecode(message)['data']['k']['c'].toString();
                  BTCpercent=PourcantCompare.toString();
                });
              }

              if (jsonDecode(message)['data']['k']['c']!=null) {
                valuesSocket.add(
                  {
                    'coin':jsonDecode(message)['data']['s'].toString(),
                    'price':jsonDecode(message)['data']['k']['c'].toString(),
                    'percant':PourcantCompare.toString(),
                    'date':date1,
                    'BullishIndex':0,
                    'graphDataMinutes':0,
                    'graphDataIndexCheck':0,
                    'graphData':[ChartData(1, double.parse(jsonDecode(message)['data']['k']['c'].toString()))],
                    'newcard':1,
                    'saveDate':DateTime.now().add(durationsList[saveIndex[type]]),
                  },
                );
                LoadAnimate(1);
              }

            }
          });

          if(NewIndex==1){
            for(int i=0;i<valuesSocket.length;i++) {
              if(((valuesSocket[i]['graphData'] as List).length<3&&valuesSocket[i]['graphDataIndexCheck']==0)){

                valuesSocket[i]['graphDataIndexCheck']=1;
                final uri = Uri.parse('https://api.binance.com/api/v3/uiKlines?symbol='+valuesSocket[i]['coin'].toString().toUpperCase()+'&interval='+timeIntervalsHttp[date1]+'&limit=30');
                final res = await http.get(uri);
                var resData = (jsonDecode(res.body) as List);
                for(int ii = 0;ii<resData.length;ii++){
                  valuesSocket[i]['graphData'].add(ChartData(valuesSocket[i]['graphData'].length+1, double.parse(resData[ii][4].toString())));
                }
                print("График "+resData.toString());
                print("График leng "+resData.toString());
                setState(() {


                });

              }
            }
          }
        }

      });

    }

    if(type==2) {
      SocketChannel4 = IOWebSocketChannel.connect(Uri.parse('wss://stream.binance.com:9443/stream?streams=$coinsLink'));
      SocketChannel4.stream.listen((message) async {

        var a=double.parse(jsonDecode(message)['data']['k']['o'].toString()); var b=double.parse(jsonDecode(message)['data']['k']['c'].toString());
        var PourcantCompare=(b/a-1)*100; // Подсчет процента
        print((type.toString()+" "+date1.toString()+" Symbol: "+jsonDecode(message)['data']['s'].toString()+" Price:"+jsonDecode(message)['data']['k']['c'].toString()).toString()+" Percent: "+PourcantCompare.toString()+" OpenPrice:"+(jsonDecode(message)['data']['k']['o'].toString()).toString());
        List<bool> BoolsList=[(PourcantCompare>percent1),(PourcantCompare>percent1||(PourcantCompare>percent2)),(PourcantCompare<percent1),];
        var NewIndex=1; // Проверка на новизну


        if(BoolsList[type]){ // Поиск монеты если подходит условиям
          print(jsonDecode(message)['data']['s'].toString()+" "+jsonDecode(message)['data']['k']['c'].toString());
          print("Подходит ");

          for(int i=0;i<valuesSocket.length;i++) {

            if(((valuesSocket[i]['saveDate'] as DateTime).difference(DateTime.now())).inSeconds<=0){
              if(type==0){Values.removeAt(i);};if(type==1){Values1.removeAt(i);};if(type==2){Values2.removeAt(i);};
              valuesSocket.removeAt(i); // Удаление истекших дат
            }

            if(((valuesSocket[i]['graphData'] as List).length<3&&valuesSocket[i]['graphDataIndexCheck']==0)){

              valuesSocket[i]['graphDataIndexCheck']=1;
              final uri = Uri.parse('https://api.binance.com/api/v3/uiKlines?symbol='+valuesSocket[i]['coin'].toString().toUpperCase()+'&interval='+timeIntervalsHttp[date1]+'&limit=30');
              final res = await http.get(uri);
              var resData = (jsonDecode(res.body) as List);
              for(int ii = 0;ii<resData.length;ii++){
                valuesSocket[i]['graphData'].add(ChartData(valuesSocket[i]['graphData'].length+1, double.parse(resData[ii][4].toString())));
              }
              print("График "+resData.toString());
              print("График leng "+resData.toString());
              setState(() {

              });

            }

            if(valuesSocket[i]['coin']==jsonDecode(message)['data']['s']&&jsonDecode(message)['data']['k']['c']!=null) {
              // Обновление монеты если найден дубль

              if(jsonDecode(message)['data']['s'].toString()=="BTCUSDT"){
                setState(() {
                  lastClosePrice=jsonDecode(message)['data']['k']['c'].toString();
                  BTCpercent=PourcantCompare.toString();
                });
              }

              valuesSocket[i]['price']=jsonDecode(message)['data']['k']['c'].toString();
              valuesSocket[i]['percant']=PourcantCompare.toString();
              valuesSocket[i]['date']=date1;
              var len=valuesSocket[i]['graphData'].length+1;
              if(valuesSocket[i]['graphDataMinutes']!=DateTime.now().minute){
                valuesSocket[i]['graphDataMinutes']=DateTime.now().minute;
                valuesSocket[i]['graphData'].add(ChartData(len, double.parse(jsonDecode(message)['data']['k']['c'].toString())));
              }
              valuesSocket[i]['newcard']=0;

              NewIndex=0;
            }
          }

          setState(() { // Добавление нового элемента
            if(NewIndex==1){ // Проверка на наличие элемента в массиве
              if(BackgroundIndex[type]==1) {

                if(NotificationLimitIndexInMinute!=DateTime.now().minute) {
                  NotifyColIndex[type]=0;
                  NotificationLimitIndexInMinute=DateTime.now().minute;
                }
                if(NotifyColIndex[type]<5) {
                  NotifyColIndex[type]=NotifyColIndex[type]+1;
                  service.showNotification(id: 12, title: jsonDecode(message)['data']['s'].toString()+" | "+PourcantCompare.toString().substring(0,5)+"%", body: "\$"+jsonDecode(message)['data']['k']['c'].toString());
                }
              }

              if(jsonDecode(message)['data']['s'].toString()=="BTCUSDT"){
                setState(() {
                  lastClosePrice=jsonDecode(message)['data']['k']['c'].toString();
                  BTCpercent=PourcantCompare.toString();
                });
              }


              if (jsonDecode(message)['data']['k']['c']!=null) {
                valuesSocket.add(
                  {
                    'coin':jsonDecode(message)['data']['s'].toString(),
                    'price':jsonDecode(message)['data']['k']['c'].toString(),
                    'percant':PourcantCompare.toString(),
                    'date':date1,
                    'BullishIndex':0,
                    'graphDataMinutes':0,
                    'graphDataIndexCheck':0,
                    'graphData':[ChartData(1, double.parse(jsonDecode(message)['data']['k']['c'].toString()))],
                    'newcard':1,
                    'saveDate':DateTime.now().add(durationsList[saveIndex[type]]),
                  },
                );
                LoadAnimate(2);
              }

            }
          });

          if(NewIndex==1){
            for(int i=0;i<valuesSocket.length;i++) {
              if(((valuesSocket[i]['graphData'] as List).length<3&&valuesSocket[i]['graphDataIndexCheck']==0)){

                valuesSocket[i]['graphDataIndexCheck']=1;
                final uri = Uri.parse('https://api.binance.com/api/v3/uiKlines?symbol='+valuesSocket[i]['coin'].toString().toUpperCase()+'&interval='+timeIntervalsHttp[date1]+'&limit=30');
                final res = await http.get(uri);
                var resData = (jsonDecode(res.body) as List);
                for(int ii = 0;ii<resData.length;ii++){
                  valuesSocket[i]['graphData'].add(ChartData(valuesSocket[i]['graphData'].length+1, double.parse(resData[ii][4].toString())));
                }
                print("График "+resData.toString());
                print("График leng "+resData.toString());
                setState(() {


                });

              }
            }
          }

        }

      });
    }

  }

  void UpdateList() async{
    var newCash=await model.getCashNew();

    if(newCash.length!=0){
      newCash[11].forEach((element) async{
        final uri = Uri.parse('https://api.binance.com/api/v3/ticker?symbol='+element['coin']+'&windowSize=1d');
        final res = await http.get(uri);
        print("JSD "+jsonDecode(res.body).toString());
        element['price']=double.parse(jsonDecode(res.body)['lastPrice']);



        final uri2 = Uri.parse('https://api.binance.com/api/v3/klines?symbol='+element['coin']+'&interval=1d&limit=1');
        final res2 = await http.get(uri2);
        var a2=double.parse(jsonDecode(res2.body)[0][1]);
        var b2=double.parse(jsonDecode(res2.body)[0][4]);
        var PourcantCompare2=(b2/a2-1)*100;


        element['percant']=PourcantCompare2.toString();
        element['graphData'].add(ChartData(element['graphData'].length + 1, double.parse(jsonDecode(res.body)['lastPrice'])));

      });
    }

    await model.saveCashNew(newCash);
    setState(() {

    });
  }

  List CoinFilter(List coins) {

    var coinsTesting=[[],[],[],[]];
    var coinsCorrect=[];
    print("Шаг1 "+coins.toString());
    for(int i=0; i < coins.length; i++){

      if(coins[i].substring(coins[i].length-4)=="BUSD"){
        coinsTesting[0].add(coins[i].substring(0,coins[i].length-4));
      }

      if(coins[i].substring(coins[i].length-4)=="USDT"){
        coinsTesting[1].add(coins[i].substring(0,coins[i].length-4));
      }

      if(coins[i].substring(coins[i].length-3)=="BNB"){
        coinsTesting[2].add(coins[i].substring(0,coins[i].length-3));
      }

      if(coins[i].substring(coins[i].length-3)=="BTC"){
        coinsTesting[3].add(coins[i].substring(0,coins[i].length-3));
      }
    }

    print("Шаг 8 ");
  //Чистка и сортировка одинаковых монет
  coinsTesting[0].forEach((element) {
    coinsTesting[1].removeWhere((element2) => element2==element);
    coinsTesting[2].removeWhere((element2) => element2==element);
    coinsTesting[3].removeWhere((element2) => element2==element);
  });

  coinsTesting[1].forEach((element) {
    coinsTesting[2].removeWhere((element2) => element2==element);
    coinsTesting[3].removeWhere((element2) => element2==element);
  });

  coinsTesting[2].forEach((element) {
    coinsTesting[3].removeWhere((element2) => element2==element);
  });
    print("Шаг 9 ");

  // Проставление имени и сортировка в 1 массив
  coinsTesting[0].forEach((element) {coinsCorrect.add(element+"BUSD");});
  coinsTesting[1].forEach((element) {coinsCorrect.add(element+"USDT");});
  coinsTesting[2].forEach((element) {coinsCorrect.add(element+"BNB");});
  coinsTesting[3].forEach((element) {coinsCorrect.add(element+"BTC");});

    print("Шаг 10 ");
  return coinsCorrect;
  }

  void ListingFunc(changerVar,percents,dates,typeOfData) async {

    print("1 — Получение запроса");
    List decode=[]; // Начало листинга
    try { // http запросы
      final res = await http.get(Uri.parse("https://api.binance.com/api/v3/ticker/24hr"));
      (jsonDecode(res.body) as List).forEach((element) {decode.add(element);});
    } catch (e) {print("Ошибка тикера 1"+e.toString());} //Парсинг новых значений

    await Future.delayed(Duration(seconds: 3));

    print("2 — Данные из памяти");
    var modelx = await model.getDataListing() as List; //Данные из памяти
    print("modelx length "+modelx.length.toString());

    print("3.5 — Показ длины старых и новых значений");
    // print("modelx.length[last] "+modelx[modelx.length-3].length.toString());
    // print("decode.length[last] "+decode.length.toString());
    //
    // print("modelx.length "+modelx[modelx.length-3].length.toString());
    // print("decode.length2 "+decode.length.toString());

    // modelx[modelx.length-3].removeAt(2);

    await Future.delayed(Duration(seconds: 1));

    print("3 — Сохранение декода");
    print("decode "+decode.length.toString());


    var decode22=[]; decode.forEach((element) {decode22.add(element);});

    model.saveDataListing(decode22,DateTime.now()); // Сохранение значений
    await Future.delayed(Duration(seconds: 3));

    print("4 — Показ длины старых и новых значений");
    print("modelx.length[last] "+modelx[modelx.length-3].length.toString());
    print("decode.length[last] "+decode.length.toString());

    print("modelx.length "+modelx[modelx.length-3].length.toString());
    print("decode.length2 "+decode.length.toString());
    var data=[]; // Переменная для обьектов

    await Future.delayed(Duration(seconds: 3));

    print("5 — Получение новых монет и подготовка к выводу");

    var decode2=[];
    decode.forEach((DecodeElement) {

      var indexs=0;
      // print("modelx "+modelx.toString());
      (modelx[modelx.length-3] as List).forEach((OldElement) {
        // print("modelx "+modelx.toString());
        if(OldElement['symbol']==DecodeElement['symbol']){
          indexs=1;
          if((OldElement['lastPrice']=='0.00000000')&&(DecodeElement['lastPrice']!='0.00000000')){
            print("OldElement['lastPrice']"+OldElement['lastPrice'].toString());
            print("DecodeElement['lastPrice']"+DecodeElement['lastPrice'].toString());

          }
        }
      });

      if(indexs==0){
        if((DecodeElement['lastPrice']!='0.00000000')&&(DecodeElement['lastPrice']!='0.00000000')){
          decode2.add(DecodeElement);
        }
      }
    });

    print("Новые монеты DC "+decode2.length.toString());
    data=decode2;


    print("Колиество новых монет "+data.length.toString()); // Подготовка
    var coinsCorrect=[]; var pricesCorrect=[]; var priceChange=[]; var decodePrevOpenPrice=[]; var emptyGraph=[]; var CurrentDate=DateTime.now();

    await Future.delayed(Duration(seconds: 2));

    print("6 — Расшифровка декода");
    print("data.length "+data.length.toString());
    if(data.length<500&&data.length>0) { // Расшифровка декода
      data.forEach((element) {
        emptyGraph.add([111.111,111.111,111.111]);
        coinsCorrect.add(element["symbol"]);
        pricesCorrect.add(element["lastPrice"]);
        priceChange.add(element["priceChangePercent"]);
        decodePrevOpenPrice.add(element["openPrice"]);
      });
    }

    await Future.delayed(Duration(seconds: 2));

    print("7 — Превращение в обьекты");
    List coinMapList=[]; // Превращение в обьекты
    for(int i=0;i<coinsCorrect.length;i++){
      Map coinMap=Map();
      coinMap["coin"]=coinsCorrect[i];
      coinMap["price"]=pricesCorrect[i];
      coinMap["date"]=3;
      coinMap["percant"]=priceChange[i];
      coinMap["saveDate"]=DateTime.now().add(durationsList2[saveInFutureIndexListing]);
      coinMap["graphData"]=[ChartData(1, double.parse(pricesCorrect[i]))];
      coinMapList.add(coinMap);
      print("coin "+coinMapList[i].toString());
    } // Превращение в обьекты

    await Future.delayed(Duration(seconds: 2));


    print("8 — Сохранение и получение новых монет");

    var newCash=await model.getCashNew();
    if(newCash.isNotEmpty) {


      coinMapList.forEach((NewCoinMap) {
        var changes=0;
        (newCash[11] as List).forEach((OldCoinMapMemory) {
          if(OldCoinMapMemory['coin']==NewCoinMap['coin']) {
            changes=1; // Если монеты там нет, то добавляем старые к новым
          }
        });
        if(changes!=1) {
          // Нужно добавлять новую монету к старым если ее там нет
          (newCash[11] as List).add(NewCoinMap);
        }



      // (newCash[11] as List).forEach((OldCoinMapMemory) {
      //   print("Обнаружены сохраненная монета ");
      //   var changes=0;
      //   coinMapList.forEach((NewCoinMap) {
      //     if(OldCoinMapMemory['coin']!=NewCoinMap['coin']) {
      //       changes=1; // Если монеты там нет, то добавляем старые к новым
      //     }
      //   });
      //   if(changes==1) {
      //     // Нужно добавлять новую монету к старым если ее там нет
      //     coinMapList.add(OldCoinMapMemory); // Добавление в массив с новой монетой добавляются старые для пересохранения
      //   }
      // });
      });
    }


    // var newCash=await model.getCashNew();
    // if(newCash.isNotEmpty) {
    //   (newCash[11] as List).forEach((OldCoinMapMemory) {
    //     print("Обнаружены сохраненная монета ");
    //     var changes=0;
    //     coinMapList.forEach((NewCoinMap) {
    //       if(OldCoinMapMemory['coin']!=NewCoinMap['coin']) {
    //         changes=1;
    //       }
    //     });
    //     if(changes==1) {
    //       coinMapList.add(OldCoinMapMemory); // Добавление в массив с новой монетой добавляются старые для пересохранения
    //     }
    //   });
    // }
    //
    //

    await Future.delayed(Duration(seconds: 2));
    if(newCash.isNotEmpty) {
      (newCash[11] as List).removeWhere((element) =>
      DateTime.now().compareTo(element["saveDate"] as DateTime) == 1);

      (newCash[11] as List).forEach((CurrentCoins) async {

        if ((CurrentCoins['graphData'] as List).length < 10) {
          print("Supatest1 "+CurrentCoins.toString());
          final uri = Uri.parse(
              'https://api.binance.com/api/v3/uiKlines?symbol=' +
                  CurrentCoins['coin'].toString().toUpperCase() +
                  '&interval=1d&limit=30');
          final res = await http.get(uri);
          var resData = (jsonDecode(res.body) as List);
          for (int ii = 0; ii < resData.length; ii++) {
            print("Supatest2 "+CurrentCoins.toString());
            CurrentCoins['graphData'].add(ChartData(
                (CurrentCoins['graphData'] as List).length + 1,
                double.parse(resData[ii][4].toString())));
          };
        };
      });

      await Future.delayed(Duration(seconds: 3));


      (newCash[11] as List).forEach((element) {
        print(element["saveDate"]);
      });


      (newCash[11] as List).forEach((NewCoin) {

        var GraphDataToChange=[];

        for(int e=0;e<NewCoin['graphData'].length;e++) {

          var Xdata=NewCoin['graphData'][e].x;
          var Ydata=NewCoin['graphData'][e].y;

          GraphDataToChange.add([Xdata,Ydata]);
        }
        (NewCoin as Map)['graphDataAdapted']=GraphDataToChange;

        NewCoin.remove('graphData');

      });

      var result = [
        coinsCorrect,
        pricesCorrect,
        priceChange,
        decodePrevOpenPrice,
        CurrentDate,
        percents[0],
        percents[1],
        dates[0],
        dates[1],
        TypeOfDataIndex,
        emptyGraph,
        (newCash[11] as List)
      ];

      await model.saveCashNew(result);
      print("9 — Вывод "+result.toString());

    } else {

      // Конвертация

      coinMapList.forEach((NewCoin) {

        var GraphDataToChange=[];

        for(int e=0;e<NewCoin['graphData'].length;e++) {

          var Xdata=NewCoin['graphData'][e].x;
          var Ydata=NewCoin['graphData'][e].y;

          GraphDataToChange.add([Xdata,Ydata]);
        }
        (NewCoin as Map)['graphDataAdapted']=GraphDataToChange;

        NewCoin.remove('graphData');

      });





      var result = [
        coinsCorrect,
        pricesCorrect,
        priceChange,
        decodePrevOpenPrice,
        CurrentDate,
        percents[0],
        percents[1],
        dates[0],
        dates[1],
        TypeOfDataIndex,
        emptyGraph,
        coinMapList
      ];


      await model.saveCashNew(result);

      print("9 — Вывод "+result.toString());
    }



    // refreshCheck=false; return result; // Обнуление индексов и выдача результатов
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Color.fromRGBO(20, 26, 39, 1.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    padding: EdgeInsets.only(left: 24,top: 72),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          child: Text("Bitcoin price",style: TextStyle(color: Colors.white60,fontSize: 16)),
                          onTap: () async{
                            // UpdateList();
                            // model.clearCashNew();

                            ListingFunc(changerVarIndex,FinalPercent,FinalDate,TypeOfDataIndex);

                            // saveInFutureIndexListing=1;

                            // bool enabled = FlutterBackground.isBackgroundExecutionEnabled;

                            // FlutterBackground.initialize();
                            // await FlutterBackground.enableBackgroundExecution();
                            // await FlutterBackground.disableBackgroundExecution();

                            // await FlutterBackground.disableBackgroundExecution();
                            // print("Enable "+enabled.toString());

                            // var datas= await model.getTest();
                            // print("DATAS "+datas.toString());


                            print("Values1 "+Values1.toString());

                          },
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            if(lastClosePrice.length>4) ...[
                              InkWell(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => Details(coin: "BTCUSDT",date: 3,)));
                                  },
                                  onDoubleTap: (){
                                        ListingFunc(changerVarIndex,FinalPercent,FinalDate,TypeOfDataIndex);
                                  },
                                   child: Row(
                                    children: [
                                      Text('\$',style: TextStyle(color: Colors.white,fontSize: 36,fontWeight: FontWeight.w600)),
                                      SizedBox(width: 2),
                                      Text(lastClosePrice.toString().substring(0,7),style: TextStyle(color: Colors.white,fontSize: 36,fontWeight: FontWeight.w600)),
                                    ],
                                  )
                              )
                            ] else ...[
                              InkWell(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => Details(coin: "BTCUSDT",date: 3)));
                                  },
                                  onDoubleTap: (){
                                    ListingFunc(changerVarIndex,FinalPercent,FinalDate,TypeOfDataIndex);
                                  },
                                  child: Row(
                                    children: [
                                      Text('\$',style: TextStyle(color: Colors.white,fontSize: 36,fontWeight: FontWeight.w600)),
                                      SizedBox(width: 2),
                                      Text(lastClosePrice.toString().substring(0,7),style: TextStyle(color: Colors.white,fontSize: 36,fontWeight: FontWeight.w600)),
                                    ],
                                  )
                              )
                            ],
                            SizedBox(width: 16),
                            Container(
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(235, 87, 87, 1.0),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 12,vertical: 8),
                              child: InkWell(
                                  onTap: () async{

                                    var PopupData=await showDialog(
                                      context: context,
                                      builder: (BuildContext context) => PopupDialog(percents: FinalPercent,dates: FinalDate),
                                    );
                                    // print("PopupData "+PopupData.toString());
                                    if(PopupData!=null){

                                      if((FinalPercent[0]!=PopupData[0])||FinalDate[0]!=PopupData[4]){
                                        Values.clear();
                                      }

                                      if((FinalPercent[1]!=PopupData[1])||(FinalDate[1]!=PopupData[5])){
                                        Values1.clear();
                                      }

                                      if(FinalPercent[2]!=PopupData[2]||FinalDate[2]!=PopupData[6]){
                                        Values1.clear();
                                      }

                                      if(FinalPercent[3]!=PopupData[3]||FinalDate[3]!=PopupData[7]){
                                        Values2.clear();
                                      }

                                      setState(() {
                                        FinalPercent[0]=PopupData[0];
                                        FinalPercent[1]=PopupData[1];
                                        FinalPercent[2]=PopupData[2];
                                        FinalPercent[3]=PopupData[3];
                                        FinalDate[0]=PopupData[4];
                                        FinalDate[1]=PopupData[5];
                                        FinalDate[2]=PopupData[6];
                                        FinalDate[3]=PopupData[7];
                                      });

                                      model.saveOptions(PopupData);

                                      TypeOfDataIndex=1*TextStyleValue1+TextStyleValue2*2+TextStyleValue3*3+TextStyleValue4*4-1;

                                      SocketChannel.sink.close();
                                      SocketChannel2.sink.close();
                                      SocketChannel3.sink.close();
                                      SocketChannel4.sink.close();

                                      CryptoSocket(FinalPercent[0],FinalPercent[1],FinalDate[0],FinalDate[1],0,[saveInFutureIndexPump,saveInFutureIndexBullish,saveInFutureIndexBearlish,saveInFutureIndexListing],Values);
                                      CryptoSocket(FinalPercent[1],FinalPercent[2],FinalDate[1],FinalDate[2],1,[saveInFutureIndexPump,saveInFutureIndexBullish,saveInFutureIndexBearlish,saveInFutureIndexListing],Values1);
                                      CryptoSocket(FinalPercent[3],FinalPercent[3],FinalDate[3],FinalDate[3],2,[saveInFutureIndexPump,saveInFutureIndexBullish,saveInFutureIndexBearlish,saveInFutureIndexListing],Values2);

                                    }
                                  },
                                  child: Row(
                                    children: [
                                      if(BTCpercent.length>4) ...[
                                        Text(BTCpercent.toString().substring(0,5)+"%",style: TextStyle(color: Colors.white,fontSize: 16)),
                                      ] else ...[
                                        Text(BTCpercent.toString()+"%",style: TextStyle(color: Colors.white,fontSize: 16)),
                                      ]
                                    ],
                                  )
                              ),
                            )

                          ],
                        ),
                        SizedBox(height: 36),
                        Text("Watch list",style: TextStyle(color: Colors.white54,fontSize: 16)),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            InkWell(
                              onTap: (){
                                setState(() {
                                  TextStyleValue1=1;
                                  TextStyleValue2=0;
                                  TextStyleValue3=0;
                                  TextStyleValue4=0;
                                });
                                TypeOfDataIndex=1*TextStyleValue1+TextStyleValue2*2+TextStyleValue3*3+TextStyleValue4*4-1;



                              },
                              child: Text("Pump",style: TextStyles[TextStyleValue1]),
                            ),
                            SizedBox(width: 24),
                            InkWell(
                              onTap: (){
                                setState(() {
                                  TextStyleValue1=0;
                                  TextStyleValue2=1;
                                  TextStyleValue3=0;
                                  TextStyleValue4=0;
                                });
                                TypeOfDataIndex=1*TextStyleValue1+TextStyleValue2*2+TextStyleValue3*3+TextStyleValue4*4-1;



                              },
                              child: Text("Bullish",style: TextStyles[TextStyleValue2]),
                            ),
                            SizedBox(width: 24),
                            InkWell(
                              onTap: (){
                                setState(() {
                                  TextStyleValue1=0;
                                  TextStyleValue2=0;
                                  TextStyleValue3=1;
                                  TextStyleValue4=0;
                                });
                                TypeOfDataIndex=1*TextStyleValue1+TextStyleValue2*2+TextStyleValue3*3+TextStyleValue4*4-1;


                              },
                              child: Text("Bearish",style: TextStyles[TextStyleValue3]),
                            ),
                            SizedBox(width: 24),
                            InkWell(
                              onTap: (){
                                setState(() {
                                  TextStyleValue1=0;
                                  TextStyleValue2=0;
                                  TextStyleValue3=0;
                                  TextStyleValue4=1;
                                });
                                TypeOfDataIndex=1*TextStyleValue1+TextStyleValue2*2+TextStyleValue3*3+TextStyleValue4*4-1;
                              },
                              child: Text("Listing",style: TextStyles[TextStyleValue4]),

                            ),
                            SizedBox(width: 24),
                            // Container(
                            //     height: 19,
                            //     width: 19,
                            //     child: Icon(CupertinoIcons.search,size: 19,)
                            // )

                          ],
                        ),
                      ],
                    )
                ),
                SizedBox(height: 12),
                Stack(
                  children: [
                    Container(
                      color: Colors.white12,
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 1),
                      height: 1,
                    ),
                    Container(

                      margin: EdgeInsets.only(left: 20*(TextStyleValue1+TextStyleValue2*4.5+TextStyleValue3*8.2+TextStyleValue4*12)),
                      color: Colors.white,
                      width: (52+TextStyleValue1+TextStyleValue2*4+TextStyleValue3*8.2+TextStyleValue4*6),
                      height: 2,
                    )
                  ],
                ),
                Container(
                  height: 64,
                  color: Colors.black.withAlpha(70),
                  width: double.infinity,
                  padding: EdgeInsets.only(top: 16,bottom: 16),
                  child: ListView(
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.only(left: 24),
                    scrollDirection: Axis.horizontal,
                    children: [
                      InkWell(
                        onTap: (){
                          setState(() {
                            StartStop=1;
                          });

                          CryptoSocket(FinalPercent[0],FinalPercent[1],FinalDate[0],FinalDate[1],0,[saveInFutureIndexPump,saveInFutureIndexBullish,saveInFutureIndexBearlish,saveInFutureIndexListing],Values);
                          CryptoSocket(FinalPercent[1],FinalPercent[2],FinalDate[1],FinalDate[2],1,[saveInFutureIndexPump,saveInFutureIndexBullish,saveInFutureIndexBearlish,saveInFutureIndexListing],Values1);
                          CryptoSocket(FinalPercent[3],FinalPercent[3],FinalDate[3],FinalDate[3],2,[saveInFutureIndexPump,saveInFutureIndexBullish,saveInFutureIndexBearlish,saveInFutureIndexListing],Values2);

                          // }
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 8),
                          padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(33, 37, 49, 1.0),
                              borderRadius: BorderRadius.circular(8)
                          ),
                          child: Row(
                            children: [
                              Icon(CupertinoIcons.bitcoin_circle_fill,color: Colors.white,size: 16,),
                              SizedBox(width: 8,),
                              Text("Старт",style: TextStyle(fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          setState(() {
                            StartStop=0;
                          });

                          SocketChannel.sink.close();
                          SocketChannel2.sink.close();
                          SocketChannel3.sink.close();
                          SocketChannel4.sink.close();
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 8),
                          padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(33, 37, 49, 1.0),
                              borderRadius: BorderRadius.circular(8)
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.stop_circle_rounded,color: Colors.white,size: 16,),
                              SizedBox(width: 8,),
                              Text("Стоп",style: TextStyle(fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (){

                          ListingFunc(changerVarIndex,FinalPercent,FinalDate,TypeOfDataIndex);

                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 8),
                          padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(33, 37, 49, 1.0),
                              borderRadius: BorderRadius.circular(8)
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.stop_circle_rounded,color: Colors.white,size: 16,),
                              SizedBox(width: 8,),
                              Text("Листинг",style: TextStyle(fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                      ),

                      InkWell(
                        onTap: (){
                          if(SortValue==0){
                            setState(() {
                              SortValue=1;
                            });
                          } else {
                            setState(() {
                              SortValue=0;
                            });
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 8),
                          padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(33, 37, 49, 1.0),
                              borderRadius: BorderRadius.circular(8)
                          ),
                          child: Row(
                            children: [
                              if (SortValue==0) ...[
                                Icon(Icons.arrow_downward,color: Colors.white,size: 16,),
                              ] else ...[
                                Icon(Icons.arrow_upward,color: Colors.white,size: 16,),
                              ]
                            ],
                          ),
                        ),
                      ),
                      if(TypeOfDataIndex==0) ...[
                        Container(
                          margin: EdgeInsets.only(right: 8),
                          padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(33, 37, 49, 1.0),
                              borderRadius: BorderRadius.circular(8)
                          ),
                          child: Row(
                            children: [
                              Icon(CupertinoIcons.bitcoin_circle_fill,color: Colors.white,size: 16,),
                              SizedBox(width: 8,),
                              Text(Values.length.toString(),style: TextStyle(fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if(saveInFutureIndexPump!=6){
                              setState(() {
                                saveInFutureIndexPump=saveInFutureIndexPump+1;
                                Values.forEach((element) {
                                  element['saveDate']=DateTime.now().add(durationsList[saveInFutureIndexPump]);
                                });
                              });
                            } else {
                              setState(() {
                                saveInFutureIndexPump=0;
                                Values.forEach((element) {
                                  element['saveDate']=DateTime.now().add(durationsList[saveInFutureIndexPump]);
                                });
                              });
                            }

                            SocketChannel.sink.close();
                            SocketChannel2.sink.close();
                            SocketChannel3.sink.close();
                            SocketChannel4.sink.close();

                            if(UpDateTime.compareTo(DateTime.now())!=-1){ tests=tests+1;
                            print("Нельзя");
                            } else { UpDateTime=DateTime.now().add(Duration(seconds: 5));



                            Future.delayed(Duration(seconds: 3)).then((value) {
                              CryptoSocket(FinalPercent[0],FinalPercent[1],FinalDate[0],FinalDate[1],0,[saveInFutureIndexPump,saveInFutureIndexBullish,saveInFutureIndexBearlish,saveInFutureIndexListing],Values);
                              CryptoSocket(FinalPercent[1],FinalPercent[2],FinalDate[1],FinalDate[2],1,[saveInFutureIndexPump,saveInFutureIndexBullish,saveInFutureIndexBearlish,saveInFutureIndexListing],Values1);
                              CryptoSocket(FinalPercent[3],FinalPercent[3],FinalDate[3],FinalDate[3],2,[saveInFutureIndexPump,saveInFutureIndexBullish,saveInFutureIndexBearlish,saveInFutureIndexListing],Values2);
                            });


                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                            margin: EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(33, 37, 49, 1.0),
                                borderRadius: BorderRadius.circular(8)
                            ),
                            child: Row(
                              children: [
                                Icon(CupertinoIcons.timer,color: Colors.white,size: 16,),
                                SizedBox(width: 8,),
                                Text(timeIntervals[saveInFutureIndexPump],style: TextStyle(fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                        ),
                      ],
                      if(TypeOfDataIndex==1) ...[
                        Container(
                          margin: EdgeInsets.only(right: 8),
                          padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(33, 37, 49, 1.0),
                              borderRadius: BorderRadius.circular(8)
                          ),
                          child: Row(
                            children: [
                              Icon(CupertinoIcons.bitcoin_circle_fill,color: Colors.white,size: 16,),
                              SizedBox(width: 8,),
                              Text(Values1.length.toString(),style: TextStyle(fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () async{
                            if(saveInFutureIndexBullish!=6){
                              setState(() {
                                saveInFutureIndexBullish=saveInFutureIndexBullish+1;
                                Values1.forEach((element) {
                                  element['saveDate']=DateTime.now().add(durationsList[saveInFutureIndexBullish]);
                                });
                              });
                            } else {
                              setState(() {
                                saveInFutureIndexBullish=0;
                                Values1.forEach((element) {
                                  element['saveDate']=DateTime.now().add(durationsList[saveInFutureIndexBullish]);
                                });
                              });
                            }

                            await SocketChannel.sink.close();
                            await SocketChannel2.sink.close();
                            await SocketChannel3.sink.close();
                            await SocketChannel4.sink.close();

                            if(UpDateTime.compareTo(DateTime.now())!=-1){ tests=tests+1;
                            print("Нельзя");
                            } else { UpDateTime=DateTime.now().add(Duration(seconds: 5));

                            Future.delayed(Duration(seconds: 3)).then((value) {
                              CryptoSocket(FinalPercent[0],FinalPercent[1],FinalDate[0],FinalDate[1],0,[saveInFutureIndexPump,saveInFutureIndexBullish,saveInFutureIndexBearlish,saveInFutureIndexListing],Values);
                              CryptoSocket(FinalPercent[1],FinalPercent[2],FinalDate[1],FinalDate[2],1,[saveInFutureIndexPump,saveInFutureIndexBullish,saveInFutureIndexBearlish,saveInFutureIndexListing],Values1);
                              CryptoSocket(FinalPercent[3],FinalPercent[3],FinalDate[3],FinalDate[3],2,[saveInFutureIndexPump,saveInFutureIndexBullish,saveInFutureIndexBearlish,saveInFutureIndexListing],Values2);
                            });
                            }

                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                            margin: EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(33, 37, 49, 1.0),
                                borderRadius: BorderRadius.circular(8)
                            ),
                            child: Row(
                              children: [
                                Icon(CupertinoIcons.timer,color: Colors.white,size: 16,),
                                SizedBox(width: 8,),
                                Text(timeIntervals[saveInFutureIndexBullish],style: TextStyle(fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                        ),
                      ],
                      if(TypeOfDataIndex==2) ...[
                        Container(
                          margin: EdgeInsets.only(right: 8),
                          padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(33, 37, 49, 1.0),
                              borderRadius: BorderRadius.circular(8)
                          ),
                          child: Row(
                            children: [
                              Icon(CupertinoIcons.bitcoin_circle_fill,color: Colors.white,size: 16,),
                              SizedBox(width: 8,),
                              Text(Values2.length.toString(),style: TextStyle(fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            if(saveInFutureIndexBearlish!=6){
                              setState(() {
                                saveInFutureIndexBearlish=saveInFutureIndexBearlish+1;
                                Values2.forEach((element) {
                                  element['saveDate']=DateTime.now().add(durationsList[saveInFutureIndexBearlish]);
                                });
                              });
                            } else {
                              setState(() {
                                saveInFutureIndexBearlish=0;
                                Values2.forEach((element) {
                                  element['saveDate']=DateTime.now().add(durationsList[saveInFutureIndexBearlish]);
                                });
                              });
                            }

                            await SocketChannel.sink.close();
                            await SocketChannel2.sink.close();
                            await SocketChannel3.sink.close();
                            await SocketChannel4.sink.close();

                            if(UpDateTime.compareTo(DateTime.now())!=-1){ tests=tests+1;
                            print("Нельзя");
                            } else { UpDateTime=DateTime.now().add(Duration(seconds: 5));

                            Future.delayed(Duration(seconds: 3)).then((value) {
                              CryptoSocket(FinalPercent[0],FinalPercent[1],FinalDate[0],FinalDate[1],0,[saveInFutureIndexPump,saveInFutureIndexBullish,saveInFutureIndexBearlish,saveInFutureIndexListing],Values);
                              CryptoSocket(FinalPercent[1],FinalPercent[2],FinalDate[1],FinalDate[2],1,[saveInFutureIndexPump,saveInFutureIndexBullish,saveInFutureIndexBearlish,saveInFutureIndexListing],Values1);
                              CryptoSocket(FinalPercent[3],FinalPercent[3],FinalDate[3],FinalDate[3],2,[saveInFutureIndexPump,saveInFutureIndexBullish,saveInFutureIndexBearlish,saveInFutureIndexListing],Values2);
                            });
                            }

                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                            margin: EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(33, 37, 49, 1.0),
                                borderRadius: BorderRadius.circular(8)
                            ),
                            child: Row(
                              children: [
                                Icon(CupertinoIcons.timer,color: Colors.white,size: 16,),
                                SizedBox(width: 8,),
                                Text(timeIntervals[saveInFutureIndexBearlish],style: TextStyle(fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                        ),
                      ],
                      if(TypeOfDataIndex==3) ...[
                        InkWell(
                          onTap: () async{

                            var dataToChange = await model.getCashNew();
                            if(saveInFutureIndexListing!=2){
                              setState(() {
                                saveInFutureIndexListing=saveInFutureIndexListing+1;
                                print("saveInFutureIndexListing "+saveInFutureIndexListing.toString());

                                if(dataToChange.isNotEmpty){
                                  print("isNotEmpty");
                                  dataToChange[11].forEach((element) {
                                    element['saveDate']=DateTime.now().add(durationsList2[saveInFutureIndexListing]);
                                  });
                                }

                                model.saveCashNew(dataToChange);
                              });
                            } else {
                              setState(() {
                                saveInFutureIndexListing=0;
                                print("saveInFutureIndexListing "+saveInFutureIndexListing.toString());

                                if(dataToChange.isNotEmpty){
                                  print("isNotEmpty");
                                  dataToChange[11].forEach((element) {
                                    element['saveDate']=DateTime.now().add(durationsList2[saveInFutureIndexListing]);
                                  });
                                }

                                model.saveCashNew(dataToChange);
                              });
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                            margin: EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(33, 37, 49, 1.0),
                                borderRadius: BorderRadius.circular(8)
                            ),
                            child: Row(
                              children: [
                                Icon(CupertinoIcons.timer,color: Colors.white,size: 16,),
                                SizedBox(width: 8,),
                                Text(timeIntervals2[saveInFutureIndexListing],style: TextStyle(fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                        ),
                      ],
                      if(TypeOfDataIndex!=3) ...[
                        Container(
                          margin: EdgeInsets.only(right: 8),
                          padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(33, 37, 49, 1.0),
                              borderRadius: BorderRadius.circular(8)
                          ),
                          child: Row(
                            children: [
                              Icon(CupertinoIcons.greaterthan_circle_fill,color: Colors.white,size: 16,),
                              SizedBox(width: 8,),
                              if(TypeOfDataIndex==0) ...[
                                if(FinalPercent[0].toString().length>3) ...[
                                  Text(FinalPercent[0].toString().substring(0,4)+"%"),
                                ] else ...[
                                  Text(FinalPercent[0].toString().substring(0,3)+"%"),
                                ],
                              ],
                              if(TypeOfDataIndex==1) ...[
                                if(FinalPercent[1].toString().length>3) ...[
                                  Text(FinalPercent[1].toString().substring(0,4)+"%  |"),
                                ] else ...[
                                  Text(FinalPercent[1].toString().substring(0,3)+"%  |"),
                                ],
                                SizedBox(width: 8,),
                                if(FinalPercent[2].toString().length>3) ...[
                                  Text(FinalPercent[2].toString().substring(0,4)+"%"),
                                ] else ...[
                                  Text(FinalPercent[2].toString().substring(0,3)+"%"),
                                ],
                              ],
                              if(TypeOfDataIndex==2) ...[
                                if(FinalPercent[3].toString().length>3) ...[
                                  Text(FinalPercent[3].toString().substring(0,4)+"%"),
                                ] else ...[
                                  Text(FinalPercent[3].toString().substring(0,3)+"%"),
                                ],
                              ],
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: (){

                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 8),
                            padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(33, 37, 49, 1.0),
                                borderRadius: BorderRadius.circular(8)
                            ),
                            child: Row(
                              children: [
                                Icon(CupertinoIcons.time_solid,color: Colors.white,size: 16,),
                                SizedBox(width: 8,),
                                if(TypeOfDataIndex==0) ...[
                                  Text(timeIntervals[FinalDate[0]],style: TextStyle(fontWeight: FontWeight.w500)),
                                ],
                                if(TypeOfDataIndex==1) ...[
                                  Text(timeIntervals[FinalDate[1]]+"  |  "+timeIntervals[FinalDate[2]],style: TextStyle(fontWeight: FontWeight.w500)),
                                ],
                                if(TypeOfDataIndex==2) ...[
                                  Text(timeIntervals[FinalDate[3]],style: TextStyle(fontWeight: FontWeight.w500)),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                      if(TypeOfDataIndex==0) ...[
                        InkWell(
                          onTap: (){

                            if(BackgroundIndex[0]==0) {
                              setState(() {
                                BackgroundIndex[0]=1;
                              });
                            } else {
                              setState(() {
                                BackgroundIndex[0]=0;
                              });
                            }

                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                            margin: EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(33, 37, 49, 1.0),
                              borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.blueAccent.withOpacity(BackgroundIndex[0].toDouble()*0.3))
                            ),
                            child: Row(
                              children: [
                                if(BackgroundIndex[0]==1) ...[
                                  Icon(CupertinoIcons.alarm_fill,color: Colors.white,size: 16),
                                  SizedBox(width: 8,),
                                  Text("Уведомления",style: TextStyle(fontWeight: FontWeight.w500,color: Colors.white)),
                                ] else ...[
                                  Icon(CupertinoIcons.alarm,color: Colors.white,size: 16),
                                  SizedBox(width: 8,),
                                  Text("Без уведомлений",style: TextStyle(fontWeight: FontWeight.w500,color: Colors.white)),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                      if(TypeOfDataIndex==1) ...[
                        InkWell(
                          onTap: (){

                            if(BackgroundIndex[1]==0) {

                              setState(() {
                                BackgroundIndex[1]=1;
                              });
                            } else {

                              setState(() {
                                BackgroundIndex[1]=0;
                              });
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                            margin: EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(33, 37, 49, 1.0),
                              borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.blueAccent.withOpacity(BackgroundIndex[1].toDouble()*0.3))
                            ),
                            child: Row(
                              children: [
                                if(BackgroundIndex[1]==1) ...[
                                  Icon(CupertinoIcons.alarm_fill,color: Colors.white,size: 16),
                                  SizedBox(width: 8,),
                                  Text("Уведомления",style: TextStyle(fontWeight: FontWeight.w500,color: Colors.white)),
                                ] else ...[
                                  Icon(CupertinoIcons.alarm,color: Colors.white,size: 16),
                                  SizedBox(width: 8,),
                                  Text("Без уведомлений",style: TextStyle(fontWeight: FontWeight.w500,color: Colors.white)),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                      if(TypeOfDataIndex==2) ...[
                        InkWell(
                          onTap: (){
                            if(BackgroundIndex[2]==0) {

                              setState(() {
                                BackgroundIndex[2]=1;
                              });


                            } else {

                              setState(() {
                                BackgroundIndex[2]=0;
                              });
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                            margin: EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(33, 37, 49, 1.0),
                              borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.blueAccent.withOpacity(BackgroundIndex[2].toDouble()*0.3))
                            ),
                            child: Row(
                              children: [
                                if(BackgroundIndex[2]==1) ...[
                                  Icon(CupertinoIcons.alarm_fill,color: Colors.white,size: 16),
                                  SizedBox(width: 8,),
                                  Text("Уведомления",style: TextStyle(fontWeight: FontWeight.w500,color: Colors.white)),
                                ] else ...[
                                  Icon(CupertinoIcons.alarm,color: Colors.white,size: 16),
                                  SizedBox(width: 8,),
                                  Text("Без уведомлений",style: TextStyle(fontWeight: FontWeight.w500,color: Colors.white)),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  )
                ),
                if(TypeOfDataIndex==0) ...[
                  Container(
                      width: double.infinity,
                    height: MediaQuery.of(context).size.height-314,
                      child: Stack(
                        children: [
                          ListView.builder(
                              padding: EdgeInsets.only(bottom: 60,top: 24),
                              itemCount: Values.length,
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              itemBuilder: (context,index) {

                                if(Values.isNotEmpty){
                                  var ValuesSort=[...Values];
                                  ValuesSort.sort((a,b) {
                                    List<bool> SortBools=[
                                      (double.parse(a['percant'])>double.parse(b['percant'])),
                                      (double.parse(a['percant'])<double.parse(b['percant']))
                                    ];
                                    if(SortBools[SortValue]){
                                      return 1;
                                    } else if (double.parse(a['percant'])==double.parse(b['percant'])){
                                      return 0;
                                    } else {
                                      return -1;
                                    }
                                  });
                                  // ValuesSort.removeWhere((element) => (((element['saveDate'] as DateTime).difference(DateTime.now())).inSeconds==0));

                                  if((ValuesSort[index] as Map).containsKey('graphData')){
                                    return InkWell(
                                      onDoubleTap: () async{
                                        print("Double Tap "+ValuesSort[index]["coin"].toString());
                                        var price="";
                                        price=(Values.firstWhere((element) => element["coin"]==ValuesSort[index]["coin"].toString()))['price'];
                                        print("Price: $price");

                                        final uri = Uri.parse('https://api.binance.com/api/v3/ticker?symbol='+ValuesSort[index]["coin"].toString()+'&windowSize='+timeIntervalsHttp[3]);
                                        final res = await http.get(uri);
                                        print("Decode "+jsonDecode(res.body)['lastPrice'].toString());
                                        setState(() {
                                          (Values.firstWhere((element) => element["coin"]==ValuesSort[index]["coin"].toString()))['price']=jsonDecode(res.body)['lastPrice'].toString();
                                        });
                                      },
                                      child: CryptoCard(name: ValuesSort[index]["coin"],price: ValuesSort[index]["price"],priceChange: ValuesSort[index]["percant"],period: ValuesSort[index]["date"],graphdata: ValuesSort[index]["graphData"],newcard: ValuesSort[index]["newcard"], saveDates: ValuesSort[index]["saveDate"],BullishIndex: ValuesSort[index]["BullishIndex"],)
                                    );
                                  } else return SizedBox(height: 0,);


                                } else {
                                  return Text("Empty");
                                }
                              }
                          ),
                          Positioned(
                            bottom: 0,
                            child: Container(
                              color: Colors.black,
                              height: 60,
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.only(left: 24,right: 24),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    children: [
                                      InkWell(
                                          onTap: (){ },
                                          child: Opacity(
                                            opacity: 1,
                                            child: AnimatedContainer(
                                                padding: boolTest ? EdgeInsets.only(bottom: 24) : EdgeInsets.only(bottom: 0),
                                                duration: animationDuration,
                                                child: IconButton(icon: boolTest ? SvgPicture.asset("lib/images/rocket.svg", color: TextStyleValue1==1 ? Colors.lightGreenAccent : Colors.white) : SvgPicture.asset("lib/images/rocket.svg", color: TextStyleValue1==1 ? Colors.green : Colors.white),onPressed: (){

                                                  setState(() {
                                                    TextStyleValue1=1;
                                                    TextStyleValue2=0;
                                                    TextStyleValue3=0;
                                                    TextStyleValue4=0;
                                                  });

                                                  TypeOfDataIndex=1*TextStyleValue1+TextStyleValue2*2+TextStyleValue3*3+TextStyleValue4*4-1;




                                                },),
                                            )
                                          )
                                      ),
                                      Text(Values.length.toString(),style: TextStyle(color: Colors.green),),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: (){
                                        },
                                        child: Opacity(
                                          opacity: 1,
                                          child: AnimatedContainer(
                                            padding: boolTest2 ? EdgeInsets.only(bottom: 24) : EdgeInsets.only(bottom: 0),
                                            duration: animationDuration,
                                            child: IconButton(icon: SvgPicture.asset("lib/images/statup.svg", color: TextStyleValue2==1 ? Colors.green : Colors.white),onPressed: (){
                                              setState(() {
                                                TextStyleValue1=0;
                                                TextStyleValue2=1;
                                                TextStyleValue3=0;
                                                TextStyleValue4=0;
                                              });
                                              TypeOfDataIndex=1*TextStyleValue1+TextStyleValue2*2+TextStyleValue3*3+TextStyleValue4*4-1;
                                            },),
                                          ),
                                        ),
                                      ),
                                      Text(Values1.length.toString(),style: TextStyle(color: Colors.white),),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: (){
                                        },
                                        child: Opacity(
                                          opacity: 1,
                                          child: AnimatedContainer(
                                            padding: boolTest3 ? EdgeInsets.only(bottom: 24) : EdgeInsets.only(bottom: 0),
                                            duration: animationDuration,
                                            child: IconButton(icon: SvgPicture.asset("lib/images/statdown.svg", color: TextStyleValue3==1 ? Colors.red : Colors.white),onPressed: (){
                                              setState(() {
                                                TextStyleValue1=0;
                                                TextStyleValue2=0;
                                                TextStyleValue3=1;
                                                TextStyleValue4=0;
                                              });
                                              TypeOfDataIndex=1*TextStyleValue1+TextStyleValue2*2+TextStyleValue3*3+TextStyleValue4*4-1;
                                            },),
                                          ),
                                        ),
                                      ),
                                      Text(Values2.length.toString(),style: TextStyle(color: Colors.white),),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Opacity(
                                        opacity: 1,
                                        child: AnimatedContainer(
                                          padding: boolTest4 ? EdgeInsets.only(bottom: 24) : EdgeInsets.only(bottom: 0),
                                          duration: animationDuration,
                                          child: IconButton(icon: SvgPicture.asset("lib/images/binance.svg", color: TextStyleValue4==1 ? Colors.yellow : Colors.white),onPressed: (){
                                            setState(() {
                                              TextStyleValue1=0;
                                              TextStyleValue2=0;
                                              TextStyleValue3=0;
                                              TextStyleValue4=1;
                                            });
                                            TypeOfDataIndex=1*TextStyleValue1+TextStyleValue2*2+TextStyleValue3*3+TextStyleValue4*4-1;
                                          },),
                                        ),
                                      ),
                                      FutureBuilder(
                                          future: model.getCashNew(),
                                          builder: (context,snapshot){

                                            if(snapshot.data!=null){
                                              if(snapshot.data!.isEmpty){
                                                return Text("0",style: TextStyle(
                                                    color: Colors.white
                                                ));
                                              }
                                              return Text(snapshot.data![11].length.toString(),style: TextStyle(
                                                  color: Colors.white
                                              ));
                                            } else {
                                              return Text("0",style: TextStyle(
                                                  color: Colors.white
                                              ));
                                            }

                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                  )
                ]
                else if (TypeOfDataIndex==1) ...[
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height-314,
                    child: Stack(
                      children: [
                        ListView.builder(
                            padding: EdgeInsets.only(bottom: 60,top: 24),
                            itemCount: Values1.length,
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemBuilder: (context,index) {
                              // return Text("as");
                              if(Values1.isNotEmpty){
                                print("Value 1 "+Values1.toString());
                                var ValuesSort=[...Values1];
                                ValuesSort.sort((a,b) {
                                  List<bool> SortBools=[
                                    (double.parse(a['percant'])>double.parse(b['percant'])),
                                    (double.parse(a['percant'])<double.parse(b['percant']))
                                  ];
                                  if(SortBools[SortValue]){
                                    return 1;
                                  } else if (double.parse(a['percant'])==double.parse(b['percant'])){
                                    return 0;
                                  } else {
                                    return -1;
                                  }
                                });
                                // ValuesSort.removeWhere((element) => (((element['saveDate'] as DateTime).difference(DateTime.now())).inSeconds==0));

                                if((ValuesSort[index] as Map).containsKey('graphData')){
                                  return InkWell(
                                    onDoubleTap: () async{
                                      print("Double Tap "+ValuesSort[index]["coin"].toString());
                                      var price="";
                                      price=(Values1.firstWhere((element) => element["coin"]==ValuesSort[index]["coin"].toString()))['price'];
                                      print("Price: $price");

                                      final uri = Uri.parse('https://api.binance.com/api/v3/ticker?symbol='+ValuesSort[index]["coin"].toString()+'&windowSize='+timeIntervalsHttp[3]);
                                      final res = await http.get(uri);
                                      print("Decode "+jsonDecode(res.body)['lastPrice'].toString());
                                      setState(() {
                                        (Values1.firstWhere((element) => element["coin"]==ValuesSort[index]["coin"].toString()))['price']=jsonDecode(res.body)['lastPrice'].toString();
                                      });

                                    },
                                    child: CryptoCard(name: ValuesSort[index]["coin"],price: ValuesSort[index]["price"],priceChange: ValuesSort[index]["percant"],period: ValuesSort[index]["date"],graphdata: ValuesSort[index]["graphData"],newcard: ValuesSort[index]["newcard"], saveDates: ValuesSort[index]["saveDate"],BullishIndex: ValuesSort[index]["BullishIndex"],)
                                  );
                                } else return SizedBox(height: 0,);
                              } else {
                                return Text("Empty");
                              }
                            }
                        ),
                        Positioned(
                          bottom: 0,
                          child: Container(
                            color: Colors.black,
                            height: 60,
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.only(left: 24,right: 24),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  children: [
                                    InkWell(
                                        onTap: (){ },
                                        child: Opacity(
                                            opacity: 1,
                                            child: AnimatedContainer(
                                              padding: boolTest ? EdgeInsets.only(bottom: 24) : EdgeInsets.only(bottom: 0),
                                              duration: animationDuration,
                                              child: IconButton(icon: boolTest ? SvgPicture.asset("lib/images/rocket.svg", color: TextStyleValue1==1 ? Colors.lightGreenAccent : Colors.white) : SvgPicture.asset("lib/images/rocket.svg", color: TextStyleValue1==1 ? Colors.green : Colors.white),onPressed: (){

                                                setState(() {
                                                  TextStyleValue1=1;
                                                  TextStyleValue2=0;
                                                  TextStyleValue3=0;
                                                  TextStyleValue4=0;
                                                });

                                                TypeOfDataIndex=1*TextStyleValue1+TextStyleValue2*2+TextStyleValue3*3+TextStyleValue4*4-1;




                                              },),
                                            )
                                        )
                                    ),
                                    Text(Values.length.toString(),style: TextStyle(color: Colors.white),),
                                  ],
                                ),
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: (){
                                      },
                                      child: Opacity(
                                        opacity: 1,
                                        child: AnimatedContainer(
                                          padding: boolTest2 ? EdgeInsets.only(bottom: 24) : EdgeInsets.only(bottom: 0),
                                          duration: animationDuration,
                                          child: IconButton(icon: SvgPicture.asset("lib/images/statup.svg", color: TextStyleValue2==1 ? Colors.green : Colors.white),onPressed: (){
                                            setState(() {
                                              TextStyleValue1=0;
                                              TextStyleValue2=1;
                                              TextStyleValue3=0;
                                              TextStyleValue4=0;
                                            });
                                            TypeOfDataIndex=1*TextStyleValue1+TextStyleValue2*2+TextStyleValue3*3+TextStyleValue4*4-1;
                                          },),
                                        ),
                                      ),
                                    ),
                                    Text(Values1.length.toString(),style: TextStyle(color: Colors.green),),
                                  ],
                                ),
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: (){
                                      },
                                      child: Opacity(
                                        opacity: 1,
                                        child: AnimatedContainer(
                                          padding: boolTest3 ? EdgeInsets.only(bottom: 24) : EdgeInsets.only(bottom: 0),
                                          duration: animationDuration,
                                          child: IconButton(icon: SvgPicture.asset("lib/images/statdown.svg", color: TextStyleValue3==1 ? Colors.red : Colors.white),onPressed: (){
                                            setState(() {
                                              TextStyleValue1=0;
                                              TextStyleValue2=0;
                                              TextStyleValue3=1;
                                              TextStyleValue4=0;
                                            });
                                            TypeOfDataIndex=1*TextStyleValue1+TextStyleValue2*2+TextStyleValue3*3+TextStyleValue4*4-1;
                                          },),
                                        ),
                                      ),
                                    ),
                                    Text(Values2.length.toString(),style: TextStyle(color: Colors.white),),
                                  ],
                                ),
                                Row(
                                  children: [
                                    InkWell(
                                        onTap: (){
                                        },
                                        child: Opacity(
                                          opacity: 1,
                                          child: AnimatedContainer(
                                            padding: boolTest4 ? EdgeInsets.only(bottom: 24) : EdgeInsets.only(bottom: 0),
                                            duration: animationDuration,
                                            child: IconButton(icon: SvgPicture.asset("lib/images/binance.svg", color: TextStyleValue4==1 ? Colors.yellow : Colors.white),onPressed: (){
                                              setState(() {
                                                TextStyleValue1=0;
                                                TextStyleValue2=0;
                                                TextStyleValue3=0;
                                                TextStyleValue4=1;
                                              });
                                              TypeOfDataIndex=1*TextStyleValue1+TextStyleValue2*2+TextStyleValue3*3+TextStyleValue4*4-1;
                                            },),
                                          ),
                                        )
                                    ),
                                    FutureBuilder(
                                      future: model.getCashNew(),
                                      builder: (context,snapshot){

                                        if(snapshot.data!.isNotEmpty){
                                          return Text(snapshot.data![11].length.toString(),style: TextStyle(
                                              color: Colors.white
                                          ));
                                        } else {
                                          return Text("0",style: TextStyle(
                                              color: Colors.white
                                          ));
                                        }

                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ]
                else if (TypeOfDataIndex==2) ...[
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height-314,
                    child: Stack(
                      children: [
                        ListView.builder(
                            padding: EdgeInsets.only(bottom: 60,top: 24),
                            itemCount: Values2.length,
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemBuilder: (context,index) {

                              if(Values2.isNotEmpty){

                                var ValuesSort=[...Values2];
                                ValuesSort.sort((a,b) {
                                  List<bool> SortBools=[
                                    (double.parse(a['percant'])>double.parse(b['percant'])),
                                    (double.parse(a['percant'])<double.parse(b['percant']))
                                  ];
                                  if(SortBools[SortValue]){
                                    return 1;
                                  } else if (double.parse(a['percant'])==double.parse(b['percant'])){
                                    return 0;
                                  } else {
                                    return -1;
                                  }
                                });
                                // ValuesSort.removeWhere((element) => (((element['saveDate'] as DateTime).difference(DateTime.now())).inSeconds==0));

                                if((ValuesSort[index] as Map).containsKey('graphData')){
                                  return InkWell(
                                    onDoubleTap: () async{
                                      print("Double Tap "+ValuesSort[index]["coin"].toString());
                                      var price="";
                                      price=(Values2.firstWhere((element) => element["coin"]==ValuesSort[index]["coin"].toString()))['price'];
                                      print("Price: $price");

                                      final uri = Uri.parse('https://api.binance.com/api/v3/ticker?symbol='+ValuesSort[index]["coin"].toString()+'&windowSize='+timeIntervalsHttp[3]);
                                      final res = await http.get(uri);
                                      print("Decode "+jsonDecode(res.body)['lastPrice'].toString());
                                      setState(() {
                                        (Values2.firstWhere((element) => element["coin"]==ValuesSort[index]["coin"].toString()))['price']=jsonDecode(res.body)['lastPrice'].toString();
                                      });
                                    },
                                    child: CryptoCard(name: ValuesSort[index]["coin"],price: ValuesSort[index]["price"],priceChange: ValuesSort[index]["percant"],period: ValuesSort[index]["date"],graphdata: ValuesSort[index]["graphData"],newcard: ValuesSort[index]["newcard"], saveDates: ValuesSort[index]["saveDate"],BullishIndex: ValuesSort[index]["BullishIndex"],)
                                  );
                                } else return SizedBox(height: 0,);
                              } else {
                                return Text("Empty");
                              }
                            }
                        ),
                        Positioned(
                          bottom: 0,
                          child: Container(
                            color: Colors.black,
                            height: 60,
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.only(left: 24,right: 24),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  children: [
                                    InkWell(
                                        onTap: (){ },
                                        child: Opacity(
                                            opacity: 1,
                                            child: AnimatedContainer(
                                              padding: boolTest ? EdgeInsets.only(bottom: 24) : EdgeInsets.only(bottom: 0),
                                              duration: animationDuration,
                                              child: IconButton(icon: boolTest ? SvgPicture.asset("lib/images/rocket.svg", color: TextStyleValue1==1 ? Colors.lightGreenAccent : Colors.white) : SvgPicture.asset("lib/images/rocket.svg", color: TextStyleValue1==1 ? Colors.green : Colors.white),onPressed: (){

                                                setState(() {
                                                  TextStyleValue1=1;
                                                  TextStyleValue2=0;
                                                  TextStyleValue3=0;
                                                  TextStyleValue4=0;
                                                });

                                                TypeOfDataIndex=1*TextStyleValue1+TextStyleValue2*2+TextStyleValue3*3+TextStyleValue4*4-1;




                                              },),
                                            )
                                        )
                                    ),
                                    Text(Values.length.toString(),style: TextStyle(color: Colors.white),),
                                  ],
                                ),
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: (){
                                      },
                                      child: Opacity(
                                        opacity: 1,
                                        child: AnimatedContainer(
                                          padding: boolTest2 ? EdgeInsets.only(bottom: 24) : EdgeInsets.only(bottom: 0),
                                          duration: animationDuration,
                                          child: IconButton(icon: SvgPicture.asset("lib/images/statup.svg", color: TextStyleValue2==1 ? Colors.green : Colors.white),onPressed: (){
                                            setState(() {
                                              TextStyleValue1=0;
                                              TextStyleValue2=1;
                                              TextStyleValue3=0;
                                              TextStyleValue4=0;
                                            });
                                            TypeOfDataIndex=1*TextStyleValue1+TextStyleValue2*2+TextStyleValue3*3+TextStyleValue4*4-1;
                                          },),
                                        ),
                                      ),
                                    ),
                                    Text(Values1.length.toString(),style: TextStyle(color: Colors.white),),
                                  ],
                                ),
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: (){
                                      },
                                      child: Opacity(
                                        opacity: 1,
                                        child: AnimatedContainer(
                                          padding: boolTest3 ? EdgeInsets.only(bottom: 24) : EdgeInsets.only(bottom: 0),
                                          duration: animationDuration,
                                          child: IconButton(icon: SvgPicture.asset("lib/images/statdown.svg", color: TextStyleValue3==1 ? Colors.red : Colors.white),onPressed: (){
                                            setState(() {
                                              TextStyleValue1=0;
                                              TextStyleValue2=0;
                                              TextStyleValue3=1;
                                              TextStyleValue4=0;
                                            });
                                            TypeOfDataIndex=1*TextStyleValue1+TextStyleValue2*2+TextStyleValue3*3+TextStyleValue4*4-1;
                                          },),
                                        ),
                                      ),
                                    ),
                                    Text(Values2.length.toString(),style: TextStyle(color: Colors.red),),
                                  ],
                                ),
                                Row(
                                  children: [
                                    InkWell(
                                        onTap: (){
                                        },
                                        child: Opacity(
                                          opacity: 1,
                                          child: AnimatedContainer(
                                            padding: boolTest4 ? EdgeInsets.only(bottom: 24) : EdgeInsets.only(bottom: 0),
                                            duration: animationDuration,
                                            child: IconButton(icon: SvgPicture.asset("lib/images/binance.svg", color: TextStyleValue4==1 ? Colors.yellow : Colors.white),onPressed: (){
                                              setState(() {
                                                TextStyleValue1=0;
                                                TextStyleValue2=0;
                                                TextStyleValue3=0;
                                                TextStyleValue4=1;
                                              });
                                              TypeOfDataIndex=1*TextStyleValue1+TextStyleValue2*2+TextStyleValue3*3+TextStyleValue4*4-1;
                                            },),
                                          ),
                                        )
                                    ),
                                    FutureBuilder(
                                      future: model.getCashNew(),
                                      builder: (context,snapshot){

                                        if(snapshot.data!=null){
                                          return Text(snapshot.data![11].length.toString(),style: TextStyle(
                                              color: Colors.white
                                          ));
                                        } else {
                                          return Text("0",style: TextStyle(
                                              color: Colors.white
                                          ));
                                        }

                                      },
                                    ),
                                  ],
                                ),
                              ],

                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ]
                else if (TypeOfDataIndex==3) ...[
                      Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height-314,
                        child: Stack(
                          children: [
                            FutureBuilder(
                                future: model.getCashNew(),
                                // key: GlobalKey(),
                                builder: (context,snapshot){
                                  print("SnapShow "+snapshot.data.toString()+" Type "+snapshot.data.runtimeType.toString());
                                  switch(snapshot.connectionState) {
                                    case ConnectionState.none:
                                      return Center(
                                        child: Container(
                                          height: 364,
                                          margin: EdgeInsets.only(top: 48),
                                          child: CupertinoActivityIndicator(radius: 20.0, animating: true),
                                        ),
                                      );
                                    default:
                                      if (snapshot.hasError) {
                                        return Center(
                                          child: Container(
                                            height: 364,
                                            margin: EdgeInsets.only(top: 48),
                                            child: CupertinoActivityIndicator(radius: 20.0, animating: true),
                                          ),
                                        );
                                      }
                                      if (snapshot.data==[]||snapshot.data==null) {

                                        return Center(
                                          child: Container(
                                            height: 364,
                                            margin: EdgeInsets.only(top: 48),
                                            child: CupertinoActivityIndicator(radius: 20.0, animating: true),
                                          ),
                                        );
                                      }
                                      else {
                                        print("SnapShow2 "+snapshot.data.toString()+" Type "+snapshot.data.runtimeType.toString()+" SnapShowData lenght "+snapshot.data![11].length.toString());
                                        return Container(
                                          height: 412-53,
                                          width: double.infinity,
                                          child: ListView.builder(
                                              itemCount: snapshot.data==[] ? 1 : snapshot.data![11].length,
                                              shrinkWrap: true,
                                              padding: EdgeInsets.only(right: 0,left: 0,bottom: 0,top: 16),
                                              key: UniqueKey(),
                                              physics: ClampingScrollPhysics(),
                                              itemBuilder: (context, index) {


                                                print("SnapShow3 "+snapshot.data.toString()+" Type "+snapshot.data.runtimeType.toString()+" SnapShowData lenght "+snapshot.data!.length.toString());

                                                return CryptoCard(name: snapshot.data![11][index]["coin"],price: snapshot.data![11][index]["price"],priceChange: snapshot.data![11][index]["percant"],period: snapshot.data![11][index]["date"],graphdata: snapshot.data![11][index]["graphData"],newcard: 0, saveDates: snapshot.data![11][index]["saveDate"], BullishIndex: 0,);


                                              }
                                          ),
                                        );
                                      }
                                  }
                                }
                            ),
                            Positioned(
                              bottom: 0,
                              child: Container(
                                color: Colors.black,
                                height: 60,
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.only(left: 24,right: 24),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Row(
                                      children: [
                                        InkWell(
                                            onTap: (){ },
                                            child: Opacity(
                                                opacity: 1,
                                                child: AnimatedContainer(
                                                  padding: boolTest ? EdgeInsets.only(bottom: 24) : EdgeInsets.only(bottom: 0),
                                                  duration: animationDuration,
                                                  child: IconButton(icon: boolTest ? SvgPicture.asset("lib/images/rocket.svg", color: TextStyleValue1==1 ? Colors.lightGreenAccent : Colors.white) : SvgPicture.asset("lib/images/rocket.svg", color: TextStyleValue1==1 ? Colors.green : Colors.white),onPressed: (){

                                                    setState(() {
                                                      TextStyleValue1=1;
                                                      TextStyleValue2=0;
                                                      TextStyleValue3=0;
                                                      TextStyleValue4=0;
                                                    });

                                                    TypeOfDataIndex=1*TextStyleValue1+TextStyleValue2*2+TextStyleValue3*3+TextStyleValue4*4-1;




                                                  },),
                                                )
                                            )
                                        ),
                                        Text(Values.length.toString(),style: TextStyle(color: Colors.white),),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: (){
                                          },
                                          child: Opacity(
                                            opacity: 1,
                                            child: AnimatedContainer(
                                              padding: boolTest2 ? EdgeInsets.only(bottom: 24) : EdgeInsets.only(bottom: 0),
                                              duration: animationDuration,
                                              child: IconButton(icon: SvgPicture.asset("lib/images/statup.svg", color: TextStyleValue2==1 ? Colors.green : Colors.white),onPressed: (){
                                                setState(() {
                                                  TextStyleValue1=0;
                                                  TextStyleValue2=1;
                                                  TextStyleValue3=0;
                                                  TextStyleValue4=0;
                                                });
                                                TypeOfDataIndex=1*TextStyleValue1+TextStyleValue2*2+TextStyleValue3*3+TextStyleValue4*4-1;
                                              },),
                                            ),
                                          ),
                                        ),
                                        Text(Values1.length.toString(),style: TextStyle(color: Colors.white),),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: (){
                                          },
                                          child: Opacity(
                                            opacity: 1,
                                            child: AnimatedContainer(
                                              padding: boolTest3 ? EdgeInsets.only(bottom: 24) : EdgeInsets.only(bottom: 0),
                                              duration: animationDuration,
                                              child: IconButton(icon: SvgPicture.asset("lib/images/statdown.svg", color: TextStyleValue3==1 ? Colors.red : Colors.white),onPressed: (){
                                                setState(() {
                                                  TextStyleValue1=0;
                                                  TextStyleValue2=0;
                                                  TextStyleValue3=1;
                                                  TextStyleValue4=0;
                                                });
                                                TypeOfDataIndex=1*TextStyleValue1+TextStyleValue2*2+TextStyleValue3*3+TextStyleValue4*4-1;
                                              },),
                                            ),
                                          ),
                                        ),
                                        Text(Values2.length.toString(),style: TextStyle(color: Colors.white),),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        InkWell(
                                            onTap: (){
                                            },
                                            child: Opacity(
                                              opacity: 1,
                                              child: AnimatedContainer(
                                                padding: boolTest4 ? EdgeInsets.only(bottom: 24) : EdgeInsets.only(bottom: 0),
                                                duration: animationDuration,
                                                child: IconButton(icon: SvgPicture.asset("lib/images/binance.svg", color: TextStyleValue4==1 ? Colors.yellow : Colors.white),onPressed: (){
                                                  setState(() {
                                                    TextStyleValue1=0;
                                                    TextStyleValue2=0;
                                                    TextStyleValue3=0;
                                                    TextStyleValue4=1;
                                                  });
                                                  TypeOfDataIndex=1*TextStyleValue1+TextStyleValue2*2+TextStyleValue3*3+TextStyleValue4*4-1;
                                                },),
                                              ),
                                            )
                                        ),
                                        FutureBuilder(
                                          future: model.getCashNew(),
                                          builder: (context,snapshot){

                                            if(snapshot.data==null){
                                              return Text("0",style: TextStyle(
                                                  color: Colors.yellow
                                              ));
                                            }

                                            if(snapshot.data!.isNotEmpty&&snapshot.data!=null){
                                              return Text(snapshot.data![11].length.toString(),style: TextStyle(
                                                  color: Colors.yellow
                                              ));
                                            } else {
                                              return Text("0",style: TextStyle(
                                                  color: Colors.yellow
                                              ));
                                            }

                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ]
              ],
            )
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async{
      //     // await service.showNotification(id: 1, title: "title", body: "body");
      //     Values.clear();
      //     setState(() {
      //
      //     });
      //     print("Not");
      //   },
      //   child: Icon(Icons.refresh),
      // ),
    );
  }


  @override
  void dispose() {

    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if(state == AppLifecycleState.inactive || state == AppLifecycleState.detached) return;

    state == AppLifecycleState.paused;
    final isBackground = state == AppLifecycleState.paused;

    if(isBackground) {

      FlutterBackground.enableBackgroundExecution();
      bool enabled = FlutterBackground.isBackgroundExecutionEnabled;
      Future.delayed(Duration(seconds: 2));
      print("BackGround "+enabled.toString());

    } else {

      bool enabled = FlutterBackground.isBackgroundExecutionEnabled;
      print("test "+enabled.toString());
      FlutterBackground.disableBackgroundExecution();
      print("No BackGround");
    }
  }

}

class CryptoCard extends StatefulWidget {
  final name;
  final price;
  final priceChange;
  final period;
  final graphdata;
  final newcard;
  final saveDates;
  final BullishIndex;

  CryptoCard({Key? key,required this.name,required this.price,required this.priceChange,required this.period,required this.graphdata,required this.newcard,required this.saveDates,required this.BullishIndex}) : super(key: key);

  @override
  State<CryptoCard> createState() => _CryptoCardState();
}
class _CryptoCardState extends State<CryptoCard> {


  var timeIntervals=[
    "1 мин.",
    "3 мин.",
    "5 мин.",
    "15 мин.",
    "30 мин.",
    "1 час",
    "1 день",
    "—",
  ];

  @override
  void initState() {

    print("Widhet graph data "+widget.graphdata.toString() );
    // TODO: implement initState
    super.initState();
  }



  @override
  Widget build(BuildContext context) {

    Color graphColor=Colors.red;
    List<bool> changer=[
      (double.parse(widget.priceChange)>1.5),
      (double.parse(widget.priceChange)>1.5),
      (double.parse(widget.priceChange)<(-0.5))
    ];

    // Сортировка
    var text_style=TextStyle(color: Colors.white);
    // if(changer[widget.typeOf]){
    //
    // } else {
    //
    //   return SizedBox(height: 0,width: 0,);
    // }
    //
    if(double.parse(widget.priceChange)>0){
      text_style=TextStyle(color: Colors.green);
    } else {
      text_style=TextStyle(color: Colors.red);
    }


    // Цвета графиков
    if(double.parse(widget.priceChange)>0){
      graphColor=Colors.green;
    } else if(widget.priceChange=="+0.0") {
      graphColor=Colors.grey;
    }else if(double.parse(widget.priceChange)<0) {
      graphColor=Colors.red;
    }

    // if(((widget.saveDates as DateTime).difference(DateTime.now())).inSeconds<=0) {
    //   return SizedBox(height: 0,width: 0,);
    // }






    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => Details(coin: widget.name,date: widget.period,)));
      },
      child: Container(
        width: double.infinity,
        height: 72,
        margin: EdgeInsets.only(bottom: 16,right: 24,left: 24),
        decoration: BoxDecoration(
          color: Color.fromRGBO(33, 37, 49, 1.0),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blueAccent.withOpacity((widget.newcard as int).toDouble()*0.3))
        ),
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 120,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.name,style: TextStyle(color: Colors.white)),
                  SizedBox(height: 4),
                  if(widget.price.toString()!="null") ...[
                    if(widget.price.toString().length>12)...[
                      Text(widget.price.toString().substring(0,12),style: TextStyle(color: Colors.white))
                    ] else ...[
                      Text(widget.price.toString(),style: TextStyle(color: Colors.white))
                    ]
                    
                  ] else ...[
                    Text("Пусто",style: TextStyle(color: Colors.white))
                  ]
                ],
              ),
            ),
            SizedBox(width: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(((widget.saveDates as DateTime).difference(DateTime.now())).inMinutes==0) ...[
                  Text(((widget.saveDates as DateTime).difference(DateTime.now())).inSeconds.toString()+" с.",style: TextStyle(color: Colors.white)),
                ] else if(((widget.saveDates as DateTime).difference(DateTime.now())).inMinutes<=60) ...[
                  Text(((widget.saveDates as DateTime).difference(DateTime.now())).inMinutes.toString()+" м.",style: TextStyle(color: Colors.white)),
                ] else ...[
                  Text(((widget.saveDates as DateTime).difference(DateTime.now())).inHours.toString()+" ч.",style: TextStyle(color: Colors.white)),
                ],
                SizedBox(height: 4),
                if(widget.priceChange.toString().substring(0,1)=="-") ...[
                  if(widget.priceChange.toString().length>6) ...[
                    Text(widget.priceChange.toString().substring(0,5)+"%",style: text_style)
                  ] else ...[
                    Text(widget.priceChange.toString()+"%",style: text_style)
                  ]
                ] else ...[
                  if(widget.priceChange.toString().length>6) ...[
                    Text("+"+widget.priceChange.toString().substring(0,4)+"%",style: text_style)
                  ] else ...[
                    Text("+"+widget.priceChange.toString()+"%",style: text_style)
                  ]
                ],
              ],
            ),
            SizedBox(width: 24),
            if((widget.graphdata as List<ChartData>)!.isEmpty) ...[
              Container(
                height: 40,
                width: 90,
                padding: EdgeInsets.only(left: 16),
                child: CupertinoActivityIndicator(radius: 16.0, animating: true),
              )
            ] else ...[
              Container(
                height: 40,
                width: 80,
                child: SfCartesianChart(
                  borderColor: Colors.transparent,
                  borderWidth: 0,
                  plotAreaBorderWidth: 0,
                  series: <ChartSeries>[
                    // Renders spline chart
                    SplineAreaSeries<ChartData, int>(
                      dataSource: widget.graphdata,
                      xValueMapper: (ChartData data, _) => data.x,
                      yValueMapper: (ChartData data, _) => data.y,
                      gradient: LinearGradient(
                          colors: [graphColor,graphColor.withAlpha(100),graphColor.withAlpha(0)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter
                      ),
                    )
                  ],
                  primaryYAxis: NumericAxis(
                    // minimum: 18348,
                    // maximum: 18390,
                      isVisible: false
                  ),
                  primaryXAxis: NumericAxis(
                      isVisible: false
                  ),
                ),
              )

            ]
          ],
        ),
      ),
    );
  }

}


class PopupDialog extends StatefulWidget {
  final percents;
  final dates;
  const PopupDialog({Key? key,required this.percents, required this.dates}) : super(key: key);

  @override
  State<PopupDialog> createState() => _PopupDialogState();
}
class _PopupDialogState extends State<PopupDialog> {

  var timeIntervals=["1 мин.", "3 мин.", "5 мин.", "15 мин.", "30 мин.", "1 час","1 день"];
  var PumpsIntervals=["1 мин.", "3 мин.", "5 мин.", "15 мин.", "30 мин.", "1 час","1 день"];
  var Bulish1Intervals=["1 мин.", "3 мин.", "5 мин.", "15 мин.", "30 мин.", "1 час","1 день"];
  var Bulish2Intervals=["1 мин.", "3 мин.", "5 мин.", "15 мин.", "30 мин.", "1 час","1 день"];
  var BearishIntervals=["1 мин.", "3 мин.", "5 мин.", "15 мин.", "30 мин.", "1 час","1 день"];

  var timeIntervalsIndex=3;
  var PumpsIntervalsIndex=1;
  var Bulish1IntervalsIndex=2;
  var Bulish2IntervalsIndex=2;
  var BearishIntervalsIndex=3;


  double name=1.5;
  double name2=1.5;
  double name3=1.5;
  double name4=1.5;
  TextEditingController controller=TextEditingController();
  TextEditingController controller2=TextEditingController();
  TextEditingController controller3=TextEditingController();
  TextEditingController controller4=TextEditingController();

  var popupdata=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    name=widget.percents[0];
    name2=widget.percents[1];
    name3=widget.percents[2];
    name4=widget.percents[3];

    PumpsIntervalsIndex=widget.dates[0];
    Bulish1IntervalsIndex=widget.dates[1];
    Bulish2IntervalsIndex=widget.dates[2];
    BearishIntervalsIndex=widget.dates[3];

  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color.fromRGBO(33, 37, 49, 1.0),
      insetPadding: EdgeInsets.all(0),
      content: Container(
        height: 360,
        width: 300,
        color: Color.fromRGBO(33, 37, 49, 1.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Preferences",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 24)),
                  InkWell(
                    onTap: (){
                      popupdata.add(name);
                      popupdata.add(name2);
                      popupdata.add(name3);
                      popupdata.add(name4);
                      popupdata.add(PumpsIntervalsIndex);
                      popupdata.add(Bulish1IntervalsIndex);
                      popupdata.add(Bulish2IntervalsIndex);
                      popupdata.add(BearishIntervalsIndex);
                      Navigator.pop(context, popupdata);
                    },
                    child: Container(
                      width: 42,
                      height: 42,
                      child: Icon(Icons.refresh),
                    )
                  )
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              child: Column(
                children: [
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 70,
                        child: Text("Pump",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700)),
                      ),
                      // Text("1,5%",style: TextStyle(color: Colors.green)),
                      Container(
                        width: 150,
                        height: 42,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: (){
                                setState(() {
                                  name=((name * 100).toInt() - (0.1 * 100)).toInt() / 100;
                                });
                              },
                              icon: Icon(CupertinoIcons.minus_circle,color: Colors.white),
                            ),
                            Text(name.toStringAsFixed(1)+"%"),
                            IconButton(
                              onPressed: (){
                                setState(() {
                                  name=((name * 100).toInt() + (0.1 * 100)).toInt() / 100;
                                });
                              },
                              icon: Icon(CupertinoIcons.plus_circled,color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: (){

                          // print("Tapped");
                          if(PumpsIntervalsIndex!=6){
                            setState(() {
                              PumpsIntervalsIndex=PumpsIntervalsIndex+1;
                            });
                          } else {
                            setState(() {
                              PumpsIntervalsIndex=0;
                            });
                          }
                        },
                        child: Container(
                          alignment: AlignmentDirectional.centerEnd,
                          width: 70,
                          child: Text(PumpsIntervals[PumpsIntervalsIndex],style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                  Divider(color: Colors.white38,height: 36),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 70,
                        child: Text("Bullish",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700))
                      ),
                      Container(
                        width: 150,
                        height: 42,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: (){
                                setState(() {
                                  name2=((name2 * 100).toInt() - (0.1 * 100)).toInt() / 100;
                                  // name2=name2-0.1;
                                });
                              },
                              icon: Icon(CupertinoIcons.minus_circle,color: Colors.white),
                            ),
                            Text(name2.toStringAsFixed(1)+"%"),
                            IconButton(
                              onPressed: (){
                                setState(() {
                                  name2=((name2 * 100).toInt() + (0.1 * 100)).toInt() / 100;
                                });
                              },
                              icon: Icon(CupertinoIcons.plus_circled,color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          // print("Tapped");
                          if(Bulish1IntervalsIndex!=6){
                            setState(() {
                              Bulish1IntervalsIndex=Bulish1IntervalsIndex+1;
                            });
                          } else {
                            setState(() {
                              Bulish1IntervalsIndex=0;
                            });
                          }
                        },
                        child: Container(
                          alignment: AlignmentDirectional.centerEnd,
                          width: 70,
                          child: Text(Bulish1Intervals[Bulish1IntervalsIndex],style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                  Divider(color: Colors.white38,height: 36),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 70,
                        child: Text("Bullish 2",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700))
                      ),
                      Container(
                        width: 150,
                        height: 42,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: (){
                                setState(() {
                                  name3=((name3 * 100).toInt() - (0.1 * 100)).toInt() / 100;
                                });
                              },
                              icon: Icon(CupertinoIcons.minus_circle,color: Colors.white),
                            ),
                            Text(name3.toStringAsFixed(1)+"%"),
                            IconButton(
                              onPressed: (){
                                setState(() {
                                  name3=((name3 * 100).toInt() + (0.1 * 100)).toInt() / 100;
                                });
                              },
                              icon: Icon(CupertinoIcons.plus_circled,color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          // print("Tapped");
                          if(Bulish2IntervalsIndex!=6){
                            setState(() {
                              Bulish2IntervalsIndex=Bulish2IntervalsIndex+1;
                            });
                          } else {
                            setState(() {
                              Bulish2IntervalsIndex=0;
                            });
                          }
                        },
                        child: Container(
                          alignment: AlignmentDirectional.centerEnd,
                          width: 70,
                          child: Text(Bulish2Intervals[Bulish2IntervalsIndex],style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                  Divider(color: Colors.white38,height: 36),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          width: 70,
                          child: Text("Bearish",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700))
                      ),
                      Container(
                        width: 150,
                        height: 42,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: (){
                                setState(() {
                                  name4=((name4 * 100).toInt() - (0.1 * 100)).toInt() / 100;
                                });
                              },
                              icon: Icon(CupertinoIcons.minus_circle,color: Colors.white),
                            ),
                            Text(name4.toStringAsFixed(1)+"%"),
                            IconButton(
                              onPressed: (){
                                setState(() {
                                  name4=((name4 * 100).toInt() + (0.1 * 100)).toInt() / 100;
                                });
                              },
                              icon: Icon(CupertinoIcons.plus_circled,color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          // print("Tapped");
                          if(BearishIntervalsIndex!=6){
                            setState(() {
                              BearishIntervalsIndex=BearishIntervalsIndex+1;
                            });
                          } else {
                            setState(() {
                              BearishIntervalsIndex=0;
                            });
                          }
                        },
                        child: Container(
                          alignment: AlignmentDirectional.centerEnd,
                          width: 70,
                          child: Text(BearishIntervals[BearishIntervalsIndex],style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                  // Divider(color: Colors.white38,height: 36),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Container(
                  //       width: 70,
                  //       child: Text("Listing",style: TextStyle(color: Colors.white))
                  //     ),
                  //     Text("2 недели",style: TextStyle(color: Colors.white)),
                  //   ],
                  // ),
                ],
              ),
            )
          ],
        ),
      )
    );
  }
}


class ChartData {

  final int x;
  final double? y;

  ChartData(this.x, this.y);

}




