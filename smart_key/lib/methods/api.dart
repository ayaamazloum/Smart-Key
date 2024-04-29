import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smart_key/utils/constants.dart';

class API {
  _header() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };

  postRequest(
      {required String route, required Map<String, dynamic> data}) async {
    String url = apiUrl + route;

    try {
      return await http.post(Uri.parse(url),
          body: jsonEncode(data), headers: _header());
    } catch (e) {
      return jsonEncode(e);
    }
  }
}
