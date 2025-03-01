import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import '../models/daily_model.dart';

class DailyProvider with ChangeNotifier {
  List<DailyForecast> _forecast = [];
  DailyForecast? _nextDayWeather;
  bool _isLoading = false;

  List<DailyForecast> get forecast => _forecast;
  DailyForecast? get nextDayWeather => _nextDayWeather;
  bool get isLoading => _isLoading;

  Future<void> fetchForecast() async {
    _isLoading = true;
    notifyListeners();

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      final latitude = position.latitude;
      final longitude = position.longitude;
      String apiKey = 'API KEY';

      final url = Uri.parse(
          'https://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$latitude,$longitude&days=7');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<DailyForecast> tempForecast =
            (data['forecast']['forecastday'] as List)
                .map((day) => DailyForecast.fromJson(day))
                .toList();

        _forecast = tempForecast;

        if (_forecast.length > 1) {
          _nextDayWeather = _forecast[1]; // Get tomorrow's weather (index 1)
        }
      } else {
        throw Exception('Failed to load forecast data');
      }
    } catch (e) {
      throw Exception("Error fetching forecast: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
