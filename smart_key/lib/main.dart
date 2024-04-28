import 'package:flutter/material.dart';
import 'package:smart_key/screens/login_screen.dart';
import 'package:smart_key/screens/home_screen.dart';

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
          seedColor: const Color(0xFF53BC9D),
          primary: const Color(0xFF53BC9D),
          secondary: const Color(0xFF373737),
          tertiary: const Color(0xFFFEDF57),
        ),
        textTheme: TextTheme(
          headlineLarge: TextStyle(
            color: const Color(0xFF373737),
            fontFamily: 'Niramit',
            fontSize: 22,
          ),
          bodyMedium: TextStyle(
            color: const Color(0xFF373737),
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
