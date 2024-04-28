import 'package:flutter/material.dart';
import 'package:smart_key/utils/constants.dart';

class PasswordTextField extends StatefulWidget {
  const PasswordTextField({super.key});

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _isPasswordVisible = false;

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
          suffixIcon: IconButton(
            icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                color: primaryColor,
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          ),
        ),
        style: TextStyle(
          fontSize: 14.0,
          color: secondaryColor,
        ),
        onChanged: (value) {
          // Add password validation logic
        },
        obscureText: !_isPasswordVisible,
        keyboardType: TextInputType.visiblePassword,
      ),
    );
  }
}
