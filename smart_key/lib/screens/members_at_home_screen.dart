import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:smart_key/main.dart';
import 'package:smart_key/services/api.dart';
import 'package:smart_key/utils/constants.dart';

class HomeMembersScreen extends StatefulWidget {
  const HomeMembersScreen({super.key});

  @override
  State<HomeMembersScreen> createState() => _HomeMembersScreenState();
}

class _HomeMembersScreenState extends State<HomeMembersScreen> {
  List<String> members = [];

  final logger = Logger();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    fetchMembers();
  }

  void fetchMembers() async {
    final result = await API(context: navigatorKey.currentContext!)
        .sendRequest(route: '/membersAtHome', method: 'get');
    final response = jsonDecode(result.body);
    logger.i(response);

    setState(() {
      isLoading = false;
    });

    if (response['status'] == 'success') {
      setState(() {
        members = List<String>.from(response['members']);
        logger.i(members);
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
                  'assets/images/screen_shape_2.png',
                  width: screenWidth(context) * 0.35,
                  fit: BoxFit.contain,
                ),
              ),
              Positioned(
                top: screenHeight(context) * 0.04,
                left: (screenWidth(context) - screenWidth(context) * 0.56) / 2,
                child: Text(
                  'Members At Home',
                  style: Theme.of(context).textTheme.headlineLarge,
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
              Positioned(
                top: screenHeight(context) * 0.04,
                left: 10,
                child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(
                        context); // Navigate back to the previous screen
                  },
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
                          : members.isEmpty
                              ? Center(child: Text('No members at home.'))
                              : ListView.builder(
                                  itemCount: members.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                        padding: EdgeInsets.all(10),
                                        margin: EdgeInsets.only(bottom: 20),
                                        decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey.shade300,
                                                  width: 1)),
                                        ),
                                        child: Text(members[index],
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium));
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
