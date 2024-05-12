import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_key/main.dart';
import 'package:smart_key/providers/user_data.dart';
import 'package:smart_key/utils/constants.dart';
import 'package:smart_key/utils/input_methods.dart';
import 'package:smart_key/services/api.dart';
import 'package:smart_key/widgets/text_field.dart';
import 'package:smart_key/widgets/primary_button.dart';
import 'package:flutter/gestures.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smart_key/services/firebase_api.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController keyController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final logger = Logger();

  void registerUser(BuildContext context) async {
    FirebaseApi firebaseApi = FirebaseApi();
    String? fcmToken = await firebaseApi.getFcmToken();

    final data = {
      'name': nameController.text.toString(),
      'email': emailController.text.toString(),
      'key': keyController.text.toString(),
      'password': passwordController.text.toString(),
      'fcmToken': fcmToken,
    };

    logger.i(fcmToken);

    final result = await API(context: formKey.currentContext!)
        .sendRequest(route: '/register', method: 'post', data: data);
    final response = jsonDecode(result.body);

    if (response['status'] == 'success') {
      FlutterSecureStorage storage = FlutterSecureStorage();
      await storage.write(key: 'email', value: response['user']['email']);
      await storage.write(
          key: 'token', value: response['authorisation']['token']);

      final userData = Provider.of<UserData>(navigatorKey.currentContext!, listen: false);
      userData.setName(response['user']['name']);

      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString('userType', response['userType']);
      await preferences.setBool('isHome', response['isHome']);
      await preferences.setInt('arduinoId', response['user']['arduino_id']);

      ScaffoldMessenger.of(formKey.currentContext!).showSnackBar(
        SnackBar(
          content: Text(
            'Signed up successfully, welcome.',
            style: TextStyle(fontSize: 12, color: primaryColor),
          ),
          backgroundColor: Colors.grey.shade200,
          elevation: 30,
        ),
      );

      response['userType'] == 'guest'
          ? Navigator.of(formKey.currentContext!).popAndPushNamed('/guestNav')
          : Navigator.of(formKey.currentContext!).popAndPushNamed('/nav');
    } else {
      logger.i(response);
      final errorMessage = response['message'];
      ScaffoldMessenger.of(formKey.currentContext!).showSnackBar(
        SnackBar(
          content: Text(
            errorMessage,
            style: TextStyle(fontSize: 12, color: Colors.red.shade800),
          ),
          backgroundColor: Colors.grey.shade200,
          elevation: 30,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 25),
            decoration: BoxDecoration(
              borderRadius: BorderRadiusDirectional.only(
                  topStart: Radius.circular(40), topEnd: Radius.circular(40)),
              color: Colors.white,
            ),
            width: screenWidth(context),
            height: screenHeight(context) * 0.8,
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Transform.translate(
                      offset: Offset(0, -7),
                      child: Container(
                        width: 100,
                        height: 100,
                        padding: EdgeInsets.all(20),
                        transform: Matrix4.translationValues(0, -40, 0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 0),
                              blurRadius: 4,
                              color: Colors.grey.shade400,
                            ),
                          ],
                        ),
                        child: Center(
                            child: Image(
                                image:
                                    AssetImage('assets/images/auth_logo.png'))),
                      ),
                    ),
                    Transform.translate(
                      offset: Offset(0, -35),
                      child: Text(
                        'Sign up',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                    SizedBox(
                      height: screenHeight(context) * 0.01,
                    ),
                    MyTextField(
                      labelText: 'Full Name',
                      hintText: 'John Doe',
                      controller: nameController,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            !value.isValidName) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                      obscureText: false,
                      textInputType: TextInputType.name,
                    ),
                    SizedBox(
                      height: screenHeight(context) * 0.025,
                    ),
                    MyTextField(
                      labelText: 'E-mail',
                      hintText: 'example@example.com',
                      controller: emailController,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            !value.isValidEmail) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                      obscureText: false,
                      textInputType: TextInputType.emailAddress,
                    ),
                    SizedBox(
                      height: screenHeight(context) * 0.025,
                    ),
                    MyTextField(
                      labelText: 'Invitation Key',
                      hintText: '--------',
                      controller: keyController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your key';
                        }
                        return null;
                      },
                      obscureText: false,
                      textInputType: TextInputType.text,
                    ),
                    SizedBox(
                      height: screenHeight(context) * 0.025,
                    ),
                    MyTextField(
                      labelText: 'Password',
                      hintText: '********',
                      controller: passwordController,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            !value.isValidPassword) {
                          return 'Password must be at least 8 characters long';
                        }
                        return null;
                      },
                      obscureText: true,
                      textInputType: TextInputType.visiblePassword,
                    ),
                    SizedBox(
                      height: screenHeight(context) * 0.025,
                    ),
                    MyTextField(
                      labelText: 'Confirm Password',
                      hintText: '********',
                      controller: confirmPasswordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != passwordController.text) {
                          return 'Passwords don\'t match';
                        }
                        return null;
                      },
                      obscureText: true,
                      textInputType: TextInputType.visiblePassword,
                    ),
                    SizedBox(
                      height: screenHeight(context) * 0.04,
                    ),
                    PrimaryButton(
                      text: 'Signup',
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          registerUser(context);
                        }
                      },
                    ),
                    SizedBox(
                      height: screenHeight(context) * 0.015,
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Already have an account? ',
                            style: TextStyle(color: secondaryColor),
                          ),
                          TextSpan(
                            text: 'Log In',
                            style: TextStyle(color: primaryColor),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.of(context).popAndPushNamed('/login');
                              },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
