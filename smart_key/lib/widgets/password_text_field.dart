import 'package:flutter/material.dart';
import 'package:smart_key/utils/constants.dart';

class PasswordTextField extends StatefulWidget {
  const PasswordTextField(
      {super.key,
      required this.name,
      required this.controller,
      this.validator});

  final String name;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: 20),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelText: widget.name,
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
      controller: widget.controller,
      validator: widget.validator,
      obscureText: !_isPasswordVisible,
      keyboardType: TextInputType.visiblePassword,
    );
  }
}
