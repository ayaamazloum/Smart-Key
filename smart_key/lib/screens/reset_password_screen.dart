import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:smart_key/services/api.dart';
import 'package:smart_key/utils/constants.dart';
import 'package:smart_key/utils/input_methods.dart';
import 'package:smart_key/widgets/primary_button.dart';
import 'package:smart_key/widgets/text_field.dart';
import 'package:logger/logger.dart';

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({super.key});

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController keyController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final logger = Logger();

  void resetPassword(BuildContext context) async {
    final data = {
      'email': emailController.text.toString(),
      'key': keyController.text.toString(),
      'password': passwordController.text.toString(),
    };

    logger.i(data.toString());

    final result = await API(context: context)
        .sendRequest(route: '/resetPassword', method: 'post', data: data);
    final response = jsonDecode(result.body);

    logger.i(response);

    if (response['status'] == 'success') {
      ScaffoldMessenger.of(formKey.currentContext!).showSnackBar(
        SnackBar(
          content: Text(
            'Password reset successfully.',
            style: TextStyle(fontSize: 12, color: primaryColor),
          ),
          backgroundColor: Colors.grey.shade200,
          elevation: 30,
        ),
      );
      Navigator.of(formKey.currentContext!).popAndPushNamed('/login');
    } else {
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
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: Image.asset(
                'assets/images/screen_shape_1.png',
                width: screenWidth(context) * 0.35,
                fit: BoxFit.contain,
              ),
            ),
            Positioned(
              top: screenHeight(context) * 0.04,
              left: 10,
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Positioned(
                top: screenHeight(context) * 0.04,
                left: (screenWidth(context) - screenWidth(context) * 0.53) / 2,
                child: Text('Forgot Password',
                    style: Theme.of(context).textTheme.headlineLarge)),
            Container(
              padding: EdgeInsets.only(
                left: screenWidth(context) * 0.05,
                right: screenWidth(context) * 0.05,
              ),
              margin: EdgeInsets.only(top: screenHeight(context) * 0.25),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: screenHeight(context) * 0.17),
                      Text(
                        'We have sent you a verification code on your email address.',
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: screenHeight(context) * 0.06),
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
                        labelText: 'Verification Code',
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
                        labelText: 'New Password',
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
                        height: screenHeight(context) * 0.05,
                      ),
                      PrimaryButton(
                        text: 'Reset Password',
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            resetPassword(context);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
