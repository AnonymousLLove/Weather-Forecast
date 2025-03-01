class Weather {
  final String cityName;
  final double temperature;
  final String condition;
  final String iconUrl;
  final int humidity; // Humidity is an integer
  final String direction; // Wind direction is a string
  final double speed;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.condition,
    required this.iconUrl,
    required this.humidity,
    required this.direction,
    required this.speed,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['location']['name'],
      temperature: json['current']['temp_c'].toDouble(),
      condition: json['current']['condition']['text'],
      iconUrl: 'https:${json['current']['condition']['icon']}',
      humidity: json['current']
          ['humidity'], // No need to convert, it's already an int
      direction: json['current']['wind_dir'], // Wind direction is a string
      speed: json['current']['wind_mph'].toDouble(),
    );
  }
}
