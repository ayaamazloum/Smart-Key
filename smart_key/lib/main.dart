import 'package:flutter/material.dart';
import 'package:smart_key/screens/login_screen.dart';
import 'package:smart_key/screens/home_screen.dart';
import 'package:smart_key/utils/constants.dart';

void main() {
  runApp(const SmartKey());
}

class SmartKey extends StatelessWidget {
  const SmartKey({super.key});

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
          bodyMedium: TextStyle(
            color: secondaryColor,
            fontFamily: 'Niramit',
            fontSize: 18,
          ),
        ),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
