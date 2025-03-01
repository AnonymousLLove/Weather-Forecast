import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/provider/weather_provider.dart';
import 'package:weather_app/ui/daily.dart';
import 'package:weather_app/ui/hourly.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String date = DateFormat("yMMMMd").format(DateTime.now());
  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Fetch weather with user's location
    Provider.of<WeatherProvider>(context, listen: false)
        .fetchWeather(position.latitude, position.longitude);
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);
    final weather = weatherProvider.weather;
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: const Color(0xff081b25),
        body: SafeArea(
          child: Center(
            child: weatherProvider.isLoading
                ? const CircularProgressIndicator()
                : weather != null
                    ? Column(
                        children: [
                          Container(
                              height: screenSize.height * 0.63,
                              width: screenSize.width * 0.9,
                              margin:
                                  const EdgeInsets.only(right: 18, left: 18),
                              decoration: BoxDecoration(
                                  color: Colors.purple,
                                  borderRadius: BorderRadius.circular(40),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Colors.purple,
                                      Color.fromARGB(255, 21, 93, 201)
                                    ],
                                  )),
                              child: Column(
                                children: [
                                  const SizedBox(height: 20),
                                  Text(weather.cityName,
                                      style: const TextStyle(
                                          fontSize: 45,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                  const SizedBox(height: 8),
                                  Text(date,
                                      style: const TextStyle(
                                          fontSize: 22, color: Colors.white)),
                                  SizedBox(
                                    height: 200,
                                    child: Image.network(weather.iconUrl,
                                        fit: BoxFit.cover),
                                  ),
                                  Text(weather.condition,
                                      style: const TextStyle(
                                          fontSize: 30, color: Colors.white)),
                                  const SizedBox(height: 10),
                                  Text('${weather.temperature}°C',
                                      style: const TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 20.0),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                                height: 70,
                                                child: Image.asset(
                                                  'assets/icon/humidity.png',
                                                  fit: BoxFit.cover,
                                                )),
                                            const Text('humidity',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white)),
                                            const SizedBox(height: 10),
                                            Text(weather.humidity.toString(),
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white)),
                                          ],
                                        ),
                                      ),
                                      const Spacer(),
                                      Column(
                                        children: [
                                          SizedBox(
                                              height: 70,
                                              child: Image.asset(
                                                'assets/icon/wind2.png',
                                                fit: BoxFit.cover,
                                              )),
                                          const Text('direction',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white)),
                                          const SizedBox(height: 10),
                                          Text(weather.direction,
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white)),
                                        ],
                                      ),
                                      const Spacer(),
                                      Padding(
                                          padding: const EdgeInsets.only(
                                              right: 20.0),
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                  height: 70,
                                                  child: Image.asset(
                                                    'assets/icon/wind.png',
                                                    fit: BoxFit.cover,
                                                  )),
                                              const Text('speed',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white)),
                                              const SizedBox(height: 10),
                                              Text('${weather.speed}mph',
                                                  style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white)),
                                              const SizedBox(height: 5),
                                            ],
                                          )),
                                    ],
                                  )
                                ],
                              )),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: [
                                const Text('Today',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20)),
                                const Spacer(),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const DailyForecastScreen()));
                                  },
                                  child: const Row(
                                    children: [
                                      Text('7 days',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20)),
                                      Icon(Icons.arrow_forward_ios,
                                          color: Colors.white)
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Container(
                                color: const Color(0xff081b25),
                                height: 170,
                                child: const HourlyForecastScreen()),
                          ),
                        ],
                      )
                    : const Text(
                        'Failed to load weather data',
                        style: TextStyle(color: Colors.white),
                      ),
          ),
        ));
  }
}
