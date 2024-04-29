import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:smart_key/utils/constants.dart';
import 'package:smart_key/utils/input_methods.dart';
import 'package:smart_key/methods/api.dart';
import 'package:smart_key/widgets/email_text_field.dart';
import 'package:smart_key/widgets/password_text_field.dart';
import 'package:smart_key/widgets/primary_button.dart';
import 'package:flutter/gestures.dart';
import 'package:logger/logger.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final logger = Logger();

  void loginUser() async {
    final data = {
      'email': _emailController.text.toString(),
      'password': _passwordController.text.toString(),
    };

    logger.i(data.toString());

    final result = await API().postRequest(route: '/login', data: data);
    final response = jsonDecode(result.body);

    if (response['status'] == 'success') {
      logger.i('login successful');
      Navigator.of(_formKey.currentContext!).popAndPushNamed('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(top: 150.0),
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 25),
            decoration: BoxDecoration(
              borderRadius: BorderRadiusDirectional.only(
                  topStart: Radius.circular(40), topEnd: Radius.circular(40)),
              color: Colors.white,
            ),
            width: double.infinity,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
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
                            image: AssetImage('assets/images/auth_logo.png'))),
                  ),
                  Text(
                    'Log In',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  SizedBox(
                    height: 80,
                  ),
                  EmailTextField(
                    controller: _emailController,
                    validator: (val) {
                      if (val == null || val.isEmpty || !val.isValidEmail) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  PasswordTextField(
                    name: 'Password',
                    controller: _passwordController,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'forgot password?',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  PrimaryButton(
                    text: 'Log in',
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        loginUser();
                      }
                    },
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Don\'t have an account? ',
                          style: TextStyle(color: secondaryColor),
                        ),
                        TextSpan(
                          text: 'Sign up',
                          style: TextStyle(color: primaryColor),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.of(context).popAndPushNamed('/signup');
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
    );
  }
}
