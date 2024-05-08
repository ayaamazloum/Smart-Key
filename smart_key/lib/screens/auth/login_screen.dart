import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:smart_key/utils/constants.dart';
import 'package:smart_key/utils/input_methods.dart';
import 'package:smart_key/services/api.dart';
import 'package:smart_key/widgets/text_field.dart';
import 'package:smart_key/widgets/primary_button.dart';
import 'package:flutter/gestures.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final logger = Logger();

  void loginUser(BuildContext context) async {
    final data = {
      'email': emailController.text.toString(),
      'password': passwordController.text.toString(),
    };

    logger.i(data.toString());

    final result = await API(context: context)
        .sendRequest(route: '/login', method: 'post', data: data);
    final response = jsonDecode(result.body);

    logger.i(response);

    if (response['status'] == 'success') {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString('name', response['user']['name']);
      if (response['user']['profile_picture'] != null) {
        await preferences.setString(
            'profilePicture', response['user']['profile_picture']);
      }
      await preferences.setString('userType', response['userType']);
      await preferences.setBool('isHome', response['isHome']);
      await preferences.setInt('arduinoId', response['user']['arduino_id']);
      await preferences.setString('token', response['authorisation']['token']);

      response['userType'] == 'guest'
          ? Navigator.of(formKey.currentContext!).popAndPushNamed('/guestNav')
          : Navigator.of(formKey.currentContext!).popAndPushNamed('/nav');
    } else {
      final errorMessage = response['message'] == 'Unauthorized'
          ? 'Incorrect credentials'
          : response['message'];
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
                      offset: Offset(0, -15),
                      child: Text(
                        'Log In',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                    SizedBox(
                      height: screenHeight(context) * 0.08,
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
                      labelText: 'Password',
                      hintText: '********',
                      controller: passwordController,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            !value.isValidPassword) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                      obscureText: true,
                      showVisibilityIcon: true,
                      textInputType: TextInputType.visiblePassword,
                    ),
                    SizedBox(
                      height: screenHeight(context) * 0.01,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed('/forgotPassword');
                        },
                        child: Text(
                          'forgot password?',
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: screenHeight(context) * 0.06,
                    ),
                    PrimaryButton(
                      text: 'Login',
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          loginUser(context);
                        }
                      },
                    ),
                    SizedBox(
                      height: screenHeight(context) * 0.02,
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Don\'t have an account? ',
                            style: TextStyle(color: secondaryColor),
                          ),
                          TextSpan(
                            text: 'Sign Up',
                            style: TextStyle(color: primaryColor),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.of(context)
                                    .popAndPushNamed('/signup');
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
