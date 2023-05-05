import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import '../models/stock.dart';

//StockPage needs to be updated
//everytime the stock price changes
class StockPage extends StatefulWidget{
  List<Stock> stocks;
  StockPage({super.key,
            required this.stocks});

  @override
  Graph createState() => Graph();

}

class Graph extends State<StockPage>{
  late List<Stock> stocks = widget.stocks;
  late Timer _timer;

  @override
  void initState(){
    super.initState();
    getUpdates();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      getUpdates();
      setState(() {
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  /*
  --------------
  The following code is used to extract data on a stock ticker
  --------------
   */
  void getData(String ticker, Stock stock){
    String result = "";
    String url = 'https://finance.yahoo.com/quote/$ticker';

    http.get(Uri.parse(url),)
        .then((response){
      String splitter = "\"$ticker\"";
      final split = response.body.split(splitter);
      result = split[3] + split[4] + split[5];

      getPrice(result, stock);
      getChange(result, stock);
      if(stock.getComp() != null) {
        getName(response.body, stock);
      }
      setState(() {});
    });
  }
  void getName(String data, Stock stock){
    data = data.split("D(ib) Fz(18px)")[1];
    data = data.split(">")[1];
    data = data.split(" (")[0];
    stock.setName(data);
  }
  void getPrice(String data, Stock stock){
    data = data.split("regularMarketPrice")[1];
    data = data.split("value")[1];
    data = data.split("\"")[1];
    stock.setPrice(double.parse(data));
  }
  void getChange(String data, Stock stock){
    String changePercent = getChangePercent(data);
    data = data.split("regularMarketChange")[1];
    data = data.split("class")[1];
    data = data.split(">")[1].split("<")[0];
    stock.setChange(data + changePercent);
  }
  String getChangePercent(String data){
    data = data.split("regularMarketChangePercent")[1];
    data = data.split("class")[1];
    data = data.split(">")[1].split("<")[0];
    return data;
  }
  /*
  --------------
  End of Stock Information Functions
  --------------
   */


  //Asks server to get data for specific stock
  void tryUpdate(String ticker, Stock stock){
    getData(ticker, stock);
  }

  //Update Entire List of Stocks
  void getUpdates() {

    for (var stock in stocks){
      tryUpdate(stock.symbol, stock);
    }

  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.black,
        body: ListView.separated(
          separatorBuilder: (context, index){
            return Divider(color: Colors.grey[400]);
          },
          itemCount: stocks.length,
          itemBuilder: (context, index) {
            final stock = stocks[index];

            return ListTile(
              contentPadding: const EdgeInsets.all(10),
              title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(stock.symbol,
                        style: const TextStyle(color: Colors.white,
                            fontSize: 24, fontWeight: FontWeight.w500)),
                    Text(stock.company.toString(),
                        style: const TextStyle(color: Colors.grey,
                            fontSize: 20)),
                  ]),
              trailing: Column(children: <Widget>[
                Text("\$${stock.price}",
                    style: const TextStyle(color: Colors.white,
                        fontSize: 24, fontWeight: FontWeight.w500)),
                Container(
                  width: 100,
                  height: 25,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: stock.change.toString().contains('-') ? Colors.red : Colors.green
                  ),
                  child: Text(stock.change.toString(),
                      style: const TextStyle(color: Colors.white)
                  ),
                )
              ]),
            );
          },
        )
    );

    /*
    return Scaffold(
      body: Center(child: Container(
        padding: const EdgeInsets.only(left:20, right:20),
        width: MediaQuery.of(context).size.width,
        child: LineChart(stockData))
      )
    );

     */

  }


// const Map<String, String> header =
// {
//   "x-rapidapi-key": "f05a259559msh2fd94bdea399a72p1530f5jsn9bf7da38bdb1",
//   "x-rapidapi-host": "yh-finance.p.rapidapi.com",
// };
//
// for(var stock in stocks) {
//   String authority = "https://yh-finance.p.rapidapi.com/market/v2/get-quotes?"
//       "region=US&symbols=${stock.symbol}";
//   var testResponse = await http.get(Uri.parse(authority), headers: header);
//
//   if (testResponse.statusCode == 200) {
//    try {
//       YahooResponse testData = yahooResponseFromJson(testResponse.body);
//       //jsonDecode(testResponse.body);
//       stock.price = testData.quoteResponse.result[0].regularMarketPrice;
//       setState(() { });
//     }
//     catch (e) {
//      print(e);
//      print(testResponse.body);
//      print("-----------");
//     }
//   }
//   else {
//     print("NO OK RESPONSE");
//   }
// }

//DEPRICATED, 500 API CALLS USED
//MAX 5 CALLS PER MIN
/*
    getAll();
    String apiKey = "0E49EYN00SFFCCLU";
    for (var stock in stocks) {
      String ticker = stock.symbol;
      String url = "https://www.alphavantage.co/query?"
          "function=TIME_SERIES_DAILY_ADJUSTED"
          "&symbol=$ticker"
          "&apikey=$apiKey";

      var response = await http.get(Uri.parse(url));
      if(response.statusCode == 200) {
        try {
          DailyStock stockData = dailyStockFromJson(response.body);
          var firstVar = stockData.timeSeriesDaily.values.first
              .the5AdjustedClose;
          stock.price = double.parse(firstVar);
        }
        catch (e){
          print(response.body);
        }
      }
      else{
        print("No OK HTTP Response");
      }

    }//END FOR

     */



//   LineChartData get stockData => LineChartData(
//     lineTouchData: lineTouchData2,
//     gridData: gridData,
//     titlesData: titlesData2,
//     borderData: borderData,
//     lineBarsData: lineBarsData2,
//   );
//
//   LineTouchData get lineTouchData2 => LineTouchData(
//     enabled: false,
//   );
//
//   FlGridData get gridData => FlGridData(show: false);
//
//   FlTitlesData get titlesData2 => FlTitlesData(
//     bottomTitles: AxisTitles(
//       sideTitles: bottomTitles,
//     ),
//     rightTitles: AxisTitles(
//       sideTitles: SideTitles(showTitles: false),
//     ),
//     topTitles: AxisTitles(
//       sideTitles: SideTitles(showTitles: false),
//     ),
//     leftTitles: AxisTitles(
//       sideTitles: leftTitles(),
//     ),
//   );
//
//   FlBorderData get borderData => FlBorderData(
//     show: true,
//     border: Border(
//       bottom:
//       BorderSide(color: Colors.black.withOpacity(0.2), width: 4),
//       left: const BorderSide(color: Colors.transparent),
//       right: const BorderSide(color: Colors.transparent),
//       top: const BorderSide(color: Colors.transparent),
//     ),
//   );
//
//   List<LineChartBarData> get lineBarsData2 => [
//     lineChartBarData2_2
//   ];
//
//   Widget bottomTitleWidgets(double value, TitleMeta meta) {
//     const style = TextStyle(
//       fontWeight: FontWeight.bold,
//       fontSize: 16,
//     );
//     Widget text;
//     switch (value.toInt()) {
//       case 2:
//         text = const Text('SEPT', style: style);
//         break;
//       case 7:
//         text = const Text('OCT', style: style);
//         break;
//       case 12:
//         text = const Text('DEC', style: style);
//         break;
//       default:
//         text = const Text('');
//         break;
//     }
//
//     return SideTitleWidget(
//       axisSide: meta.axisSide,
//       space: 10,
//       child: text,
//     );
//   }
//   Widget leftTitleWidgets(double value, TitleMeta meta) {
//     const style = TextStyle(
//       fontWeight: FontWeight.bold,
//       fontSize: 14,
//     );
//     String text;
//     switch (value.toInt()) {
//       case 1:
//         text = '1m';
//         break;
//       case 2:
//         text = '2m';
//         break;
//       case 3:
//         text = '3m';
//         break;
//       case 4:
//         text = '5m';
//         break;
//       case 5:
//         text = '6m';
//         break;
//       default:
//         return Container();
//     }
//
//     return Text(text, style: style, textAlign: TextAlign.center);
//   }
//   SideTitles get bottomTitles => SideTitles(
//     showTitles: true,
//     reservedSize: 32,
//     interval: 1,
//     getTitlesWidget: bottomTitleWidgets,
//   );
//   SideTitles leftTitles() => SideTitles(
//     getTitlesWidget: leftTitleWidgets,
//     showTitles: true,
//     interval: 1,
//     reservedSize: 40,
//   );
//
//
//   LineChartBarData get lineChartBarData2_2 => LineChartBarData(
//     isCurved: true,
//     color: Colors.pink.withOpacity(0.5),
//     barWidth: 4,
//     isStrokeCapRound: true,
//     dotData: FlDotData(show: false),
//     belowBarData: BarAreaData(
//       show: true,
//       color: Colors.pink.withOpacity(0.2),
//     ),
//     spots: chartSpots,
//   );
 }



