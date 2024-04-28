import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
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
                  child:
                      Image(image: AssetImage('assets/images/auth_logo.png'))),
            ),
            Text(
              'Log In',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            SizedBox(
              height: 55,
              child: TextField(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 20),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: 'Email',
                  hintText: 'example@example.com',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontWeight: FontWeight.w300,
                    ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                style: TextStyle(
                  fontSize: 14.0,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
