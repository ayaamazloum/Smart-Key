import 'package:flutter/material.dart';
import 'package:smart_key/utils/constants.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({super.key, required this.text, required this.onPressed});

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (states.contains(MaterialState.pressed)) {
              return primaryColor.withOpacity(0.6);
            }
            return primaryColor;
          }),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        ),
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}
