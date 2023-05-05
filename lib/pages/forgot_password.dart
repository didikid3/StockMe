
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/my_textfield.dart';

class ForgotPasswordPage extends StatefulWidget{
  const ForgotPasswordPage({super.key});


  @override
  State<ForgotPasswordPage> createState() => ForgotPasswordPageState();
}

class ForgotPasswordPageState extends State<ForgotPasswordPage>{
  final usernameController = TextEditingController();


  void passwordReset() async{
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try
    {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: usernameController.text.trim());
      if(context.mounted)Navigator.of(context).pop();
      showDialog(context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              backgroundColor: Colors.deepPurpleAccent,
              title: const Center(
                  child: Text("Password reset link sent. Check your email.",
                      style: TextStyle(color: Colors.white)
                  )
              ),
            );
          });

    }
    on FirebaseAuthException catch (e){
      Navigator.pop(context);
      showDialog(context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              backgroundColor: Colors.deepPurpleAccent,
              title: Center(
                  child: Text(e.message.toString(),
                      style: const TextStyle(color: Colors.white)
                  )
              ),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Text(
                "Enter your account email, we'll send a link to reset your password.",
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
          )),
          const SizedBox(height: 25),
          MyTextField(
            controller: usernameController,
            hintText: 'Username',
            obscureText: false,
          ),
          const SizedBox(height: 25),
          GestureDetector(
            onTap: passwordReset,
            child: Container(
              padding: const EdgeInsets.all(25),
              margin: const EdgeInsets.symmetric(horizontal: 25),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  "Reset Password",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              ),
          ),
        ],
      )
    );
  }

}