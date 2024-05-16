import 'package:flutter/material.dart';
import 'package:smart_key/utils/constants.dart';

class MyTextField extends StatefulWidget {
  const MyTextField(
      {super.key,
      required this.labelText,
      required this.hintText,
      this.isEnabled = true,
      this.textColor,
      required this.controller,
      this.showVisibilityIcon = false,
      this.validator,
      required this.obscureText,
      required this.textInputType});

  final String labelText;
  final String hintText;
  final bool? isEnabled;
  final Color? textColor;
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // Background color
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextFormField(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 20),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          enabled: widget.isEnabled!,
          labelText: widget.labelText,
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: Colors.grey.shade400,
            fontWeight: FontWeight.w300,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          suffixIcon: widget.showVisibilityIcon!
              ? IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
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
          color: widget.textColor ?? secondaryColor,
        ),
        controller: widget.controller,
        validator: widget.validator,
        obscureText: widget.obscureText && !_isPasswordVisible,
        keyboardType: widget.textInputType,
      ),
    );
  }
}
