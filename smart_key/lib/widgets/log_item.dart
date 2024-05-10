import 'package:flutter/material.dart';

class LogCard extends StatelessWidget {
  final List<String> listData;

  const LogCard({super.key, required this.listData});

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
              child: Text(listData[0],
                  style: Theme.of(context).textTheme.bodySmall)),
          Expanded(child: Container()),
          Expanded(
              flex: 4,
              child: Text(listData[1],
                  style: TextStyle(color: Colors.grey, fontSize: 12))),
        ],
      ),
    );
  }
}
