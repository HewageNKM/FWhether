import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:fwheather/models/weather.dart';
import 'package:fwheather/services/weather_service.dart';
import 'package:fwheather/services/weather_service_impl.dart';
import 'package:lottie/lottie.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final WeatherService weatherService = WeatherServiceImpl();
  Weather? _weather;

  //Fetch Weather Data
  fetchWeather() async {
    try {
      String city = await weatherService.getCurrentCityWeather();
      Weather weather = await weatherService.getWeather(city);

      setState(() {
        _weather = weather;
      });
    } catch (e) {
      developer.log(e.toString());
    }
  }

  //Fetch data on start
  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 30,
                  ),
                  Text(
                    _weather?.cityName ?? "City Loading....",
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Column(
                children: [
                  Lottie.asset(getWeatherAnimation(
                      _weather?.main.toLowerCase() ?? "clear")),
                  Text(
                    _weather?.main ?? "Conditions Loading....",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _weather?.temperature.toString() ?? "Temp Loading",
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 25),
                  ),
                  const Text(
                    " °C",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

String getWeatherAnimation(String condition) {
  switch (condition) {
    case "rain":
      return "assets/rain.json";
    case "snow":
      return "assets/snow.json";
    case "mist":
      return "assets/mist.json";
    case "thunderstorm":
      return "assets/thunderstorm.json";
    case "clouds":
      return "assets/clouds.json";
    case "clear":
      return "assets/clear.json";
    default:
      return condition;
  }
}
