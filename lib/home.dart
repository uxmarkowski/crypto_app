import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Interval;
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'details.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:crypto_app/hive_metod.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:workmanager/workmanager.dart';
import 'local_notification_servise.dart';
import 'socket.dart';
import 'home_plus.dart';



class ChartData {

  final int x;
  final double? y;
  ChartData(this.x, this.y);

}

class HomePageFor extends StatefulWidget {
  HomePageFor({Key? key}) : super(key: key);

  @override
  State<HomePageFor> createState() => _HomePageForState();
}

class _HomePageForState extends State<HomePageFor> with WidgetsBindingObserver {


  var lastClosePrice = "0.000000000";
  var lastClosePrice2 = "0.00000000";
  var BTCpercent="0.00";

  String tradablePairs = "";
  String lastEventData = "";
  var dollars='\$';

  // Настройки вывода
  dynamic PumpPercant=1.5;
  dynamic BulishPercant1=1.5;
  dynamic BulishPercant2=1.5;
  dynamic BearishPercant2=1.5;
  dynamic FinalPercent=[1.5,1.5,1.5,1.5];
  dynamic FinalDate=[3,4,5,4];
  var BackgroundIndex=[0,0,0,0];

  var PumpTime="15 мин.";
  var PumptimeIntervalsIndex=3;
  var dataLenght=0;
  var ListPercentInterval=0;
  var changerVarIndex=0;
  var graphButtonIndex=0;
  var graphButtonIndex2=0;
  var ListingLoadingIndex=0; // Для загрузочной полосы в листинге
  var ShowColDate=0;
  var CurrentGraphIndex=0; // Чтобы загрузка соответствовала циклу Pump или Bulls6 Brlsh
  

  var StopFunctionIndex=0;
  var refreshCheck=false;
  var listingCheck=false;

  List ListPercent=[
    1.5,
    5.01,
    10.01,
  ];
  var timeIntervals=[
    "1 мин.",
    "3 мин.",
    "5 мин.",
    "15 мин.",
    "30 мин.",
    "1 час",
    "1 день",
  ];
  var timeIntervalsHttp=[
    "1m",
    "3m",
    "5m",
    "15m",
    "30m",
    "1h",
    "1d",
  ];

  var durationsList=[
    Duration(minutes: 1),
    Duration(minutes: 3),
    Duration(minutes: 5),
    Duration(minutes: 15),
    Duration(minutes: 30),
    Duration(hours: 1),
    Duration(days: 1),
  ];

  var model = hive_example();

  void notify() {
    print("Show Not");
    service.showNotification(id: 3, title: "title", body: "body");
  }



  late final LocalNotificationService service;
  @override
  void initState() {


    print("Open ");
    service = LocalNotificationService();
    service.intialize();


    Timer.periodic(Duration(minutes: 1), (timer) {
      print("Shiiishh :p");
      ListingFunc(changerVarIndex,FinalPercent,FinalDate,TypeOfDataIndex);
    });

    Future.delayed(Duration(milliseconds: 500)).then((value) {
      setState(() {

      });
    });

    super.initState();
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
      Workmanager().registerPeriodicTask("uniqueName", "taskName");
      print("BackGround");
    } else {
      Workmanager().cancelAll();
      setState(() {
        BackgroundIndex=[0,0,0,0];
      });
    }
  }

  void ListingFunc(changerVar,percents,dates,typeOfData) async {

    print("1 — Получение запроса");
    List decode=[]; // Начало листинга
    try { // http запросы
      final res = await http.get(Uri.parse("https://api.binance.com/api/v3/ticker/24hr"));
      (jsonDecode(res.body) as List).forEach((element) {decode.add(element);});
    } catch (e) {print("Ошибка тикера 1"+e.toString());} //Парсинг новых значений


    print("2 — Данные из памяти");
    var modelx = await model.getDataListing() as List; //Данные из памяти
    print("modelx length "+modelx.length.toString());

    print("3 — Сохранение декода");
    print("decode "+decode.length.toString());
    var decode22=[]; decode.forEach((element) {decode22.add(element);});
    model.saveDataListing(decode22,DateTime.now()); // Сохранение значений
    await Future.delayed(Duration(seconds: 3));

    print("4 — Показ длины старых и новых значений");
    print("modelx.length[last] "+modelx[modelx.length-2].length.toString());
    print("decode.length[last] "+decode.length.toString());

    print("modelx.length "+modelx[modelx.length-2].length.toString());
    print("decode.length2 "+decode.length.toString());
    var data=[]; // Переменная для обьектов

    print("5 — Получение новых монет и подготовка к выводу");

    var decode2=[];
    decode.forEach((DecodeElement) {

      var indexs=0;

      (modelx[modelx.length-2] as List).forEach((OldElement) {
        if(OldElement['symbol']==DecodeElement['symbol']){
          if((OldElement['lastPrice']=='0.00000000')&&(DecodeElement['lastPrice']!='0.00000000')){
            print("OldElement['lastPrice']"+OldElement['lastPrice'].toString());
            print("DecodeElement['lastPrice']"+DecodeElement['lastPrice'].toString());
            indexs=1;
          }
        }
      });

      if(indexs==1){
        decode2.add(DecodeElement);
      }
    });

    print("Новые монеты DC "+decode2.length.toString());
    data=decode2;


    print("Колиество новых монет "+data.length.toString()); // Подготовка
    var coinsCorrect=[]; var pricesCorrect=[]; var priceChange=[]; var decodePrevOpenPrice=[]; var emptyGraph=[]; var CurrentDate=DateTime.now();

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

    print("7 — Превращение в обьекты");
    List coinMapList=[]; // Превращение в обьекты
    for(int i=0;i<coinsCorrect.length;i++){
      Map coinMap=Map();
      coinMap["coin"]=coinsCorrect[i];
      coinMap["price"]=pricesCorrect[i];
      coinMap["date"]=3;
      coinMap["percant"]=priceChange[i];
      coinMap["saveDate"]=DateTime.now().add(durationsList[saveInFutureIndexListing]);
      coinMap["graphData"]=[111.111,111.111,111.111];
      coinMapList.add(coinMap);
      print("coin "+coinMapList[i].toString());
    } // Превращение в обьекты


    print("8 — Сохранение и получение новых монет");

    var newCash=await model.getCashNew();
    if(newCash.isNotEmpty) {
      (newCash[11] as List).forEach((newElement) {
        var changes=0;
        coinMapList.forEach((element) {
          if(newElement==element) {
            changes=1;
          }
        });
        if(changes==1) {
          coinMapList.add(newElement);
        }
      });
    }
    coinMapList.removeWhere((element) => DateTime.now().compareTo(element["saveDate"] as DateTime)==1);
    coinMapList.forEach((element) {
      print(element["saveDate"]);
    });

    var result=[coinsCorrect, pricesCorrect, priceChange, decodePrevOpenPrice,CurrentDate,percents[0],percents[1],dates[0],dates[1],TypeOfDataIndex,emptyGraph,coinMapList];
    model.saveCashNew(result);

    print("9 — Вывод "+result.toString());
    setState(() {
      ListingLoadingIndex=0;
      listingCheck=false;
    });
    // refreshCheck=false; return result; // Обнуление индексов и выдача результатов
  }



  List TextStyles=[TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w300),TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w600)];
  var TextStyleValue1=1;
  var TextStyleValue2=0;
  var TextStyleValue3=0;
  var TextStyleValue4=0;
  var TypeOfDataIndex=0;

  var TypeOfData=[
    "Pump",
    "Bullish",
    "Bearish"
  ];
  var marginValue=20;

  int typeOfCard=0;
  var needToDelete=0;
  var saveInFutureIndex=3;
  var saveInFutureIndexPump=3;
  var saveInFutureIndexBullish=3;
  var saveInFutureIndexBearlish=3;
  var saveInFutureIndexListing=3;

  // Для времени
  var recoredTime;

  List numbersTest=[1,2,3,4,5];
  List numbersTest2=[];


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
                          onTap: () {

                            print("CHV "+changerVarIndex.toString());
                            changerVarIndex=0;
                            // model.deleteCashNew();

                          },
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            if(lastClosePrice.length>4) ...[
                              InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => Details(coin: "BTCUSDT",date: 3)));
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
                                  }
                                },
                                child: Text(BTCpercent.toString()+"%",style: TextStyle(color: Colors.white,fontSize: 16))
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
                                  typeOfCard=0;
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
                                  typeOfCard=2;
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
                      margin: EdgeInsets.only(left: marginValue*(TextStyleValue1+TextStyleValue2*4.5+TextStyleValue3*8.2+TextStyleValue4*12.1)),
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
                          print("Tapped");
                          if(TypeOfDataIndex!=3){
                            if(changerVarIndex==0){
                              setState(() {
                                refreshCheck=true;
                              });
                            }
                          } else {
                            setState(() {
                              ListingLoadingIndex=1;
                              listingCheck=true;
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
                              Icon(CupertinoIcons.bitcoin_circle_fill,color: Colors.white,size: 16,),
                              SizedBox(width: 8,),
                              Text("Обновить",style: TextStyle(fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          if(changerVarIndex==0) {
                            setState(() {
                              graphButtonIndex=1;
                              graphButtonIndex2=1;
                            });
                          }
                        },
                        child: FutureBuilder(
                            future: getDataLength(),
                            initialData: 0,
                            builder: (BuildContext context, AsyncSnapshot<int> digit) {
                              return Container(
                                padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                                margin: EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                    color: Color.fromRGBO(33, 37, 49, 1.0),
                                    borderRadius: BorderRadius.circular(8)
                                ),
                                child: Row(
                                  children: [
                                    Icon(CupertinoIcons.graph_circle_fill,color: Colors.white,size: 16,),
                                    if(digit.data!=0) ...[
                                      SizedBox(width: 8,),
                                      Text(digit.data.toString(),style: TextStyle(fontWeight: FontWeight.w500)),
                                    ]
                                  ],
                                ),
                              );
                            }
                        ),
                      ),
                      if(TypeOfDataIndex==0) ...[
                        InkWell(
                          onTap: (){
                            if(saveInFutureIndexPump!=6){
                              setState(() {
                                saveInFutureIndexPump=saveInFutureIndexPump+1;
                              });
                            } else {
                              setState(() {
                                saveInFutureIndexPump=0;
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
                        InkWell(
                          onTap: (){
                            if(saveInFutureIndexBullish!=6){
                              setState(() {
                                saveInFutureIndexBullish=saveInFutureIndexBullish+1;
                              });
                            } else {
                              setState(() {
                                saveInFutureIndexBullish=0;
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
                        InkWell(
                          onTap: (){
                            if(saveInFutureIndexBearlish!=6){
                              setState(() {
                                saveInFutureIndexBearlish=saveInFutureIndexBearlish+1;
                              });
                            } else {
                              setState(() {
                                saveInFutureIndexBearlish=0;
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
                          onTap: (){
                            if(saveInFutureIndexListing!=6){
                              setState(() {
                                saveInFutureIndexListing=saveInFutureIndexListing+1;
                              });
                            } else {
                              setState(() {
                                saveInFutureIndexListing=0;
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
                                Text(timeIntervals[saveInFutureIndexListing],style: TextStyle(fontWeight: FontWeight.w500)),
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
                              Workmanager().registerPeriodicTask("uniqueName", "taskName",inputData: {"percent1": FinalPercent[0], "percant2": FinalPercent[2], "date1": FinalDate[0], "date2": FinalDate[2], "typeOfDataFunc":TypeOfDataIndex, "saveIndex": [saveInFutureIndexPump,saveInFutureIndexBullish,saveInFutureIndexBearlish],});
                              setState(() {
                                BackgroundIndex=[1,0,0,0];
                              });
                            } else {
                              Workmanager().cancelAll();
                              setState(() {
                                BackgroundIndex=[0,0,0,0];
                              });
                            }

                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                            margin: EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(33, 37, 49, 1.0),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                if(BackgroundIndex[0]==1) ...[
                                  Icon(CupertinoIcons.alarm_fill,color: Colors.white,size: 16),
                                  SizedBox(width: 8,),
                                  Text("В фоне",style: TextStyle(fontWeight: FontWeight.w500,color: Colors.white)),
                                ] else ...[
                                  Icon(CupertinoIcons.alarm,color: Colors.white,size: 16),
                                  SizedBox(width: 8,),
                                  Text("Не в фоне",style: TextStyle(fontWeight: FontWeight.w500,color: Colors.white)),
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
                              Workmanager().registerPeriodicTask("uniqueName", "taskName",inputData: {"percent1": FinalPercent[1], "percant2": FinalPercent[2], "date1": FinalDate[1], "date2": FinalDate[2], "typeOfDataFunc":TypeOfDataIndex, "saveIndex": [saveInFutureIndexPump,saveInFutureIndexBullish,saveInFutureIndexBearlish],});
                              setState(() {
                                BackgroundIndex=[0,1,0,0];
                              });
                            } else {
                              Workmanager().cancelAll();
                              setState(() {
                                BackgroundIndex=[0,0,0,0];
                              });
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                            margin: EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(33, 37, 49, 1.0),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                if(BackgroundIndex[1]==1) ...[
                                  Icon(CupertinoIcons.alarm_fill,color: Colors.white,size: 16),
                                  SizedBox(width: 8,),
                                  Text("В фоне",style: TextStyle(fontWeight: FontWeight.w500,color: Colors.white)),
                                ] else ...[
                                  Icon(CupertinoIcons.alarm,color: Colors.white,size: 16),
                                  SizedBox(width: 8,),
                                  Text("Не в фоне",style: TextStyle(fontWeight: FontWeight.w500,color: Colors.white)),
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
                              Workmanager().registerPeriodicTask("uniqueName", "taskName",inputData: {"percent1": FinalPercent[3], "percant2": FinalPercent[2], "date1": FinalDate[3], "date2": FinalDate[2], "typeOfDataFunc":TypeOfDataIndex, "saveIndex": [saveInFutureIndexPump,saveInFutureIndexBullish,saveInFutureIndexBearlish],});
                              setState(() {
                                BackgroundIndex=[0,0,1,0];
                              });


                            } else {
                              Workmanager().cancelAll();
                              setState(() {
                                BackgroundIndex=[0,0,0,0];
                              });
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                            margin: EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(33, 37, 49, 1.0),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                if(BackgroundIndex[2]==1) ...[
                                  Icon(CupertinoIcons.alarm_fill,color: Colors.white,size: 16),
                                  SizedBox(width: 8,),
                                  Text("В фоне",style: TextStyle(fontWeight: FontWeight.w500,color: Colors.white)),
                                ] else ...[
                                  Icon(CupertinoIcons.alarm,color: Colors.white,size: 16),
                                  SizedBox(width: 8,),
                                  Text("Не в фоне",style: TextStyle(fontWeight: FontWeight.w500,color: Colors.white)),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  )
                ),
                Stack(
                  children: [
                    if(changerVarIndex==1) ...[
                      if(TypeOfDataIndex==1&&CurrentGraphIndex==1) ...[
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: 140),
                          duration: Duration(seconds: 140),
                          builder: (context, value, _) => Container(
                            color: Colors.red,
                            width: MediaQuery.of(context).size.width/140*value,
                            margin: EdgeInsets.only(top: 1),
                            height: 1,
                          ),
                        ),
                      ] else ...[
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: 60),
                          duration: Duration(seconds: 60),
                          builder: (context, value, _) => Container(
                            color: Colors.red,
                            width: MediaQuery.of(context).size.width/60*value,
                            margin: EdgeInsets.only(top: 1),
                            height: 1,
                          ),
                        ),
                      ]
                    ],
                    if(graphButtonIndex2==1) ...[
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: dataLenght.toDouble()),
                        duration: Duration(seconds: dataLenght),
                        builder: (context, value, _) => Container(
                          color: Colors.blue,
                          width: MediaQuery.of(context).size.width/dataLenght*value,
                          margin: EdgeInsets.only(top: 1),
                          height: 1,
                        ),
                      ),
                    ],
                    if(ListingLoadingIndex==1) ...[
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: 10),
                        duration: Duration(seconds: 10),
                        builder: (context, value, _) => Container(
                          color: Colors.red,
                          width: MediaQuery.of(context).size.width/15*value,
                          margin: EdgeInsets.only(top: 1),
                          height: 1,
                        ),
                      ),
                    ],
                    Container(
                      color: Colors.white12,
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 1),
                      height: 1,
                    ),
                  ],
                ),
                Container(
                  height: MediaQuery.of(context).size.height-316,
                  child: Stack(
                    children: [
                      FutureBuilder(
                          future: Changer(changerVarIndex,FinalPercent,FinalDate,TypeOfDataIndex),
                          builder: (context,snapshot){
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
                                if (!snapshot.hasData) {
                                  return Center(
                                    child: Container(
                                      height: 364,
                                      margin: EdgeInsets.only(top: 48),
                                      child: CupertinoActivityIndicator(radius: 20.0, animating: true),
                                    ),
                                  );
                                }
                                else {
                                  return Container(
                                  height: 412-53,
                                  width: double.infinity,
                                    child: ListView.builder(
                                        itemCount: snapshot.data![11].length,
                                        shrinkWrap: true,
                                        padding: EdgeInsets.only(right: 0,left: 0,bottom: 0,top: 16),
                                        key: UniqueKey(),
                                        physics: ClampingScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          if(snapshot.data![2].length==0||snapshot.data==null){
                                            if(index==0){
                                              return Center(
                                                  child: Text("Результатов не найдено :c ")
                                              );
                                            } else {
                                              return SizedBox(height: 0,);
                                            }
                                          }
                                          return CryptoCard(name: snapshot.data![11][index]["coin"],price: snapshot.data![11][index]["price"],priceChange: snapshot.data![11][index]["percant"],period: snapshot.data![11][index]["date"],graphdata: snapshot.data![11][index]["graphData"],newcard: snapshot.data![11][index]["newcard"], saveDates: snapshot.data![11][index]["saveDate"],);
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
                          height: 61,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.only(left: 24,right: 24),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              InkWell(
                                onTap: (){

                                },
                                child: Opacity(
                                    opacity: 0.5+0.5*TextStyleValue1,
                                  child: IconButton(icon: SvgPicture.asset("lib/images/rocket.svg"),onPressed: (){

                                    setState(() {
                                      TextStyleValue1=1;
                                      TextStyleValue2=0;
                                      TextStyleValue3=0;
                                      TextStyleValue4=0;
                                      typeOfCard=0;
                                    });
                                    TypeOfDataIndex=1*TextStyleValue1+TextStyleValue2*2+TextStyleValue3*3+TextStyleValue4*4-1;
                                  },),

                                )
                              ),
                              InkWell(
                                onTap: (){
                                },
                                child: Opacity(
                                  opacity: 0.5+0.5*TextStyleValue2,
                                  child: IconButton(icon: SvgPicture.asset("lib/images/statup.svg"),onPressed: (){
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
                              InkWell(
                                onTap: (){
                                },
                                child: Opacity(
                                  opacity: 0.5+0.5*TextStyleValue3,
                                  child: IconButton(icon: SvgPicture.asset("lib/images/statdown.svg"),onPressed: (){
                                    setState(() {
                                      TextStyleValue1=0;
                                      TextStyleValue2=0;
                                      TextStyleValue3=1;
                                      TextStyleValue4=0;
                                      typeOfCard=2;
                                    });
                                    TypeOfDataIndex=1*TextStyleValue1+TextStyleValue2*2+TextStyleValue3*3+TextStyleValue4*4-1;
                                  },),
                                ),
                              ),
                              InkWell(
                                onTap: (){
                                },
                                child: Opacity(
                                  opacity: 0.5+0.5*TextStyleValue4,
                                  child: IconButton(icon: SvgPicture.asset("lib/images/binance.svg"),onPressed: (){
                                    setState(() {
                                      TextStyleValue1=0;
                                      TextStyleValue2=0;
                                      TextStyleValue3=0;
                                      TextStyleValue4=1;
                                    });
                                    TypeOfDataIndex=1*TextStyleValue1+TextStyleValue2*2+TextStyleValue3*3+TextStyleValue4*4-1;
                                  },),
                                )
                              ),
                            ],

                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => HomePageSFor()));
        },
        child: Icon(Icons.refresh),
      ),
    );
  }


  AddNewGraph(List coins, dates,typeOfdate) async {

    var intervals='15m';
    if(typeOfdate==0) {intervals=timeIntervalsHttp[dates[0]];}
    if(typeOfdate==1) {intervals=timeIntervalsHttp[dates[1]];}
    if(typeOfdate==2) {intervals=timeIntervalsHttp[dates[3]];}
    if(typeOfdate==3) {intervals=timeIntervalsHttp[dates[0]];}


    for (int i = 0; i<coins.length; i++) {
      final uri = Uri.parse('https://api.binance.com/api/v3/uiKlines?symbol='+coins[i]['coin']+'&interval='+intervals+'&limit=30');
      final res = await http.get(uri);
      var resData = (jsonDecode(res.body) as List);
      print("График "+i.toString());
      print("График "+resData.toString());
      coins[i]["graphData"]=resData;
    }

    setState(() {graphButtonIndex2=0;});
  }

  Future<int> getDataLength()async{

    var DataLenghtVar = await model.getDataHive();

    if(TypeOfDataIndex==3){
      DataLenghtVar = await model.getCashNew();
    };

    if (DataLenghtVar==[]){
      return 0;
    } if (DataLenghtVar[9]!=TypeOfDataIndex){
      return 0;
    }
    return DataLenghtVar[11].length;

  }

  Future<List<dynamic>> Changer(changerVar,percents,dates,typeOfData) async {

    var HiveDate = await model.getDataHive();
    if(HiveDate.isEmpty&&typeOfData!=3){
      if(changerVar==0) { // Запуск обновления при пустом массиве

        print("Пустой массив ");
        changerVarIndex=1;
        if(typeOfData==0){
          return getTradablePairs2(percents[0],percents[2],dates[0],dates[2],TypeOfDataIndex,[saveInFutureIndexPump,saveInFutureIndexBullish,saveInFutureIndexBearlish]);
        }
        if(typeOfData==1){
          return getTradablePairs2(percents[1],percents[2],dates[1],dates[2],TypeOfDataIndex,[saveInFutureIndexPump,saveInFutureIndexBullish,saveInFutureIndexBearlish]);
        }
        if(typeOfData==2){
          return getTradablePairs2(percents[3],percents[2],dates[3],dates[2],TypeOfDataIndex,[saveInFutureIndexPump,saveInFutureIndexBullish,saveInFutureIndexBearlish]);
        }
      }
    }

    print("I");
    if(graphButtonIndex2==1&&graphButtonIndex==1){
      if(TypeOfDataIndex!=3){
        AddNewGraph(HiveDate[11],dates,typeOfData);
        graphButtonIndex=0;
      } else {
        var cash = await model.getCashNew();
        if(cash.isNotEmpty) {
          AddNewGraph(cash[11],dates,typeOfData);
          graphButtonIndex=0;
        }
      };
    } // Добавление графиков

    if(typeOfData==3&&listingCheck==true){
      ListingFunc(changerVarIndex,FinalPercent,FinalDate,TypeOfDataIndex);
      print("As");
      var dataNewCash= await model.getCashNew();
      return dataNewCash;
    }
    print("II");
    if(typeOfData==3&&listingCheck==true){

      print("1 — Получение запроса");
      List decode=[]; // Начало листинга
      try { // http запросы
        final res = await http.get(Uri.parse("https://api.binance.com/api/v3/ticker/24hr"));
        (jsonDecode(res.body) as List).forEach((element) {decode.add(element);});
      } catch (e) {print("Ошибка тикера 1"+e.toString());} //Парсинг новых значений


      print("2 — Данные из памяти");
      var modelx = await model.getDataListing() as List; //Данные из памяти
      print("modelx length "+modelx.length.toString());

      print("3 — Сохранение декода");
      decode.removeWhere((element) => element["highPrice"].toString()=="0.00000000"); //Чистка новых значений
      print("decode "+decode.length.toString());
      var decode22=[]; decode.forEach((element) {decode22.add(element);});
      model.saveDataListing(decode22,DateTime.now()); // Сохранение значений
      await Future.delayed(Duration(seconds: 3));

      print("4 — Показ длины старых и новых значений");
      print("modelx.length[last] "+modelx[modelx.length-1].length.toString());
      print("decode.length[last] "+decode.length.toString());

      print("modelx.length "+modelx[modelx.length-1].length.toString());
      print("decode.length2 "+decode.length.toString());
      var data=[]; // Переменная для обьектов

      print("5 — Получение новых монет и подготовка к выводу");

      var decode2=[];

      if(modelx[modelx.length-1].length<decode.length) {
        print("Есть новые монеты");
        decode.forEach((element2) {
          var indexs=0;
          for(int i=0;i<modelx[modelx.length-1].length;i++){
            if(modelx[modelx.length-1][i]['symbol']==element2['symbol']){
              indexs=1;
            }
          }
          if(indexs==0){
            decode2.add(element2);
          }
          // (decode as List).removeWhere((element) => element["symbol"]==element2["symbol"]);
        });
        print("Новые монеты DC "+decode2.length.toString());
        data=decode2;
      } else {
        print("Нет новых монет");
      }
      print("Колиество новых монет "+data.length.toString()); // Подготовка
      var coinsCorrect=[]; var pricesCorrect=[]; var priceChange=[]; var decodePrevOpenPrice=[]; var emptyGraph=[]; var CurrentDate=DateTime.now();

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

      print("7 — Превращение в обьекты");
      List coinMapList=[]; // Превращение в обьекты
      for(int i=0;i<coinsCorrect.length;i++){
        Map coinMap=Map();
        coinMap["coin"]=coinsCorrect[i];
        coinMap["price"]=pricesCorrect[i];
        coinMap["date"]=3;
        coinMap["percant"]=priceChange[i];
        coinMap["saveDate"]=DateTime.now().add(durationsList[saveInFutureIndexListing]);
        coinMap["graphData"]=[111.111,111.111,111.111];
        coinMap["newcard"]=1;
        coinMapList.add(coinMap);
        print("coin "+coinMapList[i].toString());
      } // Превращение в обьекты


      print("8 — Сохранение и получение новых монет");
      // await model.saveListingCoins(coinMapList);
      // var listingcoins = await model.getListingCoins();

      var newCash=await model.getCashNew();
      if(newCash.isNotEmpty) {
        (newCash[11] as List).forEach((newElement) {
          var changes=0;
          coinMapList.forEach((element) {
            if(newElement==element) {
              changes=1;
            }
          });
          if(changes==1) {
            coinMapList.add(newElement);
          }
        });
      }
      coinMapList.removeWhere((element) => DateTime.now().compareTo(element["saveDate"] as DateTime)==1);
      coinMapList.forEach((element) {
        print(element["saveDate"]);
      });

      var result=[coinsCorrect, pricesCorrect, priceChange, decodePrevOpenPrice,CurrentDate,percents[0],percents[1],dates[0],dates[1],TypeOfDataIndex,emptyGraph,coinMapList];
      model.saveCashNew(result);

      setState(() {
        ListingLoadingIndex=0;
        listingCheck=false;
      });
      print("9 — Вывод "+result.toString());
      refreshCheck=false; return result; // Обнуление индексов и выдача результатов
    } // Листинг


    bool TimeBool = DateTime.now().compareTo((HiveDate[4] as DateTime).add(Duration(minutes: 25)))!=1;
    bool percentBool = HiveDate[5].toString()==percents[0].toString();
    bool dateBool = HiveDate[7].toString()==dates[0].toString();
    bool typeBool = HiveDate[9].toString()==typeOfData.toString();
    bool DidCicleWorkBool = changerVarIndex==0;
    bool DidButtonUpdateClicked = refreshCheck==false;


    if(typeOfData==0){
      TimeBool = DateTime.now().compareTo((HiveDate[4] as DateTime).add(Duration(minutes: 25)))!=1;
      percentBool = HiveDate[5].toString()==percents[0].toString();
      dateBool = HiveDate[7].toString()==dates[0].toString();
      typeBool = HiveDate[9].toString()==typeOfData.toString();
      DidCicleWorkBool = changerVarIndex==0;
    }
    if(typeOfData==1){
      TimeBool = DateTime.now().compareTo((HiveDate[4] as DateTime).add(Duration(minutes: 45)))!=1;
      percentBool = HiveDate[5].toString()==percents[1].toString();
      dateBool = HiveDate[7].toString()==dates[1].toString();
      typeBool = HiveDate[9].toString()==typeOfData.toString();
      DidCicleWorkBool = changerVarIndex==0;
    }
    if(typeOfData==2){
      TimeBool = DateTime.now().compareTo((HiveDate[4] as DateTime).add(Duration(minutes: 45)))!=1;
      percentBool = HiveDate[5].toString()==percents[3].toString();
      dateBool = HiveDate[7].toString()==dates[3].toString();
      typeBool = HiveDate[9].toString()==typeOfData.toString();
      DidCicleWorkBool = changerVarIndex==0;
    }


    print("III");
    if (TimeBool&&percentBool&&dateBool&&typeBool&&DidCicleWorkBool&&DidButtonUpdateClicked){
      print("Данные из памяти, время сравнения "+(HiveDate[4] as DateTime).add(Duration(minutes: 45)).toString());
      print("Длина данных "+HiveDate.length.toString());
      dataLenght=HiveDate[11].length;
      print("HiveDate[2].length;"+HiveDate[2].length.toString());
      print(HiveDate[11]);

      refreshCheck=false;
      return HiveDate;
    }
    else {

      print("IIII");

      // Запуск обновления с кнопки
      if(refreshCheck==false){
        print("Вернули пустой массив");
        return ["","","","","","","","","","","","",];
      }

      if(changerVar==0) {
        print("IIIII");
        changerVarIndex=1; // Демонстрация работы цикла
        if(typeOfData==0) {
          return getTradablePairs2(percents[0],percents[2],dates[0],dates[2],TypeOfDataIndex,[saveInFutureIndexPump,saveInFutureIndexBullish,saveInFutureIndexBearlish]);
        }
        if(typeOfData==1) {
          return getTradablePairs2(percents[1],percents[2],dates[1],dates[2],TypeOfDataIndex,[saveInFutureIndexPump,saveInFutureIndexBullish,saveInFutureIndexBearlish]);
        }
        if(typeOfData==2) {
          return getTradablePairs2(percents[3],percents[2],dates[3],dates[2],TypeOfDataIndex,[saveInFutureIndexPump,saveInFutureIndexBullish,saveInFutureIndexBearlish]);
        }
      }

      return Future.delayed(Duration(seconds: 3));
    }
  }

  Future<List<dynamic>> getTradablePairs2(percent1,percant2,date1,date2,typeOfDataFunc,saveIndex) async {
    var saveIndexFinal=saveIndex[typeOfDataFunc];
    var timeIntervalsHttp=["1m", "3m", "5m", "15m", "30m", "1h", "1d",];

    if(typeOfDataFunc==1){
      CurrentGraphIndex=1;
    } else {
      CurrentGraphIndex=0;
    }

    StopFunctionIndex=0;

    final res = await http.get(Uri.parse('https://api.binance.com/api/v3/ticker/24hr'));
    var resData = (jsonDecode(res.body) as List);
    var coins=[]; var prices=[]; var percant=[];

    resData.forEach((element) {
      coins.add(element["symbol"]);
      prices.add(element["lastPrice"]);
      percant.add(element["priceChangePercent"]);
    });

    var coinsCorrect=[];
    var coinsNew=[];
    List<String> coinsNew3S=['','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',];
    var emptyGraph=[];
    var pricesCorrect=[];
    var coinsTesting=[[],[],[],[]];
    var pricesTesting=[[],[],[],[]];

    //Фильтрация
    for(int i=0; i < coins.length; i++){
      if(coins[i].toString()=="BTCUSDT") {
        print("Нашли!)");
        lastClosePrice=prices[i];
        BTCpercent=percant[i].toString();
      }

      if(coins[i].substring(coins[i].length-4)=="BUSD"){
        coinsTesting[0].add(coins[i].substring(0,coins[i].length-4));
        pricesTesting[0].add(prices[i]);
      }

      if(coins[i].substring(coins[i].length-4)=="USDT"){
        coinsTesting[1].add(coins[i].substring(0,coins[i].length-4));
        pricesTesting[1].add(prices[i]);
      }

      if(coins[i].substring(coins[i].length-3)=="BNB"){
        coinsTesting[2].add(coins[i].substring(0,coins[i].length-3));
        pricesTesting[2].add(prices[i]);
      }

      if(coins[i].substring(coins[i].length-3)=="BTC"){
        coinsTesting[3].add(coins[i].substring(0,coins[i].length-3));
        pricesTesting[3].add(prices[i]);
      }
    }

    //Чистка и сортировка
    coinsTesting[0].forEach((element) {
      if(coinsTesting[1].indexWhere((element2) => element2==element)>=0){
        pricesTesting[1].removeAt(coinsTesting[1].indexWhere((element2) => element2==element));
      }
      if(coinsTesting[2].indexWhere((element2) => element2==element)>=0){
        pricesTesting[2].removeAt(coinsTesting[2].indexWhere((element2) => element2==element));
      }
      if(coinsTesting[3].indexWhere((element2) => element2==element)>=0){
        pricesTesting[3].removeAt(coinsTesting[3].indexWhere((element2) => element2==element));
      }

      coinsTesting[1].removeWhere((element2) => element2==element);
      coinsTesting[2].removeWhere((element2) => element2==element);
      coinsTesting[3].removeWhere((element2) => element2==element);
    });
    coinsTesting[1].forEach((element) {
      if(coinsTesting[2].indexWhere((element2) => element2==element)>=0){
        pricesTesting[2].removeAt(coinsTesting[2].indexWhere((element2) => element2==element));
      }
      if(coinsTesting[3].indexWhere((element2) => element2==element)>=0){
        pricesTesting[3].removeAt(coinsTesting[3].indexWhere((element2) => element2==element));
      }
      coinsTesting[2].removeWhere((element2) => element2==element);
      coinsTesting[3].removeWhere((element2) => element2==element);
    });
    coinsTesting[2].forEach((element) {
      if(coinsTesting[3].indexWhere((element2) => element2==element)>=0){
        pricesTesting[3].removeAt(coinsTesting[3].indexWhere((element2) => element2==element));
      }
      coinsTesting[3].removeWhere((element2) => element2==element);
    });

    // Проставление имени и сортировка в 1 массив
    coinsTesting[0].forEach((element) {coinsCorrect.add(element+"BUSD");});
    pricesTesting[0].forEach((element) {pricesCorrect.add(element);});

    coinsTesting[1].forEach((element) {coinsCorrect.add(element+"USDT");});
    pricesTesting[1].forEach((element) {pricesCorrect.add(element);});

    coinsTesting[2].forEach((element) {coinsCorrect.add(element+"BNB");});
    pricesTesting[2].forEach((element) {pricesCorrect.add(element);});

    coinsTesting[3].forEach((element) {coinsCorrect.add(element+"BTC");coinsNew.add(element+"BTC");});
    pricesTesting[3].forEach((element) {pricesCorrect.add(element);});


    // Конвертирование для запроса по API
    print("coinsCorrect "+coinsCorrect.toString());

    List convertor=coinsCorrect;
    var b=0;
    for(int i=0; i < convertor.length; i++){
      if(coinsNew3S[b].length>90) { b=b+1; }

      coinsNew3S[b]=coinsNew3S[b]+'\"';
      coinsNew3S[b]=coinsNew3S[b]+convertor[i].toString();
        if(i!=convertor.length-1){
          coinsNew3S[b]=coinsNew3S[b]+'\"\,';
        } else {
          coinsNew3S[b]=coinsNew3S[b]+'\"';
        }
      }

    coinsNew3S.removeWhere((element) => element.length==0);

    for(int i=0; i < coinsNew3S.length; i++){
      if(i < coinsNew3S.length-1){
        coinsNew3S[i] = coinsNew3S[i].substring(0, coinsNew3S[i].length - 1);
      }
    }


    List decodePrevOpenPrice=[];
    List decodeClosePrice=[];
    List priceChange=[];
    List decode=[];
    List decode2Bullish=[];


    // Запрос по API
    for(int i=0; i < coinsNew3S.length; i++){
      print("Массив "+i.toString()+" "+coinsNew3S[i].toString());

      setState(() {needToDelete=i;});

      final uri = Uri.parse('https://api.binance.com/api/v3/ticker?symbols=['+coinsNew3S[i]+']&windowSize='+timeIntervalsHttp[date1]);
      try {
        final res = await http.get(uri);
        (jsonDecode(res.body) as List).forEach((element) {
          decode.add(element);
          if(typeOfDataFunc!=1){
            decode2Bullish.add(element);
          }
        });
      } catch (e) {print("Ошибка тикера 1"+e.toString());}
    } // Конец цикла


    if(typeOfDataFunc==1) {
      await Future.delayed(Duration(seconds: 30));
      for(int i=0; i < coinsNew3S.length; i++){
        print("Массив2 "+i.toString()+" "+coinsNew3S[i].toString());

        setState(() {needToDelete=i;});

        final uri = Uri.parse('https://api.binance.com/api/v3/ticker?symbols=['+coinsNew3S[i]+']&windowSize='+timeIntervalsHttp[date2]);
        try {
          final res = await http.get(uri);
          (jsonDecode(res.body) as List).forEach((element) {
            decode2Bullish.add(element);
          });
        } catch (e) {print("Ошибка тикера 1"+e.toString());}
      } // Конец цикла
    }


    print("Длина цен кор "+coinsCorrect.length.toString());
    print("Длина кор прайс "+pricesCorrect.length.toString());
    print("Длина декодинга "+decode.length.toString());
    print("Длина декодинга 2 "+decode2Bullish.length.toString());

    var newCorePrice=[];
    pricesCorrect.forEach((element) {newCorePrice.add("22");});

    //Чистка от пустых значений и фильтрация по условию
    var coinsCorrectFor=coinsCorrect;
    var pricesCorrectFor=pricesCorrect;


    for(int i=0; i < decode.length; i++) {

      // Проверка на наличие условий
      List<bool> listOfBool=[
        ((double.parse(decode[i]["priceChangePercent"]))<percent1),
        (((double.parse(decode[i]["priceChangePercent"]))<percent1)&&((double.parse(decode2Bullish[i]["priceChangePercent"]))<percant2)),
        ((double.parse(decode[i]["priceChangePercent"]))>percent1),
      ];

      // Чистка условий
      if((decode[i]["openPrice"].toString()=="0.00000000")||listOfBool[typeOfDataFunc]){
        if(i!=0){ // Decode чистка монет и цен
          coinsCorrectFor[i]="";
          pricesCorrectFor[i]=3334.3334;
          decode[i]["symbol"]="NO";
          decode2Bullish[i]["symbol"]="NO";
        } else {
          coinsCorrectFor[i]="";
          pricesCorrectFor[i]=3334.3334;
          decode[i]["symbol"]="NO";
          decode2Bullish[i]["symbol"]="NO";
        }
      }
    }


    coinsCorrectFor.removeWhere((element) => element.toString()=="");
    pricesCorrectFor.removeWhere((element) => element==3334.3334);

    // Pump рассортировка декода
    if(typeOfDataFunc==0){
      decode.removeWhere((element) => ((element["openPrice"].toString()=="0.00000000")||(double.parse(element["priceChangePercent"])<percent1)));
      decode.forEach((element) { // Чистка декода вверху
        emptyGraph.add([111.111,111.111,111.111]);
        decodePrevOpenPrice.add(element["openPrice"]);
        decodeClosePrice.add(element["lastPrice"]);
        priceChange.add(element["priceChangePercent"]);
      });
    }


    if(typeOfDataFunc==1){ // Bullish рассортировка декода
      decode.removeWhere((element) => element["symbol"]=="NO");
      decode2Bullish.removeWhere((element) => element["symbol"]=="NO");

      decode.forEach((element) {
        emptyGraph.add([111.111,111.111,111.111]);
        decodePrevOpenPrice.add(element["openPrice"]);
        decodeClosePrice.add(element["lastPrice"]);
        priceChange.add(element["priceChangePercent"]);
      });
    }

    if(typeOfDataFunc==2) { // Bearish рассортировка декода
      decode.removeWhere((element) => ((element["openPrice"].toString()=="0.00000000")||(double.parse(element["priceChangePercent"])>percent1)));
      decode.forEach((element) { // Чистка декода вверху
        emptyGraph.add([111.111,111.111,111.111]);
        decodePrevOpenPrice.add(element["openPrice"]);
        decodeClosePrice.add(element["lastPrice"]);
        priceChange.add(element["priceChangePercent"]);
      });
    }


    print("Длина полного массива "+coins.length.toString());
    print("Длина корректного массива "+coinsCorrectFor.length.toString());
    print("Длина декода цен "+pricesCorrectFor.length.toString());
    print("newCorePrice "+newCorePrice.length.toString());
    print("Длина декода1 "+decode.length.toString());
    print("Длина декода1 "+decode.toString());
    print("Длина декода2 "+decode2Bullish.length.toString());
    print("Длина декода open прайс "+decodePrevOpenPrice.length.toString());
    print("Длина разницы "+priceChange.length.toString());
    print("emptyGraph lenght "+emptyGraph.length.toString());



    List coinMapList=[]; // Превращение в обьекты
    for(int i=0;i<decode.length;i++){
      Map coinMap=Map();
      coinMap["coin"]=decode[i]['symbol'];
      coinMap["price"]=decode[i]['lastPrice'];
      if(typeOfDataFunc==1){
        coinMap["date"]=date1;
      } else {
        coinMap["date"]=date1;
      }
      coinMap["percant"]=decode[i]['priceChangePercent'];
      coinMap["saveDate"]=DateTime.now().add(durationsList[saveIndexFinal]);
      coinMap["graphData"]=[111.111,111.111,111.111];
      coinMap["newcard"]=1;
      coinMapList.add(coinMap);
      print("coin "+coinMapList[i].toString());
    }

    var HiveDate = await model.getDataHive();
    var OldCash = await model.getCashPairs();// Добавление старых пар
    if(OldCash.isNotEmpty){
      print("началась проверка на Old Cash :p, длина "+OldCash[11].length.toString());
      if(OldCash[9]==typeOfDataFunc&&OldCash[5]==percent1&&OldCash[7]==date1) {
        print("началась проверка на Old Cash :p этап 2");

        (OldCash[11] as List).forEach((element) {

          print("На проверке "+element[11].toString());
          var compare=0;

          coinMapList.forEach((element2) {

            if(element["coin"]==element2["coin"]){
              print("Есть и так "+element2.toString());
              element2["newcard"]=0;
              compare=1; // Индекс не разрешающий добавлять
            }
          });

          if(compare==0){
            print("Берем из базы и добавляем "+element.toString());
            element["newcard"]=0;
            coinMapList.add(element); // Добавление старой пары
          }

        });
      }
    }

    print("закончилась проверка на Old Cash :p");
    var data=[coinsCorrect,pricesCorrect,priceChange, decodePrevOpenPrice ,
      DateTime.now(),percent1,"percent2",date1,date2,typeOfDataFunc,emptyGraph,coinMapList];
    model.saveDataHive(data);
    model.saveCashOfPair(data);

    // dataLenght=coinMapList.length; changerVarIndex=0; refreshCheck=false;
    setState(() {dataLenght=coinMapList.length; changerVarIndex=0; refreshCheck=false;});
    var result=[coinsCorrect, pricesCorrect, priceChange, decodePrevOpenPrice,DateTime.now(),percent1,"percent2",date1,date2,typeOfDataFunc,emptyGraph,coinMapList];
    print("Coun map List: "+coinMapList.toString());
    return result;
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
  CryptoCard({Key? key,required this.name,required this.price,required this.priceChange,required this.period,required this.graphdata,required this.newcard,required this.saveDates}) : super(key: key);

  @override
  State<CryptoCard> createState() => _CryptoCardState();
}
class _CryptoCardState extends State<CryptoCard> {

  List<ChartData> chartData = [
    ChartData(1, 1),
    ChartData(2, 3),
  ];



  @override
  void initState() {

    // print("graph data "+widget.graphdata.length.toString());
    // print("graph data "+widget.graphdata.length.toString());
    if(widget.graphdata.length==30){

      setState(() {
        chartData = [
          ChartData(1, double.parse(widget.graphdata[0][4])),
          ChartData(2, double.parse(widget.graphdata[1][4])),
          ChartData(3, double.parse(widget.graphdata[2][4])),
          ChartData(4, double.parse(widget.graphdata[3][4])),
          ChartData(5, double.parse(widget.graphdata[4][4])),
          ChartData(6, double.parse(widget.graphdata[5][4])),
          ChartData(7, double.parse(widget.graphdata[6][4])),
          ChartData(8, double.parse(widget.graphdata[7][4])),
          ChartData(9, double.parse(widget.graphdata[8][4])),
          ChartData(10, double.parse(widget.graphdata[9][4])),
          ChartData(11, double.parse(widget.graphdata[10][4])),
          ChartData(12, double.parse(widget.graphdata[11][4])),
          ChartData(13, double.parse(widget.graphdata[12][4])),
          ChartData(14, double.parse(widget.graphdata[13][4])),
          ChartData(15, double.parse(widget.graphdata[14][4])),
          ChartData(16, double.parse(widget.graphdata[15][4])),
          ChartData(17, double.parse(widget.graphdata[16][4])),
          ChartData(18, double.parse(widget.graphdata[17][4])),
          ChartData(19, double.parse(widget.graphdata[18][4])),
          ChartData(20, double.parse(widget.graphdata[19][4])),
          ChartData(21, double.parse(widget.graphdata[20][4])),
          ChartData(22, double.parse(widget.graphdata[21][4])),
          ChartData(23, double.parse(widget.graphdata[22][4])),
          ChartData(24, double.parse(widget.graphdata[23][4])),
          ChartData(25, double.parse(widget.graphdata[24][4])),
          ChartData(26, double.parse(widget.graphdata[25][4])),
          ChartData(27, double.parse(widget.graphdata[26][4])),
          ChartData(28, double.parse(widget.graphdata[27][4])),
          ChartData(29, double.parse(widget.graphdata[28][4])),
          ChartData(30, double.parse(widget.graphdata[29][4])),
        ];
      });
    } else {
      setState(() {
        chartData = [
          ChartData(1, double.parse(widget.price)),
          ChartData(2, double.parse(widget.price)),
          ChartData(3, double.parse(widget.price)),
          ChartData(4, double.parse(widget.price)),
        ];
      });
    }


    // TODO: implement initState
    super.initState();
  }

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
    } else {
      graphColor=Colors.red;
    }


    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => Details(coin: widget.name,date: 3)));
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
                  Text(widget.price.toString(),style: TextStyle(color: Colors.white))
                ],
              ),
            ),
            SizedBox(width: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(((widget.saveDates as DateTime).difference(DateTime.now())).inMinutes.toString()+" мин.",style: TextStyle(color: Colors.white)),
                SizedBox(height: 4),
                if(widget.priceChange.toString().substring(0,1)=="-") ...[
                  if(widget.priceChange.toString().length>6) ...[
                    Text(widget.priceChange.toString().substring(0,6)+"%",style: text_style)
                  ] else ...[
                    Text(widget.priceChange.toString()+"%",style: text_style)
                  ]
                ] else ...[
                  if(widget.priceChange.toString().length>6) ...[
                    Text("+"+widget.priceChange.toString().substring(0,5)+"%",style: text_style)
                  ] else ...[
                    Text("+"+widget.priceChange.toString()+"%",style: text_style)
                  ]
                ],
              ],
            ),
            SizedBox(width: 24),
            if(widget.graphdata.toString()=="nulll") ...[
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
                      dataSource: chartData,
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
  var PumpsIntervalsIndex=3;
  var Bulish1IntervalsIndex=3;
  var Bulish2IntervalsIndex=3;
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
                                  name=name-0.1;
                                });
                              },
                              icon: Icon(CupertinoIcons.minus_circle,color: Colors.white),
                            ),
                            if(name.toString().length>3) ...[
                              Text(name.toString().substring(0,4)+"%"),
                            ] else ...[
                              Text(name.toString().substring(0,3)+"%"),
                            ],
                            IconButton(
                              onPressed: (){
                                setState(() {
                                  name=name+0.1;
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
                                  name2=name2-0.1;
                                });
                              },
                              icon: Icon(CupertinoIcons.minus_circle,color: Colors.white),
                            ),
                            if(name2.toString().length>3) ...[
                              Text(name2.toString().substring(0,4)+"%"),
                            ] else ...[
                              Text(name2.toString().substring(0,3)+"%"),
                            ],
                            IconButton(
                              onPressed: (){
                                setState(() {
                                  name2=name2+0.1;
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
                                  name3=name3-0.1;
                                });
                              },
                              icon: Icon(CupertinoIcons.minus_circle,color: Colors.white),
                            ),
                            if(name3.toString().length>3) ...[
                              Text(name3.toString().substring(0,4)+"%"),
                            ] else ...[
                              Text(name3.toString().substring(0,3)+"%"),
                            ],
                            IconButton(
                              onPressed: (){
                                setState(() {
                                  name3=name3+0.1;
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
                                  name4=name4-0.1;
                                });
                              },
                              icon: Icon(CupertinoIcons.minus_circle,color: Colors.white),
                            ),
                            if(name4.toString().length>3) ...[
                              Text(name4.toString().substring(0,4)+"%"),
                            ] else ...[
                              Text(name4.toString().substring(0,3)+"%"),
                            ],
                            IconButton(
                              onPressed: (){
                                setState(() {
                                  name4=name4+0.1;
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



class CoinsClass {
  String coin="";
  double price=0.5;
  double percentage=0.5;
  int dateIndex=0;
}


