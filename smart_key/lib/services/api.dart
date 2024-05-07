import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smart_key/utils/constants.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class API {
  final logger = Logger();
  late SharedPreferences preferences;
  late BuildContext context;

  API({required this.context});

  postRequest(
      {required String route, required Map<String, dynamic> data}) async {
    String url = apiUrl + route;
    preferences = await SharedPreferences.getInstance();
    String token = preferences.getString('token') ?? '';
    logger.i(token);

    try {
      http.Response response =
          await http.post(Uri.parse(url), body: jsonEncode(data), headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      logger.i(response);
      
      Map<String, dynamic> res = jsonDecode(response.body);
      
      if (res['message'] == 'Invitation expired.') {
        await preferences.clear();
        navigateToLoginScreen();
      }

      return response;
    } catch (e) {
      logger.e(e);
      return jsonEncode(e);
    }
  }

  navigateToLoginScreen() {
    Navigator.pushReplacementNamed(context, '/login');
  }
}
