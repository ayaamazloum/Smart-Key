import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:smart_key/classes/invitation.dart';
import 'package:smart_key/main.dart';
import 'package:smart_key/services/api.dart';
import 'package:smart_key/utils/constants.dart';
import 'package:smart_key/widgets/invitaion_item.dart';
import 'package:logger/logger.dart';

class InvitationsScreen extends StatefulWidget {
  const InvitationsScreen({super.key});

  @override
  State<InvitationsScreen> createState() => InvitationsScreenState();
}

class InvitationsScreenState extends State<InvitationsScreen> {
  List<Invitation> invitations = [];
  final logger = Logger();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    fetchInvitations();
  }

  void fetchInvitations() async {
    final result = await API(context: navigatorKey.currentContext!)
        .sendRequest(route: '/invitations', method: 'get');
    final response = jsonDecode(result.body);
    logger.i(response);

    setState(() {
      isLoading = false;
    });

    if (response['status'] == 'success') {
      setState(() {
        invitations = parseInvitations(result.body);
      });
    } else {
      final errorMessage = response['message'];
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(
          content: Text(
            errorMessage,
            style: TextStyle(fontSize: 12, color: Colors.red.shade800),
          ),
          backgroundColor: Colors.grey.shade200,
          elevation: 30,
        ),
      );
    }
  }

  List<Invitation> parseInvitations(String responseBody) {
    final parsed =
        jsonDecode(responseBody)['invitations'].cast<Map<String, dynamic>>();
    return parsed.map<Invitation>((json) => Invitation.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: screenHeight(context),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                child: Image.asset(
                  'assets/images/screen_shape_1.png',
                  width: screenWidth(context) * 0.35,
                  fit: BoxFit.contain,
                ),
              ),
              Positioned(
                top: screenHeight(context) * 0.04,
                left: 10,
                child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(
                        context);
                  },
                ),
              ),
              Positioned(
                top: screenHeight(context) * 0.04,
                left: (screenWidth(context) - screenWidth(context) * 0.36) / 2,
                child: Text(
                  'Invitations',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth(context) * 0.05,
                  vertical: screenHeight(context) * 0.04,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: screenHeight(context) * 0.12),
                    Expanded(
                      child: isLoading
                          ? Center(child: CircularProgressIndicator())
                          : invitations.isEmpty
                              ? Center(child: Text('No logs available.'))
                              : ListView.builder(
                                  itemCount: invitations.length,
                                  itemBuilder: (context, index) {
                                    return InvitationItem(invitation: invitations[index]);
                                  },
                                ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
