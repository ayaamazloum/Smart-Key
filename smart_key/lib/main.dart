import 'package:flutter/material.dart';
import 'package:smart_key/screens/auth/login_screen.dart';
import 'package:smart_key/screens/auth/signup_screen.dart';
import 'package:smart_key/screens/forgot_password_screen.dart';
import 'package:smart_key/screens/members_at_home_screen.dart';
import 'package:smart_key/screens/notifications_screen.dart';
import 'package:smart_key/screens/reset_password_screen.dart';
import 'package:smart_key/services/firebase_api.dart';
import 'package:smart_key/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_key/widgets/guest_navigation_menu.dart';
import 'package:smart_key/widgets/navigation_menu.dart';
import 'package:firebase_core/firebase_core.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: 'AIzaSyB9UJ4ug5w0NRXlOdQ_e6pbJEodtX57dFE',
    appId: '1:40179194105:android:88157615cd28dd168faa28',
    messagingSenderId: '40179194105',
    projectId: 'smart-key-958ce',
  ));
  await FirebaseApi().initNotifications();
  runApp(const SmartKey());
}

class SmartKey extends StatefulWidget {
  const SmartKey({super.key});

  @override
  State<SmartKey> createState() => SmartKeyState();
}

class SmartKeyState extends State<SmartKey> {
  late SharedPreferences preferences;
  bool isLoading = false;
  String? userType;
  bool isAuth = false;

  @override
  void initState() {
    super.initState();
    checkAuth();
  }

  void checkAuth() async {
    preferences = await SharedPreferences.getInstance();
    final token = preferences.getString('token');
    userType = preferences.getString('userType');
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
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
          headlineMedium: TextStyle(
            color: secondaryColor,
            fontFamily: 'Niramit',
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          headlineSmall: TextStyle(
            color: secondaryColor,
            fontFamily: 'Niramit',
            fontSize: 22,
            fontWeight: FontWeight.normal,
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
          bodySmall: TextStyle(
            color: secondaryColor,
            fontFamily: 'Niramit',
            fontSize: 15,
          ),
        ),
        useMaterial3: true,
      ),
      home: isAuth
          ? userType == 'guest'
              ? GuestNavigationMenu()
              : NavigationMenu()
          : LoginScreen(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/nav': (context) => NavigationMenu(),
        '/guestNav': (context) => GuestNavigationMenu(),
        '/notifications': (context) => NotificationsScreen(),
        '/homeMembers': (context) => HomeMembersScreen(),
        '/forgotPassword': (context) => ForgotPassword(),
        '/resetPassword': (context) => ResetPassword(),
      },
      navigatorKey: navigatorKey,
    );
  }
}
