import 'package:flutter/material.dart';
import 'package:smart_key/screens/auth/login_screen.dart';
import 'package:smart_key/screens/auth/signup_screen.dart';
import 'package:smart_key/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_key/widgets/navigation_menu.dart';

void main() {
  runApp(const SmartKey());
}

class SmartKey extends StatefulWidget {
  const SmartKey({super.key});

  @override
  State<SmartKey> createState() => _SmartKeyState();
}

class _SmartKeyState extends State<SmartKey> {
  late SharedPreferences preferences;
  bool isLoading = false;
  bool isAuth = false;

  @override
  void initState() {
    super.initState();
    checkAuth();
  }

  void checkAuth() async {
    preferences = await SharedPreferences.getInstance();
    final token = preferences.getString('token');
    setState(() {
      isAuth = token != null;
  });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Key',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          primary: primaryColor,
          secondary: secondaryColor,
          tertiary: tertiaryColor,
        ),
        textTheme: TextTheme(
          headlineLarge: TextStyle(
            color: secondaryColor,
            fontFamily: 'Niramit',
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          bodyLarge: TextStyle(
            color: secondaryColor,
            fontFamily: 'Niramit',
            fontSize: 20,
          ),
          bodyMedium: TextStyle(
            color: secondaryColor,
            fontFamily: 'Niramit',
            fontSize: 18,
          ),
        ),
        useMaterial3: true,
      ),
      home: isAuth ? NavigationMenu() : LoginScreen(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/home': (context) => NavigationMenu(),
      },
    );
  }
}
