import 'package:mybabycheck_flutter/model/bornDate.dart';
import 'package:mybabycheck_flutter/model/sex.dart';

class Child {
  final String id;
  final String name;
  final Sex sex;
  final DateTime bornDate;
  final int bornWeek;
  Child(
      {required this.id,
      required this.name,
      required this.sex,
      required this.bornDate,
      required this.bornWeek});
  factory Child.fromJson(Map<String, dynamic> parsedJson) {
    BornDate jsonDate = BornDate.fromJson(parsedJson['born_date']);
    return Child(
        id: parsedJson['id'],
        name: parsedJson['name'],
        sex: (parsedJson['sex'].toString().compareTo("MALE")) == 0
            ? Sex.MALE
            : Sex.FEMALE,
        bornDate: DateTime.utc(jsonDate.year, jsonDate.month, jsonDate.day),
        bornWeek: parsedJson['born_week']);
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sex': sex,
      'born_date': bornDate,
      'born_week': bornWeek,
    };
  }
}
