import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:smart_key/services/api.dart';
import 'package:smart_key/utils/constants.dart';
import 'package:smart_key/utils/input_methods.dart';
import 'package:smart_key/widgets/primary_button.dart';
import 'package:smart_key/widgets/text_field.dart';

class ChangePasscodeScreen extends StatelessWidget {
  ChangePasscodeScreen({super.key});

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController currentPasscodeController = TextEditingController();
  final TextEditingController newPasscodeController = TextEditingController();
  final TextEditingController confirmPasscodeController = TextEditingController();

  void changePasscode(BuildContext context) async {
    final data = {
      'currentPasscode': currentPasscodeController.text.toString(),
      'newPasscode': newPasscodeController.text.toString(),
    };

    final result = await API(context: context)
        .sendRequest(route: '/changePasscode', method: 'post', data: data);
    final response = jsonDecode(result.body);

    if (response['status'] == 'success') {
      ScaffoldMessenger.of(formKey.currentContext!).showSnackBar(
        SnackBar(
          content: Text(
            'Passcode changed successfully.',
            style: TextStyle(fontSize: 12, color: primaryColor),
          ),
          backgroundColor: Colors.grey.shade200,
          elevation: 30,
        ),
      );
      Navigator.pop(formKey.currentContext!);
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
                child: Text('Change Passcode',
                    style: Theme.of(context).textTheme.headlineLarge)),
            Container(
              padding: EdgeInsets.only(
                left: screenWidth(context) * 0.05,
                right: screenWidth(context) * 0.05,
              ),
              margin: EdgeInsets.only(top: screenHeight(context) * 0.17),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Passcode must is at least 8 characters long and can contain only digits and uppercase letters A-D.',
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: screenHeight(context) * 0.06),
                      MyTextField(
                        labelText: 'Current Passcode',
                        hintText: '********',
                        controller: currentPasscodeController,
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              !value.isValidPasscode) {
                            return 'Invalid passcode format';
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
                        labelText: 'New Passcode',
                        hintText: '********',
                        controller: newPasscodeController,
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              !value.isValidPasscode) {
                            return 'Invalid passcode format';
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
                        labelText: 'Confirm Passcode',
                        hintText: '********',
                        controller: confirmPasscodeController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your Passcode';
                          }
                          if (value != newPasscodeController.text) {
                            return 'Passcodes don\'t match';
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
                        text: 'Change Passcode',
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            changePasscode(context);
                          }
                        },
                      ),
                      SizedBox(
                        height: screenHeight(context) * 0.015,
                      ),
                    Align(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(formKey.currentContext!).pushNamed('/forgotPasscode');
                        },
                        child: Text(
                          'forgot Passcode?',
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 14,
                          ),
                        ),
                      ),
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
