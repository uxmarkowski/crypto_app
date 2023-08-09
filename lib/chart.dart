import 'dart:convert';

import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class ChartPage2 extends StatefulWidget {
  const ChartPage2({Key? key}) : super(key: key);

  @override
  State<ChartPage2> createState() => _ChartPage2State();
}

class _ChartPage2State extends State<ChartPage2> {


  List list1=[];
  List list2=[];

  List<ChartData> chartData = [
    ChartData(1, 18369.93),
    ChartData(2, 18385.05),
    ChartData(3, 18383.44),
    ChartData(4, 18368.55),
    ChartData(5, 18377.85)
  ];

  List<ChartData> chartData2 = [
    ChartData(1, 17369.93),
    ChartData(2, 18385.05),
    ChartData(3, 19383.44),
    ChartData(4, 17368.55),
    ChartData(5, 18377.85)
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Container(
          color: Colors.black,
          child: Center(
              child: Column(
                children: [
                  SizedBox(height: 96,),
                  Text("Интервал за 15 мин"),
                  Container(
                      height: 200,
                      width: 400,
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
                                colors: [Colors.pink,Colors.pink.withAlpha(1)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter
                              ),
                          )
                        ],
                        primaryYAxis: NumericAxis(
                          isVisible: false
                        ),
                        primaryXAxis: NumericAxis(
                            isVisible: false
                        ),
                      )
                  ),
                  SizedBox(height: 64,),
                  Text("Интервал за 30 мин"),
                  Container(
                      height: 200,
                      width: 400,
                      child: SfCartesianChart(
                        borderColor: Colors.transparent,
                        borderWidth: 0,
                        plotAreaBorderWidth: 0,
                        series: <ChartSeries>[
                          // Renders spline chart
                          SplineAreaSeries<ChartData, int>(
                            dataSource: chartData2,
                            xValueMapper: (ChartData data, _) => data.x,
                            yValueMapper: (ChartData data, _) => data.y,
                            gradient: LinearGradient(
                                colors: [Colors.pink,Colors.pink.withAlpha(1)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter
                            ),
                          )
                        ],
                        primaryYAxis: NumericAxis(
                            isVisible: false
                        ),
                        primaryXAxis: NumericAxis(
                            isVisible: false
                        ),
                      )
                  ),
                  SizedBox(height: 64,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () async{

                          final uri3 = Uri.parse(
                              'https://api.binance.com/api/v3/uiKlines?symbol=FTTBUSD&interval=1m&limit=30');

                          // for (int i=0;i<300;i++) {
                          //   final res3 = await http.get(uri3);
                          //   print((jsonDecode(res3.body)as List)[0][2].toString());
                          // }





                          final uri = Uri.parse(
                              'https://api.binance.com/api/v3/uiKlines?symbol=FTTBUSD&interval=1m&limit=15');
                          final res = await http.get(uri);
                          list1=(jsonDecode(res.body)as List);

                          final uri2 = Uri.parse(
                              'https://api.binance.com/api/v3/uiKlines?symbol=FTTBUSD&interval=1m&limit=30');
                          final res2 = await http.get(uri2);

                          list2=(jsonDecode(res2.body)as List);

                          (jsonDecode(res.body)as List).forEach((element) {
                            print(element);
                          });
                        },
                        child: Text("Получить данные"),
                      ),
                      ElevatedButton(
                        onPressed: () async{
                          chartData.clear();
                          for(int i=0;i<list1.length;i++) {
                            chartData.add(ChartData(i+1, double.parse(list1[i][4])));
                          }
                          chartData2.clear();
                          for(int i=0;i<list2.length;i++) {
                            chartData2.add(ChartData(i+1, double.parse(list2[i][4])));
                          }
                          setState(() {

                          });
                        },
                        child: Text("Обновить данные"),
                      )
                    ],
                  )
                ],
              )
          ),
        )
    );
  }
}
class ChartData {
  ChartData(this.x, this.y);
  final int x;
  final double? y;
}


