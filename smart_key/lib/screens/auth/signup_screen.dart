import 'package:flutter/material.dart';
import 'package:smart_key/utils/constants.dart';
import 'package:smart_key/widgets/email_text_field.dart';
import 'package:smart_key/widgets/password_text_field.dart';
import 'package:smart_key/widgets/primary_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(top: 180.0),
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 25),
            decoration: BoxDecoration(
              borderRadius: BorderRadiusDirectional.only(
                  topStart: Radius.circular(40), topEnd: Radius.circular(40)),
              color: Colors.white,
            ),
            width: double.infinity,
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
                EmailTextField(),
                SizedBox(
                  height: 20,
                ),
                PasswordTextField(name: 'Password'),
                SizedBox(
                  height: 20,
                ),
                PasswordTextField(name: 'Confirm Password'),
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
                  text: 'Log In',
                  onPressed: () {},
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
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
