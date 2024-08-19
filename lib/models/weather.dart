class Weather {
  final String cityName;
  final double temperature;
  final String main;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.main,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      temperature: json['main']['temp'].toDouble(),
      main: json['weather'][0]['main'],
    );
  }
}
