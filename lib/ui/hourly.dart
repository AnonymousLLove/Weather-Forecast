import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/provider/hour_provider.dart';

class HourlyForecastScreen extends StatefulWidget {
  const HourlyForecastScreen({super.key});

  @override
  _HourlyForecastScreenState createState() => _HourlyForecastScreenState();
}

class _HourlyForecastScreenState extends State<HourlyForecastScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchForecast();
    });
  }

  Future<void> _fetchForecast() async {
    final forecastProvider =
        Provider.of<ForecastProvider>(context, listen: false);

    await forecastProvider.fetchForecast();
  }

  @override
  Widget build(BuildContext context) {
    final forecastProvider = Provider.of<ForecastProvider>(context);
    final forecast = forecastProvider.forecast;
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xff081b25),
      body: forecastProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: forecast.isNotEmpty ? forecast[0].hourly.length : 0,
              itemBuilder: (context, index) {
                final hourlyForecast = forecast[0].hourly[index];
                final hourFormatted = DateFormat('HH:mm').format(
                    DateTime.now().add(Duration(hours: hourlyForecast.hour)));
                final isCurrentHour =
                    hourlyForecast.hour == DateTime.now().hour;
                final isFirstContainer = index == 0;

                return SizedBox(
                    width: screenSize.width * 0.25,
                    height: screenSize.height * 0.4,
                    child: Container(
                      width: screenSize.height * 0.2,
                      padding: const EdgeInsets.all(8.0),
                      margin: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        gradient: isFirstContainer
                            ? const LinearGradient(
                                colors: [
                                  Colors.purple,
                                  Color.fromARGB(255, 21, 93, 201)
                                ],
                              )
                            : (!isCurrentHour
                                ? const LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      Color.fromARGB(255, 21, 93, 201)
                                    ],
                                  )
                                : null),
                        border: Border.all(
                          color: Colors.white,
                          width: 2.0,
                        ),
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('${hourlyForecast.temperature}°C',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20)),
                            Image.network(hourlyForecast.iconUrl, width: 40),
                            Text(hourFormatted,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20)),
                          ]),
                    ));
              },
            ),
    );
  }
}
