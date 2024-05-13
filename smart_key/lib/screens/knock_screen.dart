import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:smart_key/main.dart';
import 'package:smart_key/services/api.dart';
import 'package:smart_key/utils/constants.dart';

class KncockScreen extends StatefulWidget {
  const KncockScreen({super.key});

  @override
  State<KncockScreen> createState() => KncockScreenState();
}

class KncockScreenState extends State<KncockScreen> {
  bool isLoading = false;
  String? secretKnock;

  @override
  void initState() {
    super.initState();
    fetchSecretKnock();
  }

  void fetchSecretKnock() async {
    setState(() {
      isLoading = true;
    });
    final result = await API(context: navigatorKey.currentContext!)
        .sendRequest(route: '/knock', method: 'get');
    final response = jsonDecode(result.body);

    setState(() {
      isLoading = false;
    });

    if (response['status'] == 'success') {
      setState(() {
        secretKnock = response['knock'];
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
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                  Navigator.pop(context);
                },
              ),
            ),
            Positioned(
                top: screenHeight(context) * 0.04,
                left: (screenWidth(context) - screenWidth(context) * 0.43) / 2,
                child: Text('Secret Knock',
                    style: Theme.of(context).textTheme.headlineLarge)),
            Container(
              padding: EdgeInsets.only(
                left: screenWidth(context) * 0.05,
                right: screenWidth(context) * 0.05,
              ),
              margin: EdgeInsets.only(top: screenHeight(context) * 0.19),
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                          Text(
                            'The green circle represents the knock while the yellow one represents the break point.',
                            style: Theme.of(context).textTheme.bodySmall,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: screenHeight(context) * 0.08),
                          Center(
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              children: secretKnock!.split('').map((char) {
                                Color color =
                                    char == '1' ? primaryColor : tertiaryColor;
                                return Padding(
                                  padding: EdgeInsets.all(4.0),
                                  child: CircleAvatar(
                                    radius: 10,
                                    backgroundColor: color,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          SizedBox(height: screenHeight(context) * 0.08),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed('/changeKnock');
                            },
                            child: Text(
                              'Change the secret knock',
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ]),
            )
          ],
        ),
      ),
    );
  }
}
