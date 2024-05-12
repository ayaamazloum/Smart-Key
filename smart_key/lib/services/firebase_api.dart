import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';

Logger logger = Logger();

class FirebaseApi {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  final androidChannel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.defaultImportance,
  );

  final localNotifications = FlutterLocalNotificationsPlugin();

  void handleMessage(RemoteMessage? message) {
    // Navigator.pushNamed(navigatorKey.currentContext!, '/notifications');
  }

  Future initLocalNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);

    await localNotifications.initialize(settings,
        onDidReceiveNotificationResponse: (payload) {
      final message = RemoteMessage.fromMap(jsonDecode(payload.toString()));
      handleMessage(message);
    });

    final platform = localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(androidChannel);
  }

  Future initPushNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification == null) return;

      localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
              android: AndroidNotificationDetails(
                  androidChannel.id, androidChannel.name,
                  channelDescription: androidChannel.description,
                  icon: '@drawable/ic_launcher')),
          payload: jsonEncode(message.toMap()));
    });
  }

  Future<void> initNotifications() async {
    await firebaseMessaging.requestPermission();
    final fcmToken = await firebaseMessaging.getToken();
    logger.i('token: $fcmToken');

    initPushNotifications();
    initLocalNotifications();
    FirebaseMessaging.onMessage.listen(handleMessage);
  }

  Future<String?> getFcmToken() async {
    return await firebaseMessaging.getToken();
  }
}
