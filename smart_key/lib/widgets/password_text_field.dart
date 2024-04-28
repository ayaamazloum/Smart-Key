import 'package:flutter/material.dart';

class PasswordTextField extends StatelessWidget {
  const PasswordTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      child: TextField(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 20),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: 'Password',
          hintText: '********',
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
        onChanged: (value) {
          // Add password validation logic
        },
        obscureText: true,
        keyboardType: TextInputType.visiblePassword,
      ),
    );
  }
}
