import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherProvider with ChangeNotifier {
  Weather? _weather;
  bool _isLoading = false;

  Weather? get weather => _weather;
  bool get isLoading => _isLoading;

  Future<void> fetchWeather(double latitude, double longitude) async {
    _isLoading = true;
    notifyListeners();

    const String apiKey = 'API KEY';
    final url = Uri.parse(
        'https://api.weatherapi.com/v1/current.json?key=$apiKey&q=$latitude,$longitude');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _weather = Weather.fromJson(data);
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      throw Exception('An error occured: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
