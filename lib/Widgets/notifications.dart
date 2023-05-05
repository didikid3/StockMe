import 'package:first_proj/models/user_notification.dart';
import 'package:flutter/material.dart';

class Notifications extends StatefulWidget{
  final UserNotification notifications;
  const Notifications({super.key, required this.notifications});

  @override
  State<StatefulWidget> createState() => NotificationsState();

}

class NotificationsState extends State<Notifications>{

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            Divider(
              color: Colors.grey,
              thickness: 5,
              height: 15,
              indent: MediaQuery.of(context).size.width * .3,
              endIndent: MediaQuery.of(context).size.width * .3,
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                const Text("Notifications",
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.blue,
                  )),
                const Spacer(),
                Switch(
                    value: widget.notifications.getState(),
                    onChanged: (value){
                      setState(() {
                        widget.notifications.setState(value);
                      });
                    },
                    activeTrackColor: Colors.blue,
                    activeColor: Colors.purple,
                )

              ],
            ),
          ],
        ),
      ),
    );
  }

}
