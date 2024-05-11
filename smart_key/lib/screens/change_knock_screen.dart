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
                    'The green circle represents the knock while the yellow one represents the break point. Press on the green or yellow circle to define the pattern. Add 6 knocks at least. Break points added at the beginning or the end are ignored.',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
