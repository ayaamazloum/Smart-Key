import 'package:flutter/material.dart';
import 'package:smart_key/classes/log.dart';

class LogItem extends StatelessWidget {
  final Log log;

  const LogItem({super.key, required this.log});

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
              child:
                  Text(log.log, style: Theme.of(context).textTheme.bodySmall)),
          Expanded(child: Container()),
          Expanded(
              flex: 5,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(log.date,
                    style: TextStyle(color: Colors.grey, fontSize: 10,)),
              )),
        ],
      ),
    );
  }
}
