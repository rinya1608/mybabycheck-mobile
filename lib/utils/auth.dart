import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:mybabycheck_flutter/model/user.dart';

User? parsePosts(String responseBody) {
  if (responseBody.contains("error")) return null;
  Map<String, dynamic> userMap = json.decode(responseBody);
  return User.fromJson(userMap);
}

Future<User?> userLogin(
    http.Client client, String email, String password) async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi) {
    final response = await client.post(
        Uri.parse("http://192.168.0.109:80/api/user/auth"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body:
            jsonEncode(<String, String>{'email': email, 'password': password}));
    try {
      return parsePosts(response.body);
    } catch (Exception) {
      return null;
    }
  } else {
    return null;
  }
}

Future<String?> userRegistration(
    http.Client client, String email, String password) async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi) {
    final response = await client.post(
        Uri.parse("http://192.168.0.109:80/register"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body:
            jsonEncode(<String, String>{'login': email, 'password': password}));
    try {
      //print(response.body);
      return response.body;
    } catch (Exception) {
      return null;
    }
  } else {
    return null;
  }
}
