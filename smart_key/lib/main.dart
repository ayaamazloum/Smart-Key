import 'package:flutter/material.dart';
import 'screens/others/splash.dart';
import 'package:google_fonts/google_fonts.dart';

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
        textTheme: GoogleFonts.lexendTextTheme(),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
