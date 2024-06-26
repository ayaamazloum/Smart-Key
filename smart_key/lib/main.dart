import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_key/providers/user_data.dart';
import 'package:smart_key/screens/auth/login_screen.dart';
import 'package:smart_key/screens/auth/signup_screen.dart';
import 'package:smart_key/screens/change_knock_screen.dart';
import 'package:smart_key/screens/change_passcode.dart';
import 'package:smart_key/screens/change_password_screen.dart';
import 'package:smart_key/screens/forgot_password_screen.dart';
import 'package:smart_key/screens/invitations_screen.dart';
import 'package:smart_key/screens/knock_screen.dart';
import 'package:smart_key/screens/members_at_home_screen.dart';
import 'package:smart_key/screens/notifications_screen.dart';
import 'package:smart_key/screens/profile_screen.dart';
import 'package:smart_key/screens/reset_password_screen.dart';
import 'package:smart_key/services/api.dart';
import 'package:smart_key/services/firebase_api.dart';
import 'package:smart_key/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_key/widgets/guest_navigation_menu.dart';
import 'package:smart_key/widgets/navigation_menu.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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

  runApp(ChangeNotifierProvider(create: (_) => UserData(), child: SmartKey()));
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
    FlutterSecureStorage storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    if (token != null && token.isNotEmpty) {
      validateUser();
    } else {
      setState(() {
        isAuth = false;
      });
    }
  }

  void validateUser() async {
    final result = await API(context: context)
        .sendRequest(route: '/validateUser', method: 'get');
    final response = jsonDecode(result.body);

    if (response['status'] == 'success') {
      final userData =
          Provider.of<UserData>(navigatorKey.currentContext!, listen: false);
      setState(() {
        userData.setName(response['name']);
        userType = preferences.getString('userType');
        isAuth = true;
      });
    } else {
      setState(() {
        isAuth = true;
      });
    }
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
        '/forgotPassword': (context) => ForgotPasswordScreen(),
        '/resetPassword': (context) => ResetPasswordScreen(),
        '/invitations': (context) => InvitationsScreen(),
        '/changePassword': (context) => ChangePasswordScreen(),
        '/changePasscode': (context) => ChangePasscodeScreen(),
        '/knock': (context) => KncockScreen(),
        '/changeKnock': (context) => ChangeKnockScreen(),
        '/profile': (context) => ProfileScreen(),
      },
      navigatorKey: navigatorKey,
    );
  }
}
