import 'package:flutter/material.dart';
import 'package:smart_key/utils/constants.dart';

class EmailTextField extends StatelessWidget {
  const EmailTextField({super.key, required this.controller, this.validator});

  final TextEditingController controller;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: 20),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelText: 'E-mail',
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
      keyboardType: TextInputType.emailAddress,
    );
  }
}
