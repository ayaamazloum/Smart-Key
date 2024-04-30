import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_key/widgets/primary_button.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
        child: Column(
          children: [
            Text(
              'Settings',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            PrimaryButton(
                text: 'Logout',
                onPressed: () {
                  preferences.clear();
                  Navigator.pushReplacementNamed(context, '/login');
                })
          ],
        ),
      ),
    );
  }
}
