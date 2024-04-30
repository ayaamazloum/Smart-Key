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
import 'package:shared_preferences/shared_preferences.dart';

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
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString('name', response['user']['name']);
      await preferences.setString('token', response['authorisation']['token']);

      ScaffoldMessenger.of(_formKey.currentContext!).showSnackBar(
        SnackBar(
          content: Text(
            'Signed up successfully, welcome.',
            style: TextStyle(fontSize: 12, color: Colors.red.shade800),
          ),
          backgroundColor: Colors.white,
          elevation: 30,
        ),
      );

      Navigator.of(_formKey.currentContext!).popAndPushNamed('/home');
    } else {
      logger.i(response);
      final errorMessage = response['error'];
      ScaffoldMessenger.of(_formKey.currentContext!).showSnackBar(
        SnackBar(
          content: Text(
            errorMessage,
            style: TextStyle(fontSize: 12, color: Colors.red.shade800),
          ),
          backgroundColor: Colors.white,
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
          child: SingleChildScrollView(
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
                key: _formKey,
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
                        'Sign up',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ),
                    SizedBox(
                      height: screenHeight(context) * 0.05,
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
                      height: screenHeight(context) * 0.025,
                    ),
                    EmailTextField(
                      label: 'E-mail',
                      controller: _emailController,
                      validator: (val) {
                        if (val == null || val.isEmpty || !val.isValidEmail) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                      textInputType: TextInputType.emailAddress,
                    ),
                    SizedBox(
                      height: screenHeight(context) * 0.025,
                    ),
                    PasswordTextField(
                      name: 'Password',
                      controller: _passwordController,
                      validator: (val) {
                        if (val == null ||
                            val.isEmpty ||
                            !val.isValidPassword) {
                          return 'Password must be at least 8 characters long';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: screenHeight(context) * 0.025,
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
                      height: screenHeight(context) * 0.05,
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
                      height: screenHeight(context) * 0.02,
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
      ),
    );
  }
}
