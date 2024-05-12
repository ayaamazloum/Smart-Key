import 'package:flutter/material.dart';
import 'package:smart_key/classes/notification.dart';
import 'package:smart_key/utils/constants.dart';

class NotificationItem extends StatelessWidget {
  final MyNotification notification;

  const NotificationItem({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        border:
            Border(bottom: BorderSide(color: Colors.grey.shade300, width: 1)),
      ),
      child: Row(
        children: [
          Expanded(
              flex: 12,
              child:
                  Text(notification.text, style: TextStyle(fontSize: 15, color: notification.read ? secondaryColor : primaryColor))),
          Expanded(child: Container()),
          Align(
            alignment: Alignment.center,
            child: Expanded(
                flex: 4,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(notification.date,
                      style: TextStyle(color: Colors.grey, fontSize: 12)),
                )),
          ),
        ],
      ),
    );
  }
}
