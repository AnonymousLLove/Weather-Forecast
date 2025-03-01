import 'package:intl/intl.dart';

class DailyForecast {
  final String dayOfWeek;
  final double maxTemperature;
  final String conditionText;
  final String conditionIcon;

  DailyForecast({
    required this.dayOfWeek,
    required this.maxTemperature,
    required this.conditionText,
    required this.conditionIcon,
  });

  factory DailyForecast.fromJson(Map<String, dynamic> json) {
    final date = DateTime.parse(json['date']);
    final dayOfWeek = DateFormat.E().format(date); // e.g., Mon, Tue, etc.

    return DailyForecast(
      dayOfWeek: dayOfWeek,
      maxTemperature: json['day']['maxtemp_c'].toDouble(),
      conditionText: json['day']['condition']['text'],
      conditionIcon: json['day']['condition']['icon'],
    );
  }
}
