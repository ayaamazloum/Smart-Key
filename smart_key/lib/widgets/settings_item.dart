import 'package:flutter/material.dart';

class SettingsItem extends StatelessWidget {
  const SettingsItem({super.key, required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300, width: 1)),
      ),
      child: Row(
        children: [
          Expanded(
              flex: 1,
              child: Icon(
                icon,
                color: Colors.grey.shade600,
              )),
          Expanded(child: Container()),
          Expanded(
              flex: 18,
              child:
                  Text(title, style: Theme.of(context).textTheme.bodyMedium)),
          Expanded(
              flex: 1,
              child: Icon(Icons.arrow_forward, color: Colors.grey.shade600)),
        ],
      ),
    );
  }
}
