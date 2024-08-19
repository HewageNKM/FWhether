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
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Center(child: Text('FWeather')),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_weather?.cityName ?? "City Loading...."),
            Lottie.asset(""),
            Text(_weather?.main ?? "Conditions Loading...."),
            Text(_weather?.temperature.toString() ?? "Temperature Loading....")
          ],
        ),
      ),
    );
  }
}
