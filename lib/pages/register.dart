import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_proj/services/auth_services.dart';
import 'package:flutter/material.dart';
import '../models/my_button.dart';
import '../models/my_textfield.dart';
import '../models/square_tile.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // sign user Up method
  void signUserUp() async{
    //Loading Circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    //Sign Up
    try {
      if(passwordController.text == confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: usernameController.text, password: passwordController.text);

        String username = "";
        final currentUser = FirebaseAuth.instance.currentUser;

        if(currentUser != null){
          username = currentUser.email.toString();
        }

        Map<String, dynamic> data = {
          'name': username,
          'Stock List': "AAPL ASC"
        };

        FirebaseFirestore firestore = FirebaseFirestore.instance;
        CollectionReference users = firestore.collection('users');

        users.doc(username).set(data)
            .then((value){});

        Navigator.pop(context);

      }
      else{
        Navigator.pop(context);
        alertUser("Passwords don't match!");
      }

    }
    //If incorrect sign in details, let user know what is wrong
    on FirebaseAuthException catch(e){
      Navigator.pop(context);

      //Wrong Email
      if(e.code == 'user-not-found'){
        alertUser("No Email Found");
      }

      //Wrong Password
      else if(e.code == 'wrong-password'){
        alertUser("Incorrect Password");
      }
    }

  }
  void alertUser(String alertMsg){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            backgroundColor: Colors.deepPurpleAccent,
            title:Center(
                child: Text(alertMsg,
                    style: const TextStyle(color: Colors.white)
                )),
          );
        });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),

              // logo
              const Icon(
                Icons.lock,
                size: 100,
              ),
              const SizedBox(height: 50),
              // welcome back, you've been missed!
              Text(
                'Let\'s create an account for you!',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 25),

              SizedBox(
                height: 250,
                child:
                ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  children: [
                    // username textfield
                    MyTextField(
                      controller: usernameController,
                      hintText: 'Username',
                      obscureText: false,
                    ),
                    const SizedBox(height: 10),
                    // password textfield
                    MyTextField(
                      controller: passwordController,
                      hintText: 'Password',
                      obscureText: true,
                    ),
                    const SizedBox(height: 10),
                    // Re-enter password textfield
                    MyTextField(
                      controller: confirmPasswordController,
                      hintText: 'Confirm Password',
                      obscureText: true,
                    ),
                  ],
                ),
              ),

              // sign in button
              MyButton(
                onTap: signUserUp,
                text: "Sign Up",
              ),

              const SizedBox(height: 50),

              // or continue with
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'Or continue with',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 50),

              // google + apple sign in buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // google button
                  SquareTile(
                      onTap: () => AuthService().signInWithGoogle(),
                      imagePath: 'lib/images/google.png'),
                ],
              ),

              const SizedBox(height: 50),

              // not a member? register now
              GestureDetector(
                onTap: widget.onTap,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        'Already have an account?',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    const SizedBox(width: 4),
                    const Text(
                          'Login now',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}