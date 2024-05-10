import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:smart_key/services/api.dart';
import 'package:smart_key/utils/constants.dart';
import 'package:smart_key/utils/input_methods.dart';
import 'package:smart_key/widgets/primary_button.dart';
import 'package:smart_key/widgets/text_field.dart';
import 'package:logger/logger.dart';

class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen({super.key});

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final logger = Logger();

  void changePassword(BuildContext context) async {
    final data = {
      'currentPassword': currentPasswordController.text.toString(),
      'newPassword': newPasswordController.text.toString(),
    };

    logger.i(data.toString());

    final result = await API(context: context)
        .sendRequest(route: '/changePassword', method: 'post', data: data);
    final response = jsonDecode(result.body);

    logger.i(response);

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
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: screenHeight(context) * 0.15),
                      Text(
                        'We have sent you a verification code on your email address.',
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: screenHeight(context) * 0.06),
                      MyTextField(
                        labelText: 'Current Password',
                        hintText: '********',
                        controller: currentPasswordController,
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              !value.isValidPassword) {
                            return 'Password must be at least 8 characters long';
                          }
                          return null;
                        },
                        showVisibilityIcon: true,
                        obscureText: true,
                        textInputType: TextInputType.emailAddress,
                      ),
                      SizedBox(
                        height: screenHeight(context) * 0.025,
                      ),
                      MyTextField(
                        labelText: 'New Password',
                        hintText: '********',
                        controller: newPasswordController,
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
                          if (value != newPasswordController.text) {
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
                            changePassword(context);
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
