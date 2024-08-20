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
  TextEditingController? cityController;
  Weather? _weather;
  bool _isLoading = true;

  // Fetch Weather Data
  fetchWeather() async {
    setState(() {
      _isLoading = true;
    });
    try {
      String city = await weatherService.getCurrentCityWeather();
      Weather weather = await weatherService.getWeather(city);

      setState(() {
        _weather = weather;
        _isLoading = false;
      });
    } catch (e) {
      developer.log(e.toString());
    }
  }

  // Fetch data on start
  @override
  void initState() {
    super.initState();
    cityController = TextEditingController();
    fetchWeather();
  }

  // Fetch weather data by city
  void searchBtnPressed() async {
    setState(() {
      _isLoading = true;
    });
    String cityName = cityController?.text ?? "";
    developer.log(cityName);
    try {
      if (cityName.trim().isNotEmpty) {
        setState(() {
          _isLoading = true;
        });
        Weather weather = await weatherService.getWeather(cityName);
        developer.log(weather.cityName);
        setState(() {
          _weather = weather;
          _isLoading = false;
        });
      } else {
        fetchWeather();
      }
    } catch (e) {
      developer.log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: OutlinedButton(
              onPressed: searchBtnPressed,
              child: const Icon(Icons.search),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: OutlinedButton(
              onPressed: fetchWeather,
              child: const Icon(Icons.location_on),
            ),
          ),
        ],
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            cursorColor: Colors.black,
            style: const TextStyle(color: Colors.black),
            decoration: const InputDecoration(
              label: Text(
                "City",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            maxLines: 1,
            controller: cityController,
          ),
        ),
      ),
      body: Center(
        child: _isLoading
            ? const Loading() // Show the loading animation while loading data
            : Padding(
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
                          _weather!.cityName,
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Lottie.asset(weatherService.getWeatherAnimation(
                          _weather!.main.toLowerCase(),
                        )),
                        Text(
                          _weather!.main,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _weather!.temperature.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 25,
                          ),
                        ),
                        const Text(
                          " °C",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child:
          Lottie.asset("assets/loading.json"), // Display the loading animation
    );
  }
}
