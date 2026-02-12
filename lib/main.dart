import 'package:flutter/material.dart';
import 'package:weatherapp/Weather/weatherAPI.dart';
import 'Weather/weather.dart';

void main() {
  runApp(WeatherApp());
}

class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WeatherAPI(),
      debugShowCheckedModeBanner: false,
    );
  }
}