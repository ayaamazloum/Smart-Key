import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smart_key/utils/constants.dart';
import 'package:logger/logger.dart';

class API {
  final logger = Logger();

  _header() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };

  postRequest( {required String route, required Map<String, dynamic> data}) async {
    String url = apiUrl + route;

    try {
      return await http.post(Uri.parse(url),
          body: jsonEncode(data), headers: _header());
    } catch (e) {
      logger.e(e);
      return jsonEncode(e);
    }
  }
}
