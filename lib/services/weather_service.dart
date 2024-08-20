import '../models/weather.dart';

abstract interface class WeatherService {
  Future<Weather> getWeather(String city);
  Future<String> getCurrentCityWeather();
  String getWeatherAnimation(String condition);
}