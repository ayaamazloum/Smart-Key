import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_key/utils/constants.dart';
import 'package:logger/logger.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Uint8List _videoFrame = Uint8List(0);
  late SharedPreferences preferences;
  bool isLoading = false;
  String? firstName;
  String? profilePicture;

  final logger = Logger();

  Future<void> _fetchVideoFrame() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      setState(() {
        _videoFrame = response.bodyBytes;
      });
    } else {
      throw Exception('Failed to fetch video frame');
    }
  }

  @override
  void initState() {
    super.initState();
    getUserData();

    _fetchVideoFrame();

    // Timer.periodic(Duration(milliseconds: 100), (timer) {
    //   _fetchVideoFrame();
    // });
  }

  void getUserData() async {
    setState(() {
      isLoading = true;
    });
    preferences = await SharedPreferences.getInstance();
    setState(() {
      firstName = preferences.getString('name')!.split(' ')[0];
      profilePicture = preferences.getString('profilePicture');
      isLoading = false;
    });
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
                            Expanded(
                              flex: 2,
                              child: Container(
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
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
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
                            SizedBox(width: screenWidth(context) * 0.03),
                            Expanded(
                              flex: 12,
                              child: Text(
                                'Hi, $firstName',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Icon(
                                Icons.notifications_none_outlined,
                                color: primaryColor,
                                size: screenWidth(context) * 0.08,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight(context) * 0.05),
                        GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed('/homeMembers');
                            },
                            child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  'Members at home',
                                  style: TextStyle(color: primaryColor),
                                ))),
                        SizedBox(height: screenHeight(context) * 0.05),
                        SizedBox(
                          height: screenHeight(context) * 0.45,
                          width: screenWidth(context),
                          child: _videoFrame.isNotEmpty
                              ? Image.memory(_videoFrame)
                              : CircularProgressIndicator(),
                        ),
                        SizedBox(height: screenHeight(context) * 0.05),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              height: screenWidth(context) * 0.25,
                              width: screenWidth(context) * 0.25,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          15.0),
                                    ),
                                  ),
                                  textStyle: MaterialStateProperty.all<TextStyle>(
                                    TextStyle(fontSize: 16.0),
                                  ),
                                  elevation: MaterialStateProperty.all<double>(
                                      4.0),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.sensor_door_outlined, color: Colors.white, size: 35,),
                                    SizedBox(height: 8,),
                                    Text('Open', style: TextStyle(fontFamily: 'Niramit', color: Colors.white, fontSize: 14),),
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
                                  backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          15.0),
                                    ),
                                  ),
                                  textStyle: MaterialStateProperty.all<TextStyle>(
                                    TextStyle(fontSize: 16.0),
                                  ),
                                  elevation: MaterialStateProperty.all<double>(
                                      4.0),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.fit_screen_outlined, color: Colors.white, size: 35,),
                                    SizedBox(height: 8,),
                                    Text('Capture', style: TextStyle(fontFamily: 'Niramit', color: Colors.white, fontSize: 14),),
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
