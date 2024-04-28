import 'package:flutter/material.dart';
import 'package:smart_key/utils/constants.dart';

class EmailTextField extends StatelessWidget {
  const EmailTextField({super.key});
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
          color: secondaryColor,
        ),
        onChanged: (value) {
          // Add email validation logic
        },
        keyboardType: TextInputType.emailAddress,
      ),
    );
  }
}
