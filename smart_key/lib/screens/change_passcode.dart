import 'package:flutter/material.dart';
import 'package:smart_key/utils/constants.dart';
import 'package:logger/logger.dart';

class ChangePasscodeScreen extends StatelessWidget {
  ChangePasscodeScreen({super.key});

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
                left: (screenWidth(context) - screenWidth(context) * 0.53) / 2,
                child: Text('Change Passcode',
                    style: Theme.of(context).textTheme.headlineLarge)),
            ],
        ),
      ),
    );
  }
}
