import 'package:flutter/material.dart';
import 'package:fwheather/models/weather.dart';
import 'package:fwheather/services/weather_service.dart';
import 'package:fwheather/services/weather_service_impl.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final WeatherService weatherService = WeatherServiceImpl();
  Weather? weather;

  //Fetch Weather Data
  fetchWeather() async {
    String city = await weatherService.getCurrentCityWeather();
    Weather weather = await weatherService.getWeather(city);

    weather = weather;
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
        title: const Text('Home'),
      ),
      body: const Center(
        child: Column(
          children: [Text(""), Text("")],
        ),
      ),
    );
  }
}
