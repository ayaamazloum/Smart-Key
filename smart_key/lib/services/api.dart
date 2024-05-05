import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smart_key/utils/constants.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class API {
  final logger = Logger();
  late SharedPreferences preferences;

  postRequest(
      {required String route, required Map<String, dynamic> data}) async {
    String url = apiUrl + route;
    preferences = await SharedPreferences.getInstance();
    String token = preferences.getString('token') ?? '';
    logger.i(token);

    try {
      return await http.post(Uri.parse(url), body: jsonEncode(data), headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
    } catch (e) {
      logger.e(e);
      return jsonEncode(e);
    }
  }
}
