import 'package:flutter/material.dart';
import 'package:smart_key/classes/invitation.dart';

class InvitationItem extends StatelessWidget {
  final Invitation invitation;

  const InvitationItem({super.key, required this.invitation});

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
            flex: 20,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '${invitation.email}\n',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  TextSpan(
                    text: invitation.type,
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Niramit',
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(child: Container()),
          Expanded(
              flex: 2,
              child: Icon(
                Icons.delete,
                color: Colors.red.shade800,
              )),
        ],
      ),
    );
  }
}
