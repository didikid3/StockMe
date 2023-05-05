import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/my_button.dart';
import '../models/my_textfield.dart';

class ChangePassword extends StatefulWidget{
  const ChangePassword({super.key});

  @override
  ChangePasswordState createState() => ChangePasswordState();

}

class ChangePasswordState extends State<ChangePassword>{
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final messageController = TextEditingController();


  void changePassword() async{
    final user = FirebaseAuth.instance.currentUser;
    bool email = false;
    String oldPassword = oldPasswordController.text;
    String newPassword = newPasswordController.text;

    if (user != null) {
      for (UserInfo userInfo in user.providerData) {

        if (userInfo.providerId == EmailAuthProvider.PROVIDER_ID) {
          email = true;
          AuthCredential credential = EmailAuthProvider.credential(
              email: user.email as String, password:oldPassword
          );
          try {
            await user.reauthenticateWithCredential(credential);
          } catch (error) {
            // If the old password is incorrect, an error will be thrown.
            messageController.text = 'Old Password Incorrect';
            return;
          }

          try {
            await user.updatePassword(newPassword);
            messageController.text = 'Password updated successfully';
          } catch (error) {
            messageController.text = 'Error Updating Password';
          }

        }
        if(!email){
          messageController.text = 'You did not sign up using email!';
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return
      Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Divider(
                  color: Colors.grey,
                  thickness: 5,
                  height: 15,
                  indent: MediaQuery.of(context).size.width * .3,
                  endIndent: MediaQuery.of(context).size.width * .3,
                ),
                const SizedBox(height: 15),
                Text(
                  'Change Password',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 25),

                SizedBox(
                  height: 180,
                  child:
                  ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    children: [

                      // password textfield
                      MyTextField(
                        controller: oldPasswordController,
                        hintText: 'Old Password',
                        obscureText: true,
                      ),
                      const SizedBox(height: 15),
                      MyTextField(
                        controller: newPasswordController,
                        hintText: 'New Password',
                        obscureText: true,
                      ),

                    ],
                  ),
                ),

                // sign in button
                MyButton(
                  onTap: changePassword,
                  text: "Change Password",
                ),

                const SizedBox(height: 25),
                TextField(
                      controller: messageController,
                      enabled: false,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: '',
                      ),
                  ),
              ],
            ),
          ),
        );
  }

  
}