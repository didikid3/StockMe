import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_proj/Widgets/pop_up_window.dart';
import 'package:first_proj/pages/stock_list.dart';
import 'package:flutter/material.dart';

import '../models/stock.dart';


class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage>{
  int selectedIndex = 0;
  List<Stock> stocks = [];


  @override
  void initState() {
    super.initState();
    getAll();
  }

  @override
  void dispose() {
    super.dispose();
  }

  //Temporarily Populates a List of Genreic Test Stocks
  void getAll(){
    stocks.clear();
    String username = "Default";
    String stockList = "";
    List<String> split = [];
    final currentUser = FirebaseAuth.instance.currentUser;

    if(currentUser != null) {
      username = currentUser.email.toString();
    }

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference documentReference = firestore.collection("users").
                                              doc(username);

    documentReference.get().then((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        stockList = data["Stock List"];
        split = stockList.split(" ");
        for(String stock in split){
          stocks.add(Stock(stock));
        }

      } else {

      }
    });


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //     onPressed: (){},
        //     icon: const Icon(Icons.menu),
        // ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: PopupWindow(
              getUpdates: getAll,
              child: Icon(Icons.edit,
                        key:GlobalKey()),
            ),
          )

        ],
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
          child: Stack(children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  width: MediaQuery.of(context).size.width,
                  color: Colors.black,
                  child: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text("Watchlist",
                          style: TextStyle(color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold)),

                        Padding(
                            padding: const EdgeInsets.only(top: 3.0),
                            child:SizedBox(
                                  height: MediaQuery.of(context).size.height-212,
                                  child: StockPage(stocks: stocks)
                        )),
                      ],)
                  ),

                )
      ])),

    );
  }


}