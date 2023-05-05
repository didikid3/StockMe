import 'package:first_proj/pages/login.dart';
import 'package:first_proj/pages/register.dart';
import 'package:flutter/material.dart';

class LoginOrRegister extends StatefulWidget{
  const LoginOrRegister({super.key});
  @override
  LoginOrRegisterState createState() => LoginOrRegisterState();

}

class LoginOrRegisterState extends State<LoginOrRegister>{
  bool showLogin = true;

  void togglePages(){
    setState(() {
      showLogin = !showLogin;
    });
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if(showLogin){
      return LoginPage(onTap: togglePages);
    }
    else{
      return RegisterPage(onTap: togglePages);
    }
  }
  
}
