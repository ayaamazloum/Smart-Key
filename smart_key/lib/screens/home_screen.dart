import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_key/utils/constants.dart';
import 'package:logger/logger.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

const String mqttServer = 'test.mosquitto.org';
const int mqttPort = 1883;
const String doorControlTopic = 'door/control';
const String doorStatusTopic = 'door/status';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late SharedPreferences preferences;
  late MqttServerClient client;
  bool isLoading = false;
  String? firstName;
  String? profilePicture;
  String? userType;
  bool isHome = false;
  String doorStatus = "closed";

  final logger = Logger();

  @override
  void initState() {
    super.initState();

    getUserData();
    connectToMqttBroker();
  }

  void getUserData() async {
    setState(() {
      isLoading = true;
    });
    preferences = await SharedPreferences.getInstance();
    setState(() {
      firstName = preferences.getString('name')!.split(' ')[0];
      profilePicture = preferences.getString('profilePicture');
      userType = preferences.getString('userType');
      isHome = preferences.getBool('isHome')!;
      logger.i(profilePicture);
      isLoading = false;
    });
  }

  Future<dynamic> connectToMqttBroker() async {
    client = MqttServerClient.withPort(
        'test.mosquitto.org', 'SmartKeyFlutterClient', 1883);
    client.logging(on: true);
    client.keepAlivePeriod = 30;
    client.onDisconnected = () {
      logger.e('Disconnected');
    };
    client.onConnected = () {
      logger.i('MQTT Connected');
    };
    client.logging(on: true);
    client.onConnected = () {
      logger.i('MQTT_LOGS:: Connected');
    };
    client.onDisconnected = () {
      logger.i('MQTT_LOGS:: Disconnected');
    };
    client.onUnsubscribed = (String? topic) {
      logger.i('MQTT_LOGS:: Unsubscribed topic: $topic');
    };
    client.onSubscribed = (String topic) {
      logger.i('MQTT_LOGS:: Subscribed topic: $topic');
    };
    client.onSubscribeFail = (String topic) {
      logger.i('MQTT_LOGS:: Failed to subscribe $topic');
    };
    client.pongCallback = () {
      logger.i('MQTT_LOGS:: Ping response client callback invoked');
    };
    client.keepAlivePeriod = 60;
    client.logging(on: true);
    client.setProtocolV311();

    final connMess = MqttConnectMessage()
        .withClientIdentifier('SKFlutterClient')
        .withWillTopic('willtopic')
        .withWillMessage('Will message')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);

    logger.i('MQTT_LOGS::Mosquitto client connecting....');

    client.connectionMessage = connMess;

    try {
      await client.connect();
      logger.i('Connected to MQTT broker');
    } catch (e) {
      logger.e('Exception: $e');
      client.disconnect();
    }

    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      logger.i('MQTT_LOGS::Mosquitto client connected');
    } else {
      logger.e(
          'MQTT_LOGS::ERROR Mosquitto client connection failed - disconnecting, status is ${client.connectionStatus}');
      client.disconnect();
      return -1;
    }

    logger.i('MQTT_LOGS::Subscribing to the door/control topic');

    client.subscribe(doorStatusTopic, MqttQos.atLeastOnce);
    client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
      final String message =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      setState(() {
        doorStatus = message;
      });
    });

    return client;
  }

  void publishMessage(String message) {
    const pubTopic = doorControlTopic;
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);

    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      client.publishMessage(pubTopic, MqttQos.atLeastOnce, builder.payload!);
    }
  }

  void sendControlMessage(String message) {
    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
      builder.addString(message);
      client.publishMessage(
          doorControlTopic, MqttQos.atLeastOnce, builder.payload!);
    } else {
      logger.e('MQTT client is not connected. Cannot send control message.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Stack(
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
                  Container(
                    padding: EdgeInsets.only(
                        left: screenWidth(context) * 0.05,
                        right: screenWidth(context) * 0.05,
                        top: screenHeight(context) * 0.05),
                    child: ListView(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            profilePicture == null
                                ? SizedBox(width: 0)
                                : Expanded(
                                    flex: 2,
                                    child: Container(
                                      margin: EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: primaryColor,
                                          width: 2,
                                        ),
                                      ),
                                      child: ClipOval(
                                        child: Image.network(
                                          '$serverImagesUrl/${preferences.getString('profilePicture')}',
                                          width: screenWidth(context) * 0.2,
                                          loadingBuilder: (context, child,
                                              loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            }
                                            return CircularProgressIndicator(
                                              value: loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes!
                                                  : null,
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                            Expanded(
                              flex: 12,
                              child: Text(
                                'Hi, $firstName',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed('/notifications');
                                },
                                child: Icon(
                                  Icons.notifications_none_outlined,
                                  color: primaryColor,
                                  size: screenWidth(context) * 0.08,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight(context) * 0.05),
                        userType == 'owner'
                            ? GestureDetector(
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed('/homeMembers');
                                },
                                child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      'Members at home',
                                      style: TextStyle(color: primaryColor),
                                    )))
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'I\'m Home',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                  Transform.scale(
                                    scale: 0.55,
                                    child: Switch(
                                      value: isHome,
                                      onChanged: (val) {
                                        setState(() {
                                          isHome = val;
                                        });
                                      },
                                      activeColor: primaryColor,
                                      inactiveThumbColor: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                        SizedBox(height: screenHeight(context) * 0.05),
                        SizedBox(
                            height: screenHeight(context) * 0.45,
                            width: screenWidth(context),
                            child: Mjpeg(
                              stream: 'http://192.168.1.17:81/stream',
                              isLive: true,
                            )),
                        SizedBox(height: screenHeight(context) * 0.05),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              height: screenWidth(context) * 0.25,
                              width: screenWidth(context) * 0.25,
                              child: ElevatedButton(
                                onPressed: () {
                                  publishMessage(doorStatus == 'opened'
                                      ? 'close'
                                      : 'open');
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                          (states) {
                                    if (states
                                        .contains(MaterialState.pressed)) {
                                      return buttonPressColor;
                                    }
                                    return doorStatus == 'opened'
                                          ? tertiaryColor
                                          : primaryColor;
                                  }),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                  ),
                                  textStyle:
                                      MaterialStateProperty.all<TextStyle>(
                                    TextStyle(fontSize: 16.0),
                                  ),
                                  elevation:
                                      MaterialStateProperty.all<double>(4.0),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.sensor_door_outlined,
                                      color: Colors.white,
                                      size: 35,
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      doorStatus == 'opened' ? 'close' : 'open',
                                      style: TextStyle(
                                          fontFamily: 'Niramit',
                                          color: Colors.white,
                                          fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: screenWidth(context) * 0.25,
                              width: screenWidth(context) * 0.25,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                          (states) {
                                    if (states
                                        .contains(MaterialState.pressed)) {
                                      return buttonPressColor;
                                    }
                                    return primaryColor;
                                  }),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                  ),
                                  textStyle:
                                      MaterialStateProperty.all<TextStyle>(
                                    TextStyle(fontSize: 16.0),
                                  ),
                                  elevation:
                                      MaterialStateProperty.all<double>(4.0),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.fit_screen_outlined,
                                      color: Colors.white,
                                      size: 35,
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      'Capture',
                                      style: TextStyle(
                                          fontFamily: 'Niramit',
                                          color: Colors.white,
                                          fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
