import 'package:flutter/material.dart';
import 'package:smart_key/utils/constants.dart';

class EmailTextField extends StatelessWidget {
  const EmailTextField(
      {super.key,
      required this.label,
      required this.controller,
      this.validator,
      required this.textInputType});

  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType textInputType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: 20),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelText: label,
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
        color: secondaryColor,
      ),
      controller: controller,
      validator: validator,
      keyboardType: textInputType,
    );
  }
}
