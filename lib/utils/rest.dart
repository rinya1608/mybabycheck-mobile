import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:mybabycheck_flutter/model/news.dart';

List<News> parsePosts(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<News>((json) => News.fromJson(json)).toList();
}

Future<List<News>?> fetchNews(http.Client client) async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi) {
    final response =
        await client.get(Uri.parse("http://192.168.0.109:80/api/news"));
    //print(response.body);
    return compute(parsePosts, response.body);
  } else {
    return null;
  }
}
