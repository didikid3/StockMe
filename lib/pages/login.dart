import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_proj/services/auth_services.dart';
import 'package:flutter/material.dart';
import '../models/my_button.dart';
import '../models/my_textfield.dart';
import '../models/square_tile.dart';
import 'forgot_password.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text editing controllers
  final usernameController = TextEditingController();

  final passwordController = TextEditingController();

  // sign user in method
  void signUserIn() async{
    //Loading Circle
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
    );

    //Sign In
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: usernameController.text,
          password: passwordController.text
      );
      Navigator.pop(context);
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
                'Welcome back you\'ve been missed!',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 25),

              SizedBox(
                height: 200,
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
                    // forgot password?
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: (){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context){
                                        return const ForgotPasswordPage();
                                      },
                                  ),
                              );
                            },
                            child: const SizedBox(
                              height: 50,
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                              )),
                            ),
                          ),
                        ],
                      ),),
                  ],),),

              // sign in button
              MyButton(
                onTap: signUserIn,
                text: "Sign In",
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
                        'Not a member?',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    const SizedBox(width: 4),
                        const Text(
                          'Register now',
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