class BornDate {
  final int year;
  final int month;
  final int day;
  BornDate({required this.year, required this.month, required this.day});

  factory BornDate.fromJson(Map<String, dynamic> parsedJson) {
    return BornDate(
        year: parsedJson['year'],
        month: parsedJson['month'],
        day: parsedJson['day']);
  }
}
