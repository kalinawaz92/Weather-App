// class Weather {
//   final name;
//   final temprature;
//   final feelsLikeTemp;
//   final weather;
//   final wind;
//
//
//   Weather({
//     required this.name,
//     required this.temprature,
//     required this.feelsLikeTemp,
//     required this.weather,
//     required this.wind,
//
//   });
//
//   factory Weather.fromJson(Map<String, dynamic> json){
//     return Weather(
//     name: json['name'],
//     temprature: json['main']['temp'].toDouble(),
//     feelsLikeTemp: json['main']['feels_like'].toDouble(),
//     weather: json['weather'][0]['description'],
//     wind: json['wind']['speed'].toDouble(),
//   );
//   }
//
// }


import 'package:weatherapp/Weather/api_model_hourly.dart';

class Weather {
  final String name;
  final double temperature;
  final double feelsLike;
  final double wind;
  final String weather;
  final int conditionCode;
  final String isDay;
  final List<weatherHourly> hourly;
  final String localtime;

  Weather({
    required this.name,
    required this.temperature,
    required this.feelsLike,
    required this.wind,
    required this.weather,
    required this.conditionCode,
    required this.isDay,
    required this.hourly,
    required this.localtime,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    final forecast = json['forecast'];
    final forecastDays = forecast['forecastday'] as List;

    List<weatherHourly> hourlyData = [];
    if (forecastDays.isNotEmpty) {
      final hour = forecastDays[0]['hour'] as List;
      hourlyData = hour.map((h) => weatherHourly.fromJson(h)).toList();
    }

    final current = json['current'];

    return Weather(
      name: json['location']['name'],
      temperature: current['temp_c'].toDouble(),
      feelsLike: current['feelslike_c'].toDouble(),
      wind: current['wind_mph'].toDouble(),
      weather: current['condition']['text'],
      conditionCode: current['condition']['code'],
      isDay: current['is_day'] == 1 ? 'day' : 'night',
      localtime: json['location']['localtime'], // ✅ correct field
      hourly: hourlyData,
    );
  }
}
