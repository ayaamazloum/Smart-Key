import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:smart_key/utils/constants.dart';
import 'package:smart_key/utils/input_methods.dart';
import 'package:smart_key/methods/api.dart';
import 'package:smart_key/widgets/email_text_field.dart';
import 'package:smart_key/widgets/name_text_field.dart';
import 'package:smart_key/widgets/password_text_field.dart';
import 'package:smart_key/widgets/primary_button.dart';
import 'package:flutter/gestures.dart';
import 'package:logger/logger.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final logger = Logger();

  void registerUser() async {
    final data = {
      'name': _nameController.text.toString(),
      'email': _emailController.text.toString(),
      'password': _passwordController.text.toString(),
    };

    logger.i(data.toString());

    final result = await API().postRequest(route: '/register', data: data);
    final response = jsonDecode(result.body);

    if (response['status'] == 'success') {
      logger.i('Signup successful');
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
                    'Sign up',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  NameTextField(
                    name: 'Full Name',
                    controller: _nameController,
                    validator: (val) {
                      if (val == null || val.isEmpty || !val.isValidName) {
                        return 'Please enter your full name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
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
                      if (val == null || val.isEmpty || !val.isValidPassword) {
                        return 'Please enter a valid password';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  PasswordTextField(
                    name: 'Confirm Password',
                    controller: _confirmPasswordController,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (val != _passwordController.text) {
                        return 'Passwords don\'t match';
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
                    height: 30,
                  ),
                  PrimaryButton(
                    text: 'Sign Up',
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        registerUser();
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
                          text: 'Already have an account? ',
                          style: TextStyle(color: secondaryColor),
                        ),
                        TextSpan(
                          text: 'Log in',
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
    );
  }
}
