import 'dart:convert';

import 'package:llo/model.dart';
import 'package:http/http.dart' as http;

class ApiHandler {
  final String baseUri = "http://192.168.1.13:8080/api/Queue1";

  Future<List<queue1>> getUserData() async {
    List<queue1> data = [];

    final uri = Uri.parse(baseUri);
    try {
      final response = await http.get(
        uri,
        headers: <String, String>{
          'Content-type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        final List<dynamic> jsonData = json.decode(response.body);
        data = jsonData.map((json) => queue1.fromJson(json)).toList();
      }
    } catch (e) {
      print(data);
    }
    return data;
  }
}
