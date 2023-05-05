import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Widgets/bouncing_button.dart';
import 'my_textfield.dart';

class PopupMenuContent extends StatefulWidget {
  final Offset position;
  final Size size;
  final ValueChanged<String>? onAction;
  final Function getUpdates;
  const PopupMenuContent({Key? key,required this.position, required this.size, this.onAction, required this.getUpdates}) : super(key: key);

  @override
  PopupMenuContentState createState() => PopupMenuContentState();
}

class PopupMenuContentState extends State<PopupMenuContent> with SingleTickerProviderStateMixin{
  //Let's create animation
  late AnimationController _animationController;
  late Animation<double> _animation;

  final stockTickers = TextEditingController();

  @override
  void initState() {
    _animationController = AnimationController(vsync: this,duration: const Duration(milliseconds: 200));
    _animation = Tween<double>(begin: 0.0,end: 1.0).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOut));
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        _closePopup("");
        return false;
      },
      child: GestureDetector(
        onTap: ()=> _closePopup(""),
        child: Material(
          type: MaterialType.transparency,
          child: Container(
            height: double.maxFinite,
            width: double.maxFinite,
            color: Colors.transparent,
            child: Stack(
              children: [
                Positioned(
                  left:(MediaQuery.of(context).size.width - widget.position.dx) + widget.size.width,
                  right: (MediaQuery.of(context).size.width - widget.position.dx) + widget.size.width - 10,
                  top: MediaQuery.of(context).size.height/10,

                  child: AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child){
                          return Transform.scale(
                            scale: _animation.value,
                            alignment: Alignment.topRight,
                            child: Opacity(opacity: _animation.value,child: child),
                          );},
                        child:
                        GestureDetector(
                          onTap: (){},
                          child: Container(
                            width: double.maxFinite,
                            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                            margin: const EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                                color: Colors.grey[800],
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(.1),
                                    blurRadius: 8,
                                  )
                                ]
                            ),
                            child:
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children:[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      BouncingButton(text: "Add Stock", onPressed: addStock,
                                              color: Colors.green.shade600,
                                              buttonColor: Colors.grey.shade700,),
                                      const SizedBox(width: 12,),
                                      BouncingButton(text: "Remove Stock", onPressed: removeStock,
                                              color: Colors.red.shade400,
                                              buttonColor: Colors.grey.shade700,),
                                    ],
                                  ),
                                  const SizedBox(height: 12,),
                                  MyTextField(
                                    controller: stockTickers,
                                    hintText: 'Stock Ticker',
                                    obscureText: false,
                                  ),
                              ])
                )),
                  ))],
            ),
          ),
        ),
      ),
    );
  }

  void addStock(){
    String username = "Default";
    String stockList = "";
    final currentUser = FirebaseAuth.instance.currentUser;

    if(currentUser != null) {
      username = currentUser.email.toString();
    }

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference documentReference = firestore.collection("users").
    doc(username);
    documentReference.get().then((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        print('here');
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        stockList = data["Stock List"];

        if(stockList.substring(stockList.length - 1) != " "){
          stockList += " ";
        }
        List<String> adding = stockTickers.text.split(" ");
        for (String add in adding){
          if(!stockList.contains(add)){
            stockList += add;
          }
        }

        data['Stock List'] = stockList;

        documentReference.set(data)
            .then(widget.getUpdates());

        } else {
      }
      });

  }

  void removeStock(){
    String username = "Default";
    String stockList = "";
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

        List<String> removing = stockTickers.text.split(" ");
        for (String remove in removing){
          stockList = stockList.replaceAll(remove, "");
        }
        stockList = stockList.replaceAll("  ", " ");

        if(stockList.startsWith(" ")){
            stockList = stockList.substring(1);
        }

        if(stockList.endsWith(" ")){
          stockList = stockList.substring(0, stockList.length - 1);
        }

        data['Stock List'] = stockList;

        documentReference.set(data)
            .then(widget.getUpdates());


      } else {  }
    });
  }

  void _closePopup(String action) {
    _animationController.reverse().whenComplete((){
      Navigator.of(context).pop();

      if(action.isNotEmpty) widget.onAction?.call(action);
    });
  }
}