import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:smart_key/main.dart';
import 'package:smart_key/services/api.dart';
import 'package:smart_key/utils/constants.dart';
import 'package:smart_key/widgets/primary_button.dart';

class ChangeKnockScreen extends StatefulWidget {
  const ChangeKnockScreen({super.key});

  @override
  ChangeKnockScreenState createState() => ChangeKnockScreenState();
}

class ChangeKnockScreenState extends State<ChangeKnockScreen> {
  List<int> knockPattern = [];
  final logger = Logger();
  void changeKnock(BuildContext context) async {
    int countOnes = knockPattern.where((element) => element == 1).length;

    if (countOnes < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Secret knock must have at least 6 knocks(green circles).',
            style: TextStyle(fontSize: 12, color: Colors.red.shade800),
          ),
          backgroundColor: Colors.grey.shade200,
          elevation: 30,
        ),
      );
      return;
    }

    String newPattern = knockPattern.join('');
    newPattern = trimZeros(newPattern);

    final data = {
      'newPattern': newPattern,
    };

    logger.i(data.toString());

    final result = await API(context: context)
        .sendRequest(route: '/changeKnock', method: 'post', data: data);
    final response = jsonDecode(result.body);

    logger.i(response);

    if (response['status'] == 'success') {
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(
          content: Text(
            'Secret knock updated successfully.',
            style: TextStyle(fontSize: 12, color: primaryColor),
          ),
          backgroundColor: Colors.grey.shade200,
          elevation: 30,
        ),
      );
      Navigator.pop(navigatorKey.currentContext!);
      Navigator.pop(navigatorKey.currentContext!);
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

  String trimZeros(String input) {
    return input.replaceAll(RegExp('^0+|0+\$'), '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                left: (screenWidth(context) - screenWidth(context) * 0.43) / 2,
                child: Text('Secret Knock',
                    style: Theme.of(context).textTheme.headlineLarge)),
            Container(
              padding: EdgeInsets.only(
                left: screenWidth(context) * 0.05,
                right: screenWidth(context) * 0.05,
              ),
              margin: EdgeInsets.only(top: screenHeight(context) * 0.15),
              child: Column(
                children: [
                  Text(
                    'The green circle represents the knock while the yellow one represents the break point. Press on the green or yellow circle to define the pattern. Add 6 knocks at least. Break points added at the beginning or the end are ignored. Consecutive break points are considered as one',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenHeight(context) * 0.08),
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: knockPattern.map((value) {
                      return Container(
                        width: 20,
                        height: 20,
                        margin: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: value == 1 ? primaryColor : tertiaryColor,
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: screenHeight(context) * 0.08),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            knockPattern.add(1);
                          });
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: primaryColor,
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              knockPattern.add(0);
                            });
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: tertiaryColor,
                            ),
                          )),
                    ],
                  ),
                  SizedBox(height: screenHeight(context) * 0.08),
                  PrimaryButton(
                    text: 'Save',
                    onPressed: () {
                      changeKnock(context);
                    },
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
