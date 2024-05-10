import 'package:flutter/material.dart';
import 'package:smart_key/widgets/log.dart';

class LogCard extends StatelessWidget {
  final Log log;

  const LogCard({super.key, required this.log});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        border:
            Border(bottom: BorderSide(color: Colors.grey.shade300, width: 1)),
      ),
      child: Row(
        children: [
          Expanded(
              flex: 12,
              child: Text(log.log,
                  style: Theme.of(context).textTheme.bodySmall)),
          Expanded(child: Container()),
          Expanded(
              flex: 4,
              child: Text(log.date,
                  style: TextStyle(color: Colors.grey, fontSize: 12))),
        ],
      ),
    );
  }
}