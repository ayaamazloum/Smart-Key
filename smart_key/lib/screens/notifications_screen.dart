import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:smart_key/classes/notification.dart';
import 'package:smart_key/main.dart';
import 'package:smart_key/services/api.dart';
import 'package:smart_key/utils/constants.dart';
import 'package:smart_key/widgets/notification_item.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => NotificationsScreenState();
}

class NotificationsScreenState extends State<NotificationsScreen> {
  List<MyNotification> notifications = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    fetchNotifications();
  }

  void fetchNotifications() async {
    final result = await API(context: navigatorKey.currentContext!)
        .sendRequest(route: '/notifications', method: 'get');
    final response = jsonDecode(result.body);

    setState(() {
      isLoading = false;
    });

    if (response['status'] == 'success') {
      setState(() {
        notifications = parseNotifications(result.body);
        notifications = notifications.reversed.toList();
      });
    } else {
      final errorMessage = response['message'];
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(
          content: Text(
            errorMessage,
            style: TextStyle(fontSize: 12, color: Colors.red.shade800),
          ),
          backgroundColor: Colors.grey.shade200,
          elevation: 30,
        ),
      );
    }
  }

  List<MyNotification> parseNotifications(String responseBody) {
    final parsed =
        jsonDecode(responseBody)['notifications'].cast<Map<String, dynamic>>();
    return parsed
        .map<MyNotification>((json) => MyNotification.fromJson(json))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: screenHeight(context),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                child: Image.asset(
                  'assets/images/screen_shape_1.png',
                  width: screenWidth(context) * 0.35,
                  fit: BoxFit.contain,
                ),
              ),
              Positioned(
                top: screenHeight(context) * 0.04,
                left: 10,
                child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Positioned(
                top: screenHeight(context) * 0.04,
                left: (screenWidth(context) - screenWidth(context) * 0.39) / 2,
                child: Text(
                  'Notifications',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth(context) * 0.05,
                  vertical: screenHeight(context) * 0.04,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: screenHeight(context) * 0.12),
                    Expanded(
                      child: isLoading
                          ? Center(child: CircularProgressIndicator())
                          : notifications.isEmpty
                              ? Center(child: Text('No notifications.'))
                              : ListView.builder(
                                  itemCount: notifications.length,
                                  itemBuilder: (context, index) {
                                    return NotificationItem(
                                      notification: notifications[index],
                                    );
                                  },
                                ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
