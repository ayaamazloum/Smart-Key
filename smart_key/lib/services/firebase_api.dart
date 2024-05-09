import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:logger/logger.dart';

Logger logger = Logger();

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  logger.i('Title ${message.notification?.title}');
  logger.i('Body ${message.notification?.body}');
  logger.i('Payload ${message.data}');
}

class FirebaseApi {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await firebaseMessaging.requestPermission();
    final fCMToken = await firebaseMessaging.getToken();
    logger.i('token: $fCMToken');

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage());
  }
}
