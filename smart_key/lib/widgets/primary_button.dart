import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String text;

  const PrimaryButton({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: () {},
        child: Text(
          text,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
