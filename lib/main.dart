import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/mainscreen.dart';
import 'package:flutter/services.dart';
import 'package:weather_app/provider/daily_provider.dart';
import 'package:weather_app/provider/hour_provider.dart';
import 'package:weather_app/provider/weather_provider.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WeatherProvider()),
        ChangeNotifierProvider(create: (_) => ForecastProvider()),
        ChangeNotifierProvider(create: (_) => DailyProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}
