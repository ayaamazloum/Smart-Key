import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_key/utils/constants.dart';
import 'package:smart_key/widgets/primary_button.dart';
import 'package:smart_key/widgets/settings_item.dart';

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
            Positioned(
              top: screenHeight(context) * 0.04,
              left: (screenWidth(context) - screenWidth(context) * 0.35) / 2,
              child: Text('Settings',
                            style: Theme.of(context).textTheme.headlineLarge)
            ),
            Container(
              padding: EdgeInsets.only(
                  left: screenWidth(context) * 0.05,
                  right: screenWidth(context) * 0.05,),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: screenHeight(context) * 0.1),
                    Column(children: [
                      Text('General',
                          style: Theme.of(context).textTheme.bodyMedium),
                      SizedBox(height: screenHeight(context) * 0.002),
                      SettingsItem(
                          icon: Icons.group_add_outlined,
                          title: 'Invitations',
                          route: ''),
                      SettingsItem(
                          icon: Icons.sensor_door_outlined,
                          title: 'Knock pattern',
                          route: ''),
                      SettingsItem(
                          icon: Icons.lock_open_outlined,
                          title: 'Change passcode',
                          route: ''),
                      SizedBox(height: screenHeight(context) * 0.02),
                      SingleChildScrollView(
                          child: Column(children: [
                        Text('Account',
                            style: Theme.of(context).textTheme.bodyMedium)
                      ])),
                      SizedBox(height: screenHeight(context) * 0.002),
                      SettingsItem(
                          icon: Icons.group_add_outlined,
                          title: 'Profile',
                          route: ''),
                      SettingsItem(
                          icon: Icons.lock_open_outlined,
                          title: 'Change password',
                          route: ''),
                      SizedBox(height: screenHeight(context) * 0.02),
                      SingleChildScrollView(
                          child: Column(children: [
                        Text('App',
                            style: Theme.of(context).textTheme.bodyMedium)
                      ])),
                      SizedBox(height: screenHeight(context) * 0.002),
                      SettingsItem(
                          icon: Icons.group_add_outlined,
                          title: 'Privacy policy',
                          route: ''),
                      SizedBox(height: screenHeight(context) * 0.02),
                      PrimaryButton(
                          text: 'Logout',
                          onPressed: () {
                            preferences.clear();
                            Navigator.pushReplacementNamed(context, '/login');
                          }),
                    ]),
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
