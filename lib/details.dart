import 'package:binance_spot/binance_spot.dart';

import 'dart:convert';
import 'package:candlesticks/candlesticks.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'package:binance_spot/binance_spot.dart';
import 'package:flutter/material.dart' hide Interval;


class Details extends StatefulWidget {
  final coin;
  final date;
  const Details({Key? key,required this.coin,required this.date}) : super(key: key);

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  List<Candle> candles = [];
  bool themeIsDark = false;



  List TextStyles=[TextStyle(color: Colors.white60,fontSize: 14,fontWeight: FontWeight.w300),TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w600)];

  var TextStyleValue1=0;
  var TextStyleValue2=0;
  var TextStyleValue3=0;
  var TextStyleValue4=0;
  var TextStyleValue5=1;
  var TextStyleValue6=0;
  var TextStyleValue7=0;
  var TextStyleValue8=0;
  var percentage="Загрузка";
  var pr1="pr1";
  var pr2="pr2";
  var pr3="pr3";
  var interv=Interval.INTERVAL_5m;
  var CountTrades="0";

  var timing="1d";



  void GetPrecentage() async{

    // interv.toString().substring(interv.toString().length-2)

    final uri = Uri.parse('https://api.binance.com/api/v3/ticker?symbol='+widget.coin+'&windowSize=$timing');
    final res = await http.get(uri);

    final uri2 = Uri.parse('https://api.binance.com/api/v3/klines?symbol='+widget.coin+'&interval=$timing&limit=1');
    final res2 = await http.get(uri2);

    final uri3 = Uri.parse('https://api.binance.com/api/v3/ticker?symbol='+widget.coin+'&windowSize=1d');
    final res3 = await http.get(uri3);
    var a2=double.parse(jsonDecode(res2.body)[0][1]);
    var b2=double.parse(jsonDecode(res2.body)[0][4]);
    var PourcantCompare2=(a2/b2-1)*100;


    var a=double.parse(jsonDecode(res2.body)[0][1]);
    var b=double.parse(jsonDecode(res2.body)[0][4]);
    print("TEST TEST "+jsonDecode(res.body).toString());
    print("TEST TEST TEST "+jsonDecode(res2.body)[0].toString());
    print("OP: "+a.toString());
    print("LP: "+b.toString());
    var PourcantCompare=(b/a-1)*100;

    setState(() {
      percentage=PourcantCompare.toString();
      CountTrades=jsonDecode(res3.body)['quoteVolume'].toString().substring(0, jsonDecode(res3.body)['quoteVolume'].toString().indexOf('.'));
    });

    print("Compare: "+PourcantCompare.toString()+"%");
  }



  void UpDating() {
    var Mytimer=Timer.periodic(Duration(seconds: 3),(timer) {

      if(UpdateIndex==0){
        print("Prinse ");
        GetPrecentage();
        fetchCandles().then((value) {
          setState(() {
            candles = value;
            interv=Interval.INTERVAL_3m;
          });
        });
        setState(() {

        });
      }



    });
  }

  var UpdateIndex=0;

  // void TimerFunc(Check){
  //
  //   if(Check==0){
  //     Mytimer.cancel();
  //   } else {
  //     Mytimer.tick;
  //   }
  // }

  var timeIntervalsHttp=["1m", "3m", "5m", "15m", "30m", "1h", "1d",];






  @override
  void initState() {

    UpDating();


    timing=timeIntervalsHttp[widget.date];
    if(widget.date==0){

      setState(() {
        TextStyleValue1=1;
        TextStyleValue2=0;
        TextStyleValue3=0;
        TextStyleValue4=0;
        TextStyleValue5=0;
        TextStyleValue6=0;
        TextStyleValue7=0;
        TextStyleValue8=0;

        timing="1m";
        fetchCandles().then((value) {
          setState(() {
            candles = value;
            interv=Interval.INTERVAL_1m;
          });
        });
      });
    } else if (widget.date==1){
      setState(() {
        TextStyleValue1=0;
        TextStyleValue2=1;
        TextStyleValue3=0;
        TextStyleValue4=0;
        TextStyleValue5=0;
        TextStyleValue6=0;
        TextStyleValue7=0;
        TextStyleValue8=0;

        timing="3m";
        fetchCandles().then((value) {
          setState(() {
            candles = value;
            interv=Interval.INTERVAL_3m;
          });
        });
      });
    } else if (widget.date==2){
      setState(() {
        TextStyleValue1=0;
        TextStyleValue2=0;
        TextStyleValue3=1;
        TextStyleValue4=0;
        TextStyleValue5=0;
        TextStyleValue6=0;
        TextStyleValue7=0;
        TextStyleValue8=0;

        timing="5m";
        fetchCandles().then((value) {
          setState(() {
            candles = value;
            interv=Interval.INTERVAL_5m;
          });
        });
      });
    } else if (widget.date==3){
      setState(() {
        TextStyleValue1=0;
        TextStyleValue2=0;
        TextStyleValue3=0;
        TextStyleValue4=1;
        TextStyleValue5=0;
        TextStyleValue6=0;
        TextStyleValue7=0;
        TextStyleValue8=0;

        timing="15m";
        fetchCandles().then((value) {
          setState(() {
            candles = value;
            interv=Interval.INTERVAL_15m;
          });
        });
      });
    } else if (widget.date==4){
      setState(() {
        TextStyleValue1=0;
        TextStyleValue2=0;
        TextStyleValue3=0;
        TextStyleValue4=0;
        TextStyleValue5=1;
        TextStyleValue6=0;
        TextStyleValue7=0;
        TextStyleValue8=0;

        timing="30m";
        fetchCandles().then((value) {
          setState(() {
            candles = value;
            interv=Interval.INTERVAL_30m;
          });
        });
      });
    } else if (widget.date==5){
      setState(() {
        TextStyleValue1=0;
        TextStyleValue2=0;
        TextStyleValue3=0;
        TextStyleValue4=0;
        TextStyleValue5=0;
        TextStyleValue6=1;
        TextStyleValue7=0;
        TextStyleValue8=0;

        timing="1h";
        fetchCandles().then((value) {
          setState(() {
            candles = value;
            interv=Interval.INTERVAL_1h;
          });
        });
      });
    } else if (widget.date==6){
      setState(() {
        TextStyleValue1=0;
        TextStyleValue2=0;
        TextStyleValue3=0;
        TextStyleValue4=0;
        TextStyleValue5=0;
        TextStyleValue6=0;
        TextStyleValue7=1;
        TextStyleValue8=0;

        timing="1d";
        fetchCandles().then((value) {
          setState(() {
            candles = value;
            interv=Interval.INTERVAL_1d;
          });
        });
      });
    }

    GetPrecentage();

    super.initState();
  }

  @override
  void dispose() {

    UpdateIndex=1;
    super.dispose();
  }

  Future<List<Candle>> fetchCandles() async {
    print("Настройка времени "+timing);

    final uri = Uri.parse(
        "https://api.binance.com/api/v3/klines?symbol="+widget.coin+"&interval="+timing);
    final res = await http.get(uri);


    return (jsonDecode(res.body) as List<dynamic>)
        .map((e) => Candle.fromJson(e))
        .toList()
        .reversed
        .toList();
  }

  void Sorteds(a,b) {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black87,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    padding: EdgeInsets.only(left: 24,top: 72),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Statistic ",style: TextStyle(color: Colors.white60,fontSize: 16)),
                        SizedBox(height: 8),
                        InkWell(
                          onTap: (){
                            var mass=[1,2,3];
                            var mass2=[...mass];
                            mass2.add(4);
                            mass2=[...mass];
                            mass.sort((a,b){
                              if(a<b) {
                                return 1;
                              } else {
                                return -1;
                              }
                            });
                            print(mass.toString());
                            print(mass2.toString());
                          },
                          child: Text(widget.coin.toString(),style: TextStyle(color: Colors.white,fontSize: 36,fontWeight: FontWeight.w600)),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            if(percentage.substring(0,1)=="-") ...[
                              if(percentage.length>7) ...[
                                Text(percentage.substring(0,8)+" %",style: TextStyle(color: Colors.white60,fontSize: 16))
                              ] else ...[
                                Text(percentage+"%",style: TextStyle(color: Colors.white60,fontSize: 16))
                              ]
                            ] else ...[
                              if(percentage.length>7) ...[
                                Text("+"+percentage.substring(0,8)+" %",style: TextStyle(color: Colors.white60,fontSize: 16))
                              ] else ...[
                                Text("+ "+percentage+"%",style: TextStyle(color: Colors.white60,fontSize: 16))
                              ]
                            ],
                            // SizedBox(width: 8,),
                            // Text(pr1),
                            // SizedBox(width: 8,),
                            // Text(pr2),
                            // SizedBox(width: 8,),
                            // Text(pr3),
                          ],
                        )
                      ],
                    )
                ),
                SizedBox(height: 24),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Color(0xFFFFFFFF)),
                      left: BorderSide(),
                      right: BorderSide(),
                      bottom: BorderSide(color: Color(0xFFFFFFFF)),
                    ),
                  ),
                  width: double.infinity,
                  height: 300,
                  child: Center(
                    child: Candlesticks(
                      candles: candles,
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Container(
                  margin: EdgeInsets.only(left: 24),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: (){
                          setState(() {
                            TextStyleValue1=1;
                            TextStyleValue2=0;
                            TextStyleValue3=0;
                            TextStyleValue4=0;
                            TextStyleValue5=0;
                            TextStyleValue6=0;
                            TextStyleValue7=0;
                            TextStyleValue8=0;
                            timing="1m";

                            fetchCandles().then((value) {
                              setState(() {
                                candles = value;
                                interv=Interval.INTERVAL_1m;
                              });
                            });

                            GetPrecentage();
                          });
                        },
                        child: Text("1 м.",style: TextStyles[TextStyleValue1]),
                      ),
                      SizedBox(width: 16),
                      InkWell(
                        onTap: (){
                          setState(() {
                            TextStyleValue1=0;
                            TextStyleValue2=1;
                            TextStyleValue3=0;
                            TextStyleValue4=0;
                            TextStyleValue5=0;
                            TextStyleValue6=0;
                            TextStyleValue7=0;
                            TextStyleValue8=0;
                            timing="3m";

                            fetchCandles().then((value) {
                              setState(() {
                                candles = value;
                                interv=Interval.INTERVAL_3m;
                              });
                            });

                            GetPrecentage();
                          });
                        },
                        child: Text("3 м.",style: TextStyles[TextStyleValue2]),
                      ),
                      SizedBox(width: 16),
                      InkWell(
                        onTap: (){
                          setState(() {
                            TextStyleValue1=0;
                            TextStyleValue2=0;
                            TextStyleValue3=1;
                            TextStyleValue4=0;
                            TextStyleValue5=0;
                            TextStyleValue6=0;
                            TextStyleValue7=0;
                            TextStyleValue8=0;
                            timing="5m";

                            fetchCandles().then((value) {
                              setState(() {
                                candles = value;
                                interv=Interval.INTERVAL_5m;
                              });
                            });

                            GetPrecentage();
                          });
                        },
                        child: Text("5 м.",style: TextStyles[TextStyleValue3]),
                      ),
                      SizedBox(width: 16),
                      InkWell(
                        onTap: (){
                          setState(() {
                            TextStyleValue1=0;
                            TextStyleValue2=0;
                            TextStyleValue3=0;
                            TextStyleValue4=1;
                            TextStyleValue5=0;
                            TextStyleValue6=0;
                            TextStyleValue7=0;
                            TextStyleValue8=0;
                            timing="15m";

                            fetchCandles().then((value) {
                              setState(() {
                                candles = value;
                                interv=Interval.INTERVAL_15m;
                              });
                            });

                            GetPrecentage();
                          });
                        },
                        child: Text("15 м.",style: TextStyles[TextStyleValue4]),
                      ),
                      SizedBox(width: 16),
                      InkWell(
                        onTap: (){
                          setState(() {
                            TextStyleValue1=0;
                            TextStyleValue2=0;
                            TextStyleValue3=0;
                            TextStyleValue4=0;
                            TextStyleValue5=1;
                            TextStyleValue6=0;
                            TextStyleValue7=0;
                            TextStyleValue8=0;
                            timing="30m";

                            fetchCandles().then((value) {
                              setState(() {
                                candles = value;
                                interv=Interval.INTERVAL_30m;
                              });
                            });

                            GetPrecentage();
                          });
                        },
                        child: Text("30 м.",style: TextStyles[TextStyleValue5]),
                      ),
                      SizedBox(width: 16),
                      InkWell(
                        onTap: (){
                          setState(() {
                            TextStyleValue1=0;
                            TextStyleValue2=0;
                            TextStyleValue3=0;
                            TextStyleValue4=0;
                            TextStyleValue5=0;
                            TextStyleValue6=1;
                            TextStyleValue7=0;
                            TextStyleValue8=0;
                            timing="1h";

                            fetchCandles().then((value) {
                              setState(() {
                                candles = value;
                                interv=Interval.INTERVAL_1h;
                              });
                            });

                            GetPrecentage();
                          });
                        },
                        child: Text("1 ч.",style: TextStyles[TextStyleValue6]),
                      ),
                      SizedBox(width: 16),
                      InkWell(
                        onTap: (){
                          setState(() {
                            TextStyleValue1=0;
                            TextStyleValue2=0;
                            TextStyleValue3=0;
                            TextStyleValue4=0;
                            TextStyleValue5=0;
                            TextStyleValue6=0;
                            TextStyleValue7=1;
                            TextStyleValue8=0;
                            timing="1d";

                            fetchCandles().then((value) {
                              setState(() {
                                candles = value;
                                interv=Interval.INTERVAL_1d;
                              });
                            });

                            GetPrecentage();
                          });
                        },
                        child: Text("1 д.",style: TextStyles[TextStyleValue7]),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 36),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Объем торгов",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w600)),
                          SizedBox(height: 4),
                          Text(CountTrades.toString()+" / 24 часа",style: TextStyle(color: Colors.white60,fontSize: 16)),
                        ],
                      ),
                    ),
                    SizedBox(height: 24,),
                    Container(
                      margin: EdgeInsets.only(left: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Изменения",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w600)),
                          SizedBox(height: 4),
                          if(percentage.substring(0,1)=="-") ...[
                            if(percentage.length>6) ...[
                              Text(percentage.substring(0,5)+"%",style: TextStyle(color: Colors.white60,fontSize: 16))
                            ] else ...[
                              Text(percentage+"%",style: TextStyle(color: Colors.white60,fontSize: 16))
                            ]
                          ] else ...[
                            if(percentage.length>6) ...[
                              Text("+ "+percentage.substring(0,8)+" %",style: TextStyle(color: Colors.white60,fontSize: 16))
                            ] else ...[
                              Text("+ "+percentage+" %",style: TextStyle(color: Colors.white60,fontSize: 16))
                            ]
                          ]
                        ],
                      ),
                    )
                  ],
                )
              ],
            )
        ),
      ),
    );
  }
}
