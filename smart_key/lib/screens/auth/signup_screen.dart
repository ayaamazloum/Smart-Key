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

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _keyController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final logger = Logger();

  void registerUser(BuildContext context) async {
    final data = {
      'name': _nameController.text.toString(),
      'email': _emailController.text.toString(),
      'key': _keyController.text.toString(),
      'password': _passwordController.text.toString(),
    };

    final result = await API(context: context).sendRequest(route: '/register', method: 'post', data: data);
    final response = jsonDecode(result.body);

    if (response['status'] == 'success') {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString('name', response['user']['name']);
      await preferences.setString('userType', response['userType']);
      await preferences.setBool('isHome', response['isHome']);
      await preferences.setInt('arduinoId', response['user']['arduino_id']);
      await preferences.setString('token', response['authorisation']['token']);

      ScaffoldMessenger.of(_formKey.currentContext!).showSnackBar(
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
          ? Navigator.of(_formKey.currentContext!).popAndPushNamed('/guestNav')
          : Navigator.of(_formKey.currentContext!).popAndPushNamed('/nav');
    } else {
      logger.i(response);
      final errorMessage = response['message'];
      ScaffoldMessenger.of(_formKey.currentContext!).showSnackBar(
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
                      offset: Offset(0, -25),
                      child: Text(
                        'Sign up',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                    SizedBox(
                      height: screenHeight(context) * 0.03,
                    ),
                    MyTextField(
                      labelText: 'Full Name',
                      hintText: 'John Doe',
                      controller: _nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty || !value.isValidName) {
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
                      controller: _emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty || !value.isValidEmail) {
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
                      controller: _keyController,
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
                      controller: _passwordController,
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
                      controller: _confirmPasswordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords don\'t match';
                        }
                        return null;
                      },
                      obscureText: true,
                      textInputType: TextInputType.visiblePassword,
                    ),
                    SizedBox(
                      height: screenHeight(context) * 0.05,
                    ),
                    PrimaryButton(
                      text: 'Signup',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          registerUser(context);
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
