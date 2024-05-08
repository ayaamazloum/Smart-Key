import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_key/utils/constants.dart';
import 'package:smart_key/widgets/primary_button.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  late SharedPreferences preferences;
  String? userType = '';

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      userType = preferences.getString('userType');
    });
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
            Container(
              padding: EdgeInsets.only(
                  left: screenWidth(context) * 0.05,
                  right: screenWidth(context) * 0.05,
                  top: screenHeight(context) * 0.04),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      'Settings',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    SizedBox(height: screenHeight(context) * 0.04),
                    PrimaryButton(
                        text: 'Logout',
                        onPressed: () {
                          preferences.clear();
                          Navigator.pushReplacementNamed(context, '/login');
                        })
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
