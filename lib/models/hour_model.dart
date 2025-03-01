class ForecastDay {
  final String date;
  final double maxTemp;
  final double minTemp;
  final String condition;
  final String iconUrl;
  final List<HourlyForecast> hourly;

  ForecastDay({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.condition,
    required this.iconUrl,
    required this.hourly,
  });

  factory ForecastDay.fromJson(Map<String, dynamic> json) {
    return ForecastDay(
      date: json['date'],
      maxTemp: json['day']['maxtemp_c'].toDouble(),
      minTemp: json['day']['mintemp_c'].toDouble(),
      condition: json['day']['condition']['text'],
      iconUrl: 'https:${json['day']['condition']['icon']}',
      hourly: (json['hour'] as List)
          .map((hourData) => HourlyForecast.fromJson(hourData))
          .toList(),
    );
  }
}

class HourlyForecast {
  final int hour;
  final double temperature;
  final String condition;
  final String iconUrl;

  HourlyForecast({
    required this.hour,
    required this.temperature,
    required this.condition,
    required this.iconUrl,
  });

  factory HourlyForecast.fromJson(Map<String, dynamic> json) {
    return HourlyForecast(
      hour: DateTime.parse(json['time']).hour,
      temperature: json['temp_c'].toDouble(),
      condition: json['condition']['text'],
      iconUrl: 'https:${json['condition']['icon']}',
    );
  }
}
