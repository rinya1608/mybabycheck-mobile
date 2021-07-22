import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:mybabycheck_flutter/model/child.dart';
import 'package:mybabycheck_flutter/model/news.dart';
import 'package:mybabycheck_flutter/model/user.dart';
import 'package:mybabycheck_flutter/utils/securityStorage.dart';

List<Child> parsePosts(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Child>((json) => Child.fromJson(json)).toList();
}

Child? parseChild(String responseBody) {
  if (responseBody.contains("error")) return null;
  Map<String, dynamic> childMap = json.decode(responseBody);
  return Child.fromJson(childMap);
}

Future<List<Child>?> fetchChilds(
    http.Client client, Future<String> futureUserJson) async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi) {
    bool userIsLogin = await SecurityStorage.storageContainsKey("user");
    print(userIsLogin);
    if (userIsLogin == false) return Future.value(null);
    String userJson = await futureUserJson;
    User user = User.fromJson(jsonDecode(userJson));
    final response =
        await client.post(Uri.parse("http://192.168.0.109:80/api/user/childs"),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{'id': user.id}));
    print(response.body);
    return compute(parsePosts, response.body);
  } else {
    return null;
  }
}

Future<Child?> fetchChild(http.Client client, String id) async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi) {
    final response = await client.get(
      Uri.parse("http://192.168.0.109:80/api/user/child?id=$id"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print(response.body);
    return parseChild(response.body);
  } else {
    return null;
  }
}

Future<String?> addChild(http.Client client, Future<String> futureUserJson,
    String name, String sex, String bornDate, String bornWeek) async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi) {
    String userJson = await futureUserJson;
    User user = User.fromJson(json.decode(userJson));
    final response = await client.post(
        Uri.parse("http://192.168.0.109:80//api/user/childs/add"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'parent_id': user.id,
          'name': name,
          'sex': sex,
          'born_date': bornDate,
          'born_week': bornWeek
        }));
    try {
      print(response.body);
      return response.body;
    } catch (Exception) {
      return null;
    }
  } else {
    return null;
  }
}

Future<String?> updateChild(
    http.Client client,
    Future<String> futureUserJson,
    String id,
    String name,
    String sex,
    String bornDate,
    String bornWeek) async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi) {
    String userJson = await futureUserJson;
    User user = User.fromJson(json.decode(userJson));
    String userId = user.id;
    final response = await client.post(
        Uri.parse("http://192.168.0.109:80//api/user/childs/update?id=$userId"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'id': id,
          'name': name,
          'sex': sex,
          'born_date': bornDate,
          'born_week': bornWeek
        }));
    try {
      print(response.body);
      return response.body;
    } catch (Exception) {
      return null;
    }
  } else {
    return null;
  }
}
