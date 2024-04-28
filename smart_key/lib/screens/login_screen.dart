import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        margin: EdgeInsets.only(top: 180.0),
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
              padding: EdgeInsets.all(15),
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
          ],
        ),
      ),
    );
  }
}
