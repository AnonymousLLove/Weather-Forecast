import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/mainscreen.dart';
import 'package:weather_app/models/daily_model.dart';
import 'package:weather_app/provider/daily_provider.dart';

class DailyForecastScreen extends StatefulWidget {
  const DailyForecastScreen({super.key});

  @override
  _DailyForecastScreenState createState() => _DailyForecastScreenState();
}

class _DailyForecastScreenState extends State<DailyForecastScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<DailyProvider>(context, listen: false).fetchForecast());
  }

  @override
  Widget build(BuildContext context) {
    final forecastProvider = Provider.of<DailyProvider>(context);
    final nextDayWeather = forecastProvider.nextDayWeather;
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xff081b25),
      body: SafeArea(
        child: Column(
          children: [
            // Next Day Forecast
            nextDayWeather == null
                ? const Center(child: CircularProgressIndicator())
                : Container(
                    height: screenSize.height * 0.26,
                    margin: const EdgeInsets.symmetric(horizontal: 18),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      gradient: const LinearGradient(
                        colors: [
                          Colors.purple,
                          Color.fromARGB(255, 21, 93, 201)
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        // Header
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const MainScreen(),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.arrow_back,
                                    color: Colors.white, size: 30),
                              ),
                              const Spacer(),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.calendar_month,
                                    color: Colors.white, size: 30),
                              ),
                              const Text(
                                '7 Days',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 10),
                            ],
                          ),
                        ),
                        // Next Day Weather Details
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.network(
                              'https:${nextDayWeather.conditionIcon}',
                              width: screenSize.width * 0.2,
                              height: screenSize.height * 0.12,
                              fit: BoxFit.fill,
                            ),
                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Tomorrow',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                Text(
                                  '${nextDayWeather.maxTemperature.toStringAsFixed(1)}°C',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 50,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  nextDayWeather.conditionText,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Divider(color: Colors.white),
                      ],
                    ),
                  ),

            // 7-Day Forecast List
            Expanded(
              child: forecastProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: forecastProvider.forecast.length,
                      itemBuilder: (context, index) {
                        DailyForecast forecast =
                            forecastProvider.forecast[index];

                        return Container(
                          height: 100,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 0),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    forecast.dayOfWeek,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Image.network(
                                          'https:${forecast.conditionIcon}',
                                          width: 50),
                                      const SizedBox(width: 10),
                                      Text(
                                        forecast.conditionText,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '${forecast.maxTemperature.toStringAsFixed(1)}°C',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(color: Colors.white),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
