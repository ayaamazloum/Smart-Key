import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:smart_key/main.dart';
import 'package:smart_key/services/api.dart';

class KncockScreen extends StatefulWidget {
  const KncockScreen({super.key});

  @override
  State<KncockScreen> createState() => KncockScreenState();
}

class KncockScreenState extends State<KncockScreen> {
  bool isLoading = false;
  String? secretKnock;
  final logger = Logger();

  @override
  @override
  void initState() {
    super.initState();
    fetchSecretKnock();
  }

  void fetchSecretKnock() async {
    final result = await API(context: navigatorKey.currentContext!)
        .sendRequest(route: '/knock', method: 'get');
    final response = jsonDecode(result.body);
    logger.i(response);

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

  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
