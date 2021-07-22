import 'package:mybabycheck_flutter/model/question.dart';

class ThemeModel {
  final String title;
  final List<Question> questions;
  ThemeModel({required this.title, required this.questions});
  factory ThemeModel.fromJson(Map<String, dynamic> parsedJson) {
    return ThemeModel(
        title: parsedJson['title'],
        questions: parsedJson['questions']
            .map<Question>((json) => Question.fromJson(json))
            .toList());
  }
}
