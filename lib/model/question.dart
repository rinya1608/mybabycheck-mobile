import 'package:enum_to_string/enum_to_string.dart';
import 'package:mybabycheck_flutter/model/EnumAnswers.dart';

class Question {
  final String id;
  final String text;
  EnumAnswers answer = EnumAnswers.NOT_SURE;
  Question({required this.id, required this.text});
  factory Question.fromJson(Map<String, dynamic> parsedJson) {
    return Question(id: parsedJson['id'], text: parsedJson['text']);
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'answer': EnumToString.convertToString(answer),
    };
  }
}
