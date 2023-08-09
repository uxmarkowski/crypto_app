
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:crypto_app/home_plus.dart';


class hive_example {
  hive_example() {
    Hive.initFlutter();
  }

  saveTest(data) async{

    var box = await Hive.openBox("SaveTest2");
    await box.put("TestData2", data);

  }

  getTest() async{

    var box = await Hive.openBox("SaveTest2");
    if(box.isEmpty) { return []; }
    var boxData = await box.get("TestData2");

    return boxData;
  }





  saveOptions(data) async{

    var box = await Hive.openBox("OptionsBox");
    await box.put("OptionsData", data);

  }


  Future<List<dynamic>> getOptions() async{

    var box = await Hive.openBox("OptionsBox");
    if(box.isEmpty) { return []; }
    var boxData = await box.get("OptionsData");

    return boxData;
  }

  saveCoinsData(first,second,third,timer1,timer2,timer3,timer4) async{

  print("second "+second.toString());

  for(int d=0;d<first.length;d++) {
    var GraphDataToChange=[];

    for(int e=0;e<first[d]['graphData'].length;e++) {

      var Xdata=first[d]['graphData'][e].x;
      var Ydata=first[d]['graphData'][e].y;

      GraphDataToChange.add([Xdata,Ydata]);
      (first[d] as Map)['graphDataAdapted']=GraphDataToChange;
    }

    (first[d]).remove('graphData');
  }

  for(int d=0;d<second.length;d++) {
    var GraphDataToChange=[];

    for(int e=0;e<second[d]['graphData'].length;e++) {
      var Xdata=second[d]['graphData'][e].x;
      var Ydata=second[d]['graphData'][e].y;

      GraphDataToChange.add([Xdata,Ydata]);
      (second[d] as Map)['graphDataAdapted']=GraphDataToChange;
    }

    (second[d]).remove('graphData');
  }

  for(int d=0;d<third.length;d++) {
    var GraphDataToChange=[];

    for(int e=0;e<third[d]['graphData'].length;e++) {
      var Xdata=third[d]['graphData'][e].x;
      var Ydata=third[d]['graphData'][e].y;

      GraphDataToChange.add([Xdata,Ydata]);
      (third[d] as Map)['graphDataAdapted']=GraphDataToChange;
    }

    (third[d]).remove('graphData');
  }


  var box = await Hive.openBox("CoinsDataBox");
  await box.put("CoinsDataValuesF", first);
  await box.put("CoinsDataValuesS", second);
  await box.put("CoinsDataValuesT", third);
  await box.put("timer1", timer1);
  await box.put("timer2", timer2);
  await box.put("timer3", timer3);
  await box.put("timer4", timer4);
  print("Сохранено");


  for(int d=0;d<first.length;d++) {
    List<ChartData> GraphDataToChange=[];
    for(int e=0;e<first[d]['graphDataAdapted'].length;e++) {
      var Xdata=first[d]['graphDataAdapted'][e][0];
      var Ydata=first[d]['graphDataAdapted'][e][1];

      GraphDataToChange.add(ChartData(Xdata, Ydata));
      (first[d] as Map)['graphData']=GraphDataToChange;
    }
  }

  for(int d=0;d<second.length;d++) {
    List<ChartData> GraphDataToChange=[];
    for(int e=0;e<second[d]['graphDataAdapted'].length;e++) {
      var Xdata=second[d]['graphDataAdapted'][e][0];
      var Ydata=second[d]['graphDataAdapted'][e][1];

      GraphDataToChange.add(ChartData(Xdata, Ydata));
      (second[d] as Map)['graphData']=GraphDataToChange;
    }

  }

  for(int d=0;d<third.length;d++) {
    List<ChartData> GraphDataToChange=[];
    for(int e=0;e<third[d]['graphDataAdapted'].length;e++) {
      var Xdata=third[d]['graphDataAdapted'][e][0];
      var Ydata=third[d]['graphDataAdapted'][e][1];

      GraphDataToChange.add(ChartData(Xdata, Ydata));
      (third[d] as Map)['graphData']=GraphDataToChange;
    }

  }

  print("Сохранено 2 "+third.toString());
  box.close();

  }

  getCoinsDataF() async{

    print("Шаг");

    var box = await Hive.openBox("CoinsDataBox");
    if(box.isEmpty) { return []; }
    var firstData = box.get("CoinsDataValuesF");
    print("Шаг 2 "+firstData.toString());

    for(int d=0;d<firstData.length;d++) {
      List<ChartData> GraphDataToChange=[];
      for(int e=0;e<firstData[d]['graphDataAdapted'].length;e++) {
        var Xdata=firstData[d]['graphDataAdapted'][e][0];
        var Ydata=firstData[d]['graphDataAdapted'][e][1];

        GraphDataToChange.add(ChartData(Xdata, Ydata));
        (firstData[d] as Map)['graphData']=GraphDataToChange;
      }
    }

    print("first "+firstData.toString());

    return firstData;
  }
  getCoinsDataS() async{

    print("Шаг");

    var box = await Hive.openBox("CoinsDataBox");
    if(box.isEmpty) { return []; }
    var secondData = box.get("CoinsDataValuesS");
    print("Шаг 2 "+secondData.toString());

    for(int d=0;d<secondData.length;d++) {
      List<ChartData> GraphDataToChange=[];
      for(int e=0;e<secondData[d]['graphDataAdapted'].length;e++) {
        var Xdata=secondData[d]['graphDataAdapted'][e][0];
        var Ydata=secondData[d]['graphDataAdapted'][e][1];

        GraphDataToChange.add(ChartData(Xdata, Ydata));
        (secondData[d] as Map)['graphData']=GraphDataToChange;
      }
    }

    print("second "+secondData.toString());
    print("second type "+secondData.runtimeType.toString());
    return secondData;
  }
  getCoinsDataT() async{

    print("Шаг");

    var box = await Hive.openBox("CoinsDataBox");
    if(box.isEmpty) { return []; }
    var thirdData = box.get("CoinsDataValuesT");
    print("Шаг 2 "+thirdData.toString());

    for(int d=0;d<thirdData.length;d++) {
      List<ChartData> GraphDataToChange=[];
      for(int e=0;e<thirdData[d]['graphDataAdapted'].length;e++) {
        var Xdata=thirdData[d]['graphDataAdapted'][e][0];
        var Ydata=thirdData[d]['graphDataAdapted'][e][1];

        GraphDataToChange.add(ChartData(Xdata, Ydata));
        (thirdData[d] as Map)['graphData']=GraphDataToChange;
      }
    }

    print("third "+thirdData.toString());
    print("third type "+thirdData.runtimeType.toString());
    return thirdData;
  }

  getCoinsTimer1() async{
    var box = await Hive.openBox("CoinsDataBox");
    if(box.isEmpty) { return 3; }
    var thirdData = box.get("timer1");
    if(thirdData.toString()=="null") { return 3; }
    return thirdData;
  }
  getCoinsTimer2() async{
    var box = await Hive.openBox("CoinsDataBox");
    if(box.isEmpty) { return 3; }
    var thirdData = box.get("timer2");
    if(thirdData.toString()=="null") { return 3; }
    return thirdData;
  }
  getCoinsTimer3() async{
    var box = await Hive.openBox("CoinsDataBox");
    if(box.isEmpty) { return 3; }
    var thirdData = box.get("timer3");
    if(thirdData.toString()=="null") { return 3; }
    return thirdData;
  }
  getCoinsTimer4() async{
    var box = await Hive.openBox("CoinsDataBox");
    if(box.isEmpty) { return 2; }
    var thirdData = box.get("timer4");
    if(thirdData.toString()=="null") { return 3; }
    return thirdData;
  }

  saveCashNew(NewData) async{

    var box = await Hive.openBox("CashNew");
    var oldData = await box.get("NewCashBox");
    print("NewCashBox "+oldData.toString());
    if(oldData!=null&&oldData!=[]&&oldData.toString()!="[]") {
      (oldData[11] as List).removeWhere((element) => ((element["saveDate"] as DateTime).difference(DateTime.now()).inMinutes<=0));
      (oldData[11] as List).forEach((OldData) {
        (NewData[11] as List).forEach((NewData) {
          if(OldData['coin']==NewData['coin']){
            NewData['saveDate']=OldData['saveDate'];
          }
        });
      });
    } else {
      print("EMPTY");
    }
    await box.put("NewCashBox", NewData);

    print("Сохранено в нов кеш "+NewData[11].length.toString()+" пар ");

  }

  void clearCashNew() async{
    var box = await Hive.openBox("CashNew");
    box.clear();
  }

  Future<List<dynamic>> getCashNew() async{

    var box = await Hive.openBox("CashNew");
    if(box.isEmpty) {
      print("Return Empty box");
      return [];
    }
    var boxData = await box.get("NewCashBox");
    print("getCashNew data"+boxData.toString());

    if(boxData.isEmpty) {
      print("Return Empty box");
      return [];
    }

    // Обратная конвертация в чарт дату
    (boxData[11] as List).forEach((element) {

      List<ChartData> GraphDataToChange=[];
      for(int e=0;e<element['graphDataAdapted'].length;e++) {
        var Xdata=element['graphDataAdapted'][e][0];
        var Ydata=element['graphDataAdapted'][e][1];

        GraphDataToChange.add(ChartData(Xdata, Ydata));
      }
      (element as Map)['graphData']=GraphDataToChange;
    });

    print("OldCashListng "+boxData[11].toString());

    return boxData;

  }

  deleteCashNew() async{
    var box = await Hive.openBox("CashNew");
    await box.clear(); print("Данные удалены");
  }

  saveCashOfPair(data) async{

    print("Saved Cash "+data.toString());
    var box = await Hive.openBox("CashPairsBox");
    await box.put("CashBox", data);

    print("Кеш сохранен");
  }

  Future<List<dynamic>> getCashPairs() async{

    var box = await Hive.openBox("CashPairsBox");
    if(box.isEmpty) { return []; }
    var boxData=await box.get("CashBox");
    (boxData[11] as List).removeWhere((element) => (DateTime.now().compareTo((element["saveDate"] as DateTime))==1));
    (boxData[11] as List).forEach((element) {
      element['newcard']=0;
    });
    print("getCashPairs "+boxData[11].toString());

    return boxData.toList(growable: true);
  }

  saveDataHive(data) async{

    var box = await Hive.openBox("Data");
    await box.put("DataFirst", data);

    print("Данные сохранены");
  }

  saveListingCoins(data) async{

    var oldData=await getListingCoins();
    print("Data до проверки на идентичность "+data.length.toString());
    print("Монеты из памяти "+oldData.length.toString());
    print("Data до проверки на идентичность "+data.toString());
    print("Монеты из памяти "+oldData.toString());
    if (oldData.isNotEmpty&&oldData.length!=data.length){
      print("DTT "+data.length.toString());
      oldData.forEach((oldelement) {
        if((data as List).isNotEmpty){
          // (data as List).removeWhere((element) => element["coin"]==oldelement["coin"]);
        }
        print("DT "+data.length.toString());
      });
      (data as List).add(oldData);
    }
    print("Data после проверки "+data.length.toString());

    // Сохранение новых монет в листинг
    var box = await Hive.openBox("Listing");
    await box.put("ListingData", data);

    print("Листинг значения сохранен");
  }

  Future<List<dynamic>> getListingCoins() async{

    // Сохранение новых монет в листинг
    var box = await Hive.openBox("Listing");
    if(box.isEmpty) { return []; }
    var data = await box.get("ListingData");
    print("Стек монет в листинге "+data.toString());
    print("Длина монет в листинге "+data.length.toString());
    return data;

    print("Листинг значения сохранен");
  }

  saveDataListing(data,time) async{

    var box = await Hive.openBox("Listing");
    await box.put("Listing "+time.toString(), data);

    print("Листинг старые значения сравнения сохранен");
  }

  saveDataListing2(data) async{

    var box = await Hive.openBox("Listing 2");
    await box.put("Listing data 4", data);

    print("Листинг 2 сохранен");
  }

  deleteDataListing() async{

    var box = await Hive.openBox("Listing");
    await box.clear();

    print("Листинг удален");
  }

  checkDataListing() async{

    var box = await Hive.openBox("Listing");
    print(box.values.length.toString());
  }

  Future<List<dynamic>> getDataListing() async{

    var box = await Hive.openBox("Listing");
    if(box.isEmpty) { return []; }
    // print(box.values.toList(growable: true));

    return box.values.toList(growable: true);
  }

  getDataListing2() async{

    print("getDataListing2() ");
    var box = await Hive.openBox("Listing 2");

    return box.values.toList(growable: true);
  }

  addDataHive(data) async{

    var box = await Hive.openBox("Data");
    await box.put("DataFirst", data);
    await box.close();

    print("Данные сохранены");
  }

  Future<List<dynamic>> getDataHive() async{

    var box = await Hive.openBox("Data");
    if(box.isEmpty) {
      return [];
    }
    var boxData=await box.get("DataFirst");
    var boxDataEmpty=await boxData.isEmpty;

    return boxData;
  }

  deleteDataHive() async{
    var box = await Hive.openBox("Data");
    var boxData=await box.get("DataFirst");
    print("Данные удалены");

    box.clear();
  }

  checkDataHive() async{

    var box = await Hive.openBox("Data");
    var boxData=await box.get("DataFirst");
    print("Длина   :  "+boxData.length.toString());
    print("boxData[0](Менеты)   :  "+boxData[0].toString().substring(0,30)+"...");
    print("boxData[1](Цены)     :  "+boxData[1].toString().substring(0,30)+"...");
    print("boxData[1](Длина)    :  "+boxData[1].length.toString());
    print("boxData[2](Проценты) :  "+boxData[2].toString().substring(0,30)+"...");
    print("boxData[4](Время)    :  "+boxData[4].toString());
    print("boxData[5]           :  "+boxData[5].toString());
    print("boxData[6]           :  "+boxData[6].toString());
    print("boxData[7]           :  "+boxData[7].toString());
    await box.close();

  }


}

