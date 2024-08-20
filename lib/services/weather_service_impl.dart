import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fwheather/models/weather.dart';
import 'package:fwheather/services/weather_service.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class WeatherServiceImpl implements WeatherService {
  final String BASE_URL = dotenv.get("BASE_URL");
  final String API_KEY = dotenv.get("API_KEY");

  @override
  Future<Weather> getWeather(String city) async {
    var response = await http
        .get(Uri.parse('$BASE_URL?q=$city&appid=$API_KEY&units=metric'));
    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  @override
  Future<String> getCurrentCityWeather() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied){
       await Geolocator.requestPermission();
    }

    Position position = await Geolocator.getCurrentPosition(locationSettings: const LocationSettings(accuracy: LocationAccuracy.high));

    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

    String? city = placemarks[0].locality;

    return city ?? "";
  }

  @override
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
}
