import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

class SocketWidgets extends StatefulWidget {
  const SocketWidgets({Key? key}) : super(key: key);

  @override
  State<SocketWidgets> createState() => _SocketWidgetsState();
}

class _SocketWidgetsState extends State<SocketWidgets> {

  var coins22=['ETHBTC', 'LTCBTC', 'BNBBTC', 'NEOBTC', 'QTUMETH', 'EOSETH', 'SNTETH', 'BNTETH', 'BCCBTC', 'GASBTC', 'BNBETH', 'BTCUSDT', 'ETHUSDT', 'HSRBTC', 'OAXETH', 'DNTETH', 'MCOETH', 'ICNETH', 'MCOBTC', 'WTCBTC', 'WTCETH', 'LRCBTC', 'LRCETH', 'QTUMBTC', 'YOYOBTC', 'OMGBTC', 'OMGETH', 'ZRXBTC', 'ZRXETH', 'STRATBTC', 'STRATETH', 'SNGLSBTC', 'SNGLSETH', 'BQXBTC', 'BQXETH', 'KNCBTC', 'KNCETH'];
  var coins=['BNBBUSD', 'BTCBUSD', 'XRPBUSD', 'ETHBUSD', 'BCHABCBUSD', 'LTCBUSD', 'LINKBUSD', 'ETCBUSD', 'TRXBUSD', 'EOSBUSD', 'XLMBUSD', 'ADABUSD', 'BCHBUSD', 'QTUMBUSD', 'VETBUSD', 'EURBUSD', 'BULLBUSD', 'BEARBUSD', 'ETHBULLBUSD', 'ETHBEARBUSD', 'ICXBUSD', 'BTSBUSD', 'BNTBUSD', 'ATOMBUSD', 'DASHBUSD', 'NEOBUSD', 'WAVESBUSD', 'XTZBUSD', 'EOSBULLBUSD', 'EOSBEARBUSD', 'XRPBULLBUSD', 'XRPBEARBUSD', 'BATBUSD', 'ENJBUSD', 'NANOBUSD', 'ONTBUSD', 'RVNBUSD', 'STRATBUSD', 'AIONBUSD', 'ALGOBUSD', 'BTTBUSD', 'TOMOBUSD', 'XMRBUSD', 'ZECBUSD', 'BNBBULLBUSD', 'BNBBEARBUSD', 'DATABUSD', 'SOLBUSD', 'CTSIBUSD', 'ERDBUSD', 'HBARBUSD', 'MATICBUSD', 'WRXBUSD', 'ZILBUSD', 'KNCBUSD', 'REPBUSD', 'LRCBUSD', 'IQBUSD', 'GBPBUSD', 'DGBBUSD', 'COMPBUSD', 'BKRWBUSD', 'SXPBUSD', 'SNXBUSD', 'VTHOBUSD', 'DCRBUSD', 'STORJBUSD', 'IRISBUSD', 'MKRBUSD', 'DAIBUSD', 'RUNEBUSD', 'MANABUSD', 'DOGEBUSD', 'LENDBUSD', 'ZRXBUSD', 'AUDBUSD', 'FIOBUSD', 'AVABUSD', 'IOTABUSD', 'BALBUSD', 'YFIBUSD', 'BLZBUSD', 'KMDBUSD', 'JSTBUSD', 'SRMBUSD', 'ANTBUSD', 'CRVBUSD', 'SANDBUSD', 'OCEANBUSD', 'NMRBUSD', 'DOTBUSD', 'LUNABUSD', 'IDEXBUSD', 'RSRBUSD', 'PAXGBUSD', 'WNXMBUSD', 'TRBBUSD', 'BZRXBUSD', 'SUSHIBUSD', 'YFIIBUSD', 'KSMBUSD', 'EGLDBUSD', 'DIABUSD', 'BELBUSD', 'SWRVBUSD', 'WINGBUSD', 'CREAMBUSD', 'UNIBUSD', 'AVAXBUSD', 'FLMBUSD', 'CAKEBUSD', 'XVSBUSD', 'ALPHABUSD', 'VIDTBUSD', 'AAVEBUSD', 'NEARBUSD', 'FILBUSD', 'INJBUSD', 'AERGOBUSD', 'ONEBUSD', 'AUDIOBUSD', 'CTKBUSD', 'BOTBUSD', 'KP3RBUSD', 'AXSBUSD', 'HARDBUSD', 'DNTBUSD', 'CVPBUSD', 'STRAXBUSD', 'FORBUSD', 'UNFIBUSD', 'FRONTBUSD', 'BCHABUSD', 'ROSEBUSD', 'SYSBUSD', 'HEGICBUSD', 'PROMBUSD', 'SKLBUSD', 'COVERBUSD', 'GHSTBUSD', 'DFBUSD', 'JUVBUSD', 'PSGBUSD', 'BTCSTBUSD', 'TRUBUSD', 'DEXEBUSD', 'USDCBUSD', 'TUSDBUSD', 'PAXBUSD', 'CKBBUSD', 'TWTBUSD', 'LITBUSD', 'SFPBUSD', 'FXSBUSD', 'DODOBUSD', 'BAKEBUSD', 'UFTBUSD', 'BANDBUSD', 'GRTBUSD', 'IOSTBUSD', 'OMGBUSD', 'REEFBUSD', 'ACMBUSD', 'AUCTIONBUSD', 'PHABUSD', 'TVKBUSD', 'BADGERBUSD', 'FISBUSD', 'OMBUSD', 'PONDBUSD', 'DEGOBUSD', 'ALICEBUSD', 'CHZBUSD', 'BIFIBUSD', 'LINABUSD', 'PERPBUSD', 'RAMPBUSD', 'SUPERBUSD', 'CFXBUSD', 'XVGBUSD', 'EPSBUSD', 'AUTOBUSD', 'TKOBUSD', 'TLMBUSD', 'BTGBUSD', 'HOTBUSD', 'MIRBUSD', 'BARBUSD', 'FORTHBUSD', 'BURGERBUSD', 'SLPBUSD', 'SHIBBUSD', 'ICPBUSD', 'ARBUSD', 'POLSBUSD', 'MDXBUSD', 'MASKBUSD', 'LPTBUSD', 'NUBUSD', 'RLCBUSD', 'CELRBUSD', 'ATMBUSD', 'ZENBUSD', 'FTMBUSD', 'THETABUSD', 'WINBUSD', 'KAVABUSD', 'XEMBUSD', 'ATABUSD', 'GTCBUSD', 'TORNBUSD', 'COTIBUSD', 'KEEPBUSD', 'SCBUSD', 'CHRBUSD', 'STMXBUSD', 'HNTBUSD', 'FTTBUSD', 'DOCKBUSD', 'ERNBUSD', 'KLAYBUSD', 'UTKBUSD', 'IOTXBUSD', 'BONDBUSD', 'MLNBUSD', 'LTOBUSD', 'ADXBUSD', 'QUICKBUSD', 'C98BUSD', 'CLVBUSD', 'QNTBUSD', 'FLOWBUSD', 'XECBUSD', 'MINABUSD', 'RAYBUSD', 'FARMBUSD', 'ALPACABUSD', 'ORNBUSD', 'MBOXBUSD', 'WAXPBUSD', 'TRIBEBUSD', 'GNOBUSD', 'MTLBUSD', 'OGNBUSD', 'POLYBUSD', 'DYDXBUSD', 'ELFBUSD', 'USDPBUSD', 'GALABUSD', 'SUNBUSD', 'ILVBUSD', 'RENBUSD', 'YGGBUSD', 'STXBUSD', 'FETBUSD', 'ARPABUSD', 'LSKBUSD', 'FIDABUSD', 'DENTBUSD', 'AGLDBUSD', 'RADBUSD', 'HIVEBUSD', 'STPTBUSD', 'BETABUSD'];
  var coins2=[];
  var coinLink="";

  void prepare() {
    coins.forEach((element) {
      element=element.toLowerCase();
      print(element.toLowerCase());
    });
    print(coins);

    setState(() {
      coins.forEach((element) {
        element=element.toLowerCase();
        print(element.toLowerCase());
      });
    });
  }

  @override
  initState(){

    print("State");
    coins.forEach((element) {
      coins2.add(element.toLowerCase()+"@kline_5m/");
    });

    for(int i = 0;i<coins2.length;i++) {
      if(i==0){
        coins2[i]=coins[i].toLowerCase()+"@kline_5m";
        coinLink=coinLink+coins[i].toLowerCase()+"@kline_5m";
      } else {
        coins2[i]="/"+coins[i].toLowerCase()+"@kline_5m";
        coinLink=coinLink+"/"+coins[i].toLowerCase()+"@kline_5m";
      }
    }
    setState(() {

    });

    var channel = IOWebSocketChannel.connect(Uri.parse('wss://stream.binance.com:9443/stream?streams=$coinLink'));
    channel.stream.listen((message) {
      print(message.toString());
      print("message type "+message.runtimeType.toString());
    });

  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Title"),
      ),
      body: Container(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [

            Text("coinLink "+coinLink.toString()),
            SizedBox(height: 16,),
            ElevatedButton(onPressed: (){
              print("State");
              coins.forEach((element) {
                coins2.add(element.toLowerCase()+"@kline_5m/");
              });

              for(int i = 0;i<coins2.length;i++) {
                if(i==0){
                  coins2[i]=coins[i].toLowerCase()+"@kline_5m";
                  coinLink=coinLink+coins[i].toLowerCase()+"@kline_5m";
                } else {
                  coins2[i]="/"+coins[i].toLowerCase()+"@kline_5m";
                  coinLink=coinLink+"/"+coins[i].toLowerCase()+"@kline_5m";
                }
              }
              setState(() {

              });

              var channel = IOWebSocketChannel.connect(Uri.parse('wss://stream.binance.com:9443/stream?streams=$coinLink'));
              channel.stream.listen((message) {
                // var data=jsonDecode(message);
                print(("Symbol: "+jsonDecode(message)['data']['s'].toString()+" Price:"+jsonDecode(message)['data']['k']['l'].toString()).toString());
                // print((jsonDecode(message)).toString());

              });
            },
                child: Text("Go"))
          ],
        )
      ),
    );
  }
}
