import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:mybabycheck_flutter/model/EnumAnswers.dart';
import 'package:mybabycheck_flutter/model/theme.dart';
import 'package:mybabycheck_flutter/model/news.dart';
import 'package:mybabycheck_flutter/model/question.dart';

List<ThemeModel> parseTheme(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<ThemeModel>((json) => ThemeModel.fromJson(json)).toList();
}

Map<String, String> parseAnswers(String responseBody) {
  var dataSp = responseBody.replaceAll(RegExp("[\{\"\}]"), "").split(',');
  Map<String, String> mapData = Map();
  try {
    dataSp.forEach(
        (element) => mapData[element.split(':')[0]] = element.split(':')[1]);
  } catch (Exception) {}
  return mapData;
}

Future<List<ThemeModel>?> fetchTheme(http.Client client, String month) async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi) {
    final response = await client.post(
      Uri.parse("http://192.168.0.109:80/api/test/questions?month=$month"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    //print(response.body);
    return parseTheme(response.body);
  } else {
    return null;
  }
}

Future<String?> sendAnswers(
    http.Client client, String childId, List<Question> questions) async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi) {
    final response = await client.post(
        Uri.parse("http://192.168.0.109:80/api/test/answers/save?id=$childId"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(questions));
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

Future<List<ThemeModel>?> fetchThemeWithAnswers(
    http.Client client, String month, String id) async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi) {
    final responseTheme = await client.post(
      Uri.parse("http://192.168.0.109:80/api/test/questions?month=$month"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    final responseAnswers = await client.get(Uri.parse(
        "http://192.168.0.109:80/api/test/answers?month=$month&id=$id&"));

    var themesList = parseTheme(responseTheme.body);
    var answersMap = parseAnswers(responseAnswers.body);
    themesList.forEach((theme) => {
          theme.questions.forEach((question) => {
                if (answersMap.containsKey(question.id))
                  {
                    question.answer =
                        answersMap[question.id]!.compareTo("YES") == 0
                            ? EnumAnswers.YES
                            : (answersMap[question.id]!.compareTo("NO") == 0
                                ? EnumAnswers.NO
                                : EnumAnswers.NOT_SURE),
                  }
              })
        });
    return themesList;
  } else {
    return null;
  }
}

Future<Map<String, String>?> fetchAnswers(
    http.Client client, String month, String id) async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi) {
    final response = await client.get(Uri.parse(
        "http://192.168.0.109:80/api/test/answers?month=$month&id=$id&"));
    //print(response.body);
    return parseAnswers(response.body);
  } else {
    return null;
  }
}
