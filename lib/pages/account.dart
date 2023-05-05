import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_proj/Widgets/notifications.dart';
import 'package:first_proj/models/user_notification.dart';
import 'package:flutter/material.dart';

import '../Widgets/change_password.dart';

class Account extends StatelessWidget{
  late BuildContext context;
  Account({super.key});

  final UserNotification notifications = UserNotification();

  void signUserOut(){
    if(FirebaseAuth.instance.currentUser != null) {
      FirebaseAuth.instance.signOut();
    }
  }

  void notification(){
      showModalBottomSheet(
      isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        context: context,
        builder: (BuildContext context){
          return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.2,
              maxChildSize: 0.9,
              minChildSize: 0.1,
              builder: (context, scrollController) =>
                SingleChildScrollView(
                  child: Notifications(notifications: notifications,),
                ));
        },
    );
  }

  void passwordReset(){
    showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      context: context,
      builder: (BuildContext context){
        return DraggableScrollableSheet(
            expand: false,

            initialChildSize: 0.4,
            maxChildSize: 0.7,
            minChildSize: 0.1,
            builder: (context, scrollController) =>
              const SingleChildScrollView(
                  child: ChangePassword()),
            );
      },
    );
  }

  String accountName() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if(currentUser != null){
      String? tmp =  currentUser.displayName;
      if(tmp != null){
        return tmp;
      }
      else{
        return "Sign Up/Login";
      }
    }else{
      return "Sign Up/Login";
    }
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Account",
                  style: TextStyle(fontSize: 20),),
        centerTitle: true,
      ),
      body:
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column (
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("App Settings",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                            )),
                          const SizedBox(height: 30),
                          GestureDetector(
                            onTap: signUserOut,
                            child: Row(
                              children: const [
                                Icon(Icons.logout,
                                    color: Colors.white),
                                SizedBox(width: 10),
                                Text("Log Out",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    )),
                              ],
                            ),
                          ),
                          Divider(
                            color: Colors.grey,
                            thickness: 1,
                            height: 30,
                            indent: MediaQuery.of(context).size.width * .05,
                            endIndent: MediaQuery.of(context).size.width * .05,
                          ),
                          GestureDetector(
                            onTap: notification,
                            child: Row(
                              children: const [
                                Icon(Icons.notifications,
                                    color: Colors.white),
                                SizedBox(width: 10),
                                Text("Notifications",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    )),
                              ],
                            ),
                          ),
                          Divider(
                            color: Colors.grey,
                            thickness: 1,
                            height: 30,
                            indent: MediaQuery.of(context).size.width * .05,
                            endIndent: MediaQuery.of(context).size.width * .05,
                          ),
                          GestureDetector(
                            onTap: passwordReset,
                            child: Row(
                              children: const [
                                Icon(Icons.password_sharp,
                                    color: Colors.white),
                                SizedBox(width: 10),
                                Text("Change Password",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    )),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20)
                        ],
                      ),
                  ),

                  Divider(
                    color: Colors.white,
                    thickness: 3,
                    height: 50,
                    indent: MediaQuery.of(context).size.width * .05,
                    endIndent: MediaQuery.of(context).size.width * .05,
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Developer Settings",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              )),
                          const SizedBox(height: 15),
                          Row(
                            children: const [
                              Icon(Icons.developer_mode_outlined,
                                  color: Colors.white),
                              SizedBox(width: 10),
                              Text("Version",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  )),
                              Spacer(),
                              Text("V4 3.0.0",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  )),
                            ]
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                  ),
                  //
                  // Divider(
                  //   color: Colors.white,
                  //   thickness: 3,
                  //   height: 50,
                  //   indent: MediaQuery.of(context).size.width * .05,
                  //   endIndent: MediaQuery.of(context).size.width * .05,
                  // ),
                  //
                  // Container(
                  //   padding: const EdgeInsets.symmetric(horizontal: 30),
                  //   child: Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           const Text("Support",
                  //               style: TextStyle(
                  //                 color: Colors.white,
                  //                 fontSize: 25,
                  //                 fontWeight: FontWeight.bold,
                  //               )),
                  //           const SizedBox(height: 15),
                  //           Row(
                  //               children: const [
                  //                 Icon(Icons.question_answer,
                  //                     color: Colors.white),
                  //                 SizedBox(width: 10),
                  //                 Text("Support",
                  //                     style: TextStyle(
                  //                       color: Colors.white,
                  //                       fontSize: 18,
                  //                     )),
                  //               ]
                  //           ),
                  //
                  //         ],
                  //       ),
                  // ),
                ],
              ),
            ),

    );
  }

  
}