import 'package:flutter/material.dart';
import 'package:smart_key/utils/constants.dart';

class MyTextField extends StatefulWidget {
  const MyTextField(
      {super.key,
      required this.labelText,
      required this.hintText,
      required this.controller,
      this.showVisibilityIcon = false,
      this.validator,
      required this.obscureText,
      required this.textInputType});

  final String labelText;
  final String hintText;
  final bool? showVisibilityIcon;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType textInputType;

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: 20),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelText: widget.labelText,
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: Colors.grey.shade400,
          fontWeight: FontWeight.w300,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        suffixIcon: widget.showVisibilityIcon!
            ? IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                ),
                color: primaryColor,
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              )
            : null,
      ),
      style: TextStyle(
        fontSize: 14.0,
        color: secondaryColor,
      ),
      controller: widget.controller,
      validator: widget.validator,
      obscureText: widget.obscureText && !_isPasswordVisible,
      keyboardType: widget.textInputType,
    );
  }
}
