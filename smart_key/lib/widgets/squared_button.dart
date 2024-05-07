import 'package:flutter/material.dart';
import 'package:smart_key/utils/constants.dart';

class SquaredButton extends StatelessWidget {
  const SquaredButton(
      {super.key, required this.text, required this.onPressed, required this.backgroundColor});

  final String text;
  final Function() onPressed;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: screenWidth(context) * 0.25,
      width: screenWidth(context) * 0.25,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (states.contains(MaterialState.pressed)) {
              return buttonPressColor;
            }
            return backgroundColor;
          }),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
          textStyle: MaterialStateProperty.all<TextStyle>(
            TextStyle(fontSize: 16.0),
          ),
          elevation: MaterialStateProperty.all<double>(4.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.sensor_door_outlined,
              color: Colors.white,
              size: 35,
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              text,
              style: TextStyle(
                  fontFamily: 'Niramit', color: Colors.white, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
