import 'package:time_machine/time_machine.dart';

class CustomDateUtils {
  static String monthToString(int month) {
    String result = month.toString();
    if (month == 1) result += " месяц";
    if (month >= 2 && month <= 4)
      result += " месяца";
    else
      result += " месяцев";
    return result;
  }

  static String dayToString(int day) {
    String result = day.toString();
    if (day != 11 && day % 10 == 1) result += " день";
    if (!(day >= 12 && day <= 14) && day % 10 >= 2 && day % 10 <= 4)
      result += " дня";
    else
      result += " дней";
    return result;
  }

  static String monthsAndDaysBetweenDateNowAndDate(DateTime date) {
    Period diff = LocalDate.today().periodSince(LocalDate.dateTime(date));
    return monthToString(diff.months) + " " + dayToString(diff.days);
  }
}
