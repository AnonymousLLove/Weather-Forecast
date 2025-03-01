import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/hour_model.dart';

class ForecastProvider with ChangeNotifier {
  List<ForecastDay> _forecast = [];
  bool _isLoading = false;

  List<ForecastDay> get forecast => _forecast;
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
        _forecast = (data['forecast']['forecastday'] as List)
            .map((day) => ForecastDay.fromJson(day))
            .toList();
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
