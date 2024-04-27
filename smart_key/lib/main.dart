import 'package:flutter/material.dart';
import 'pages/tabs/home.dart';

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
          secondary: const Color(0xFF373737),
          tertiary: const Color(0xFFFEDF57),
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
