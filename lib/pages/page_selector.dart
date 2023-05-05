import 'package:first_proj/pages/account.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';

class App extends StatefulWidget{

  const App({super.key});

  @override
  AppState createState() => AppState();
}

class AppState extends State<App> {
  //final user = FirebaseAuth.instance.currentUser!;
  int currentIndex = 0;

  final List<Widget> screens =
  [
    const HomePage(),
    Account(),
  ];
  final List<BottomNavigationBarItem> bottomNavBarItems =
  [
    const BottomNavigationBarItem(
      icon: Icon(Icons.view_list_outlined),
      label: 'Watchlist',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.account_circle_sharp),
      label: 'Account',
    ),
  ];

  void onTapped(int index){
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build (BuildContext context){
    return Scaffold(
      body: Center(child: screens[currentIndex]),
      bottomNavigationBar:
        BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.black, // <-- This works for fixed
          selectedItemColor: Colors.greenAccent,
          unselectedItemColor: Colors.grey,
          items: bottomNavBarItems,
          currentIndex: currentIndex,
          onTap: onTapped,
        ),

    );
  }
}