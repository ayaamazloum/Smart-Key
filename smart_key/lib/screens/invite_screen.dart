import 'package:flutter/material.dart';
import 'package:smart_key/utils/constants.dart';
import 'package:logger/logger.dart';

class InviteScreen extends StatefulWidget {
  const InviteScreen({super.key});

  @override
  State<InviteScreen> createState() => _InviteScreenState();
}

List<String> invitationTypes = ['family_member', 'guest'];

class _InviteScreenState extends State<InviteScreen> {
  String selectedType = invitationTypes[0];

  final logger = Logger();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(children: [
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              'assets/images/screen_shape_2.png',
              width: screenWidth(context) * 0.35,
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            bottom: -40,
            right: 0,
            child: Image.asset(
              'assets/images/screen_shape_3.png',
              width: screenWidth(context) * 0.35,
              fit: BoxFit.contain,
            ),
          ),
          Container(
            padding: EdgeInsets.only(
                left: screenWidth(context) * 0.05,
                right: screenWidth(context) * 0.05,
                top: screenHeight(context) * 0.04),
            child: ListView(children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Invite a member',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
              SizedBox(height: screenHeight(context) * 0.05),
              ListTile(
                title: Text(
                  'Family member',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                leading: Radio(
                  value: invitationTypes[0],
                  groupValue: selectedType,
                  onChanged: (value) {
                    setState(() {
                      selectedType = value.toString();
                    });
                  },
                ),
              ),
              ListTile(
                title: Text(
                  'Guest',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                leading: Radio(
                  value: invitationTypes[1],
                  groupValue: selectedType,
                  onChanged: (value) {
                    setState(() {
                      selectedType = value.toString();
                    });
                  },
                ),
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}
