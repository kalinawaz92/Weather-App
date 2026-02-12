import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weatherapp/Weather/Weekly/weeklyWeather.dart';
import 'package:weatherapp/Weather/api_model.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class WeatherAPI extends StatefulWidget {
  const WeatherAPI({super.key});

  @override
  State<WeatherAPI> createState() => _WeatherAPIState();
}

class _WeatherAPIState extends State<WeatherAPI> {

  bool showSearch = false;
  String city = "";
  final TextEditingController cityControl = TextEditingController();
  Weather? weather;
  bool isLoading = false;

  Uri fetchData(String cityName){
    // return Uri.parse("https://api.openweathermap.org/data/2.5/weather?q=${cityName}&appid=0351a803db5fb9909d490aea340b481d&units=metric");
    return Uri.parse("http://api.weatherapi.com/v1/forecast.json?key=3282066549db4c8dbf1182159250611&q=$cityName&days=1&aqi=no&alerts=no");
  }


Future<dynamic> fetchWeather() async{
  setState(() {
    isLoading = true;
  });
  try {
  final response = await http.get(fetchData(city));
  if(response.statusCode == 200){
    final data = jsonDecode(response.body);
    setState(() {
      weather = Weather.fromJson(data);
    });
  } else {
    throw Exception("Failed to load Data!");
  }
  } catch (e){
    throw Exception("Failed to load Data!");
  } finally {
    setState(() {
      isLoading = false;
    });
  }
}

  Widget showHourlyForecast() {
    if (weather == null || weather!.hourly.isEmpty) {
      return const Center(child: Text(''));
    }

    final now = DateTime.parse(weather!.localtime);

    weather!.hourly.sort(
          (a, b) => DateTime.parse(a.time).compareTo(DateTime.parse(b.time)),
    );

    final next24Hours = <dynamic>[];
    for (final hour in weather!.hourly) {
      final forecastTime = DateTime.parse(hour.time);
      if (forecastTime.isAfter(now.subtract(const Duration(hours: 1))) &&
          forecastTime.isBefore(now.add(const Duration(hours: 24)))) {
        next24Hours.add(hour);
      }
    }

    if (next24Hours.length < 24) {
      final extraNeeded = 24 - next24Hours.length;
      final remaining = weather!.hourly.take(extraNeeded).toList();
      next24Hours.addAll(remaining);
    }

    String formatHour(DateTime time) {
      final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
      final period = time.hour >= 12 ? 'PM' : 'AM';
      return "$hour $period";
    }

    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: next24Hours.length,
        itemBuilder: (context, index) {
          final hour = next24Hours[index];
          final forecastTime = DateTime.parse(hour.time);
          final displayTime =
          forecastTime.hour == now.hour ? "Now" : formatHour(forecastTime);

          final iconPath =
              'assets/Images/WeatherIcons/${hour.conditionCode}${hour.isDay}.png';

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              height: 120,
              width: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF62cff4),
                    Color(0xFF2c67f2),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                boxShadow: const [
                  BoxShadow(
                    blurStyle: BlurStyle.solid,
                    color: Colors.blueAccent,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    displayTime,
                    style: GoogleFonts.farro(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 5),
                  Image.asset(
                    iconPath,
                    width: 40,
                    height: 40,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/Images/WeatherIcons/default.png',
                        width: 40,
                        height: 40,
                      );
                    },
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "${hour.temp.toStringAsFixed(1)}°C",
                    style: GoogleFonts.farro(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget showWeatherData() {
    return Container(
      height: 530,
      width: 340,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF62cff4),
            Color(0xFF2c67f2),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFF62cff4),
            blurStyle: BlurStyle.outer,
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: showSearch
                ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_on, color: Colors.white, size: 18),
                const SizedBox(width: 6),
                Expanded(
                  child: TextField(
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white),
                    controller: cityControl,
                    decoration: InputDecoration(
                      hintText: "Enter City Name",
                      hintStyle: GoogleFonts.arOneSans(color: Colors.white54),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    autofocus: true,
                    onSubmitted: (value) {
                      if (value.trim().isNotEmpty) {
                        setState(() {
                          city = value.trim();
                          showSearch = false;
                          cityControl.clear();
                        });
                        fetchWeather();
                      } else {
                        setState(() {
                          showSearch = false;
                        });
                      }
                    },
                  ),
                ),
              ],
            )
                : GestureDetector(
              onTap: () {
                setState(() {
                  showSearch = true;
                });
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.location_on, color: Colors.white, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    city.isNotEmpty ? city : "Weather",
                    style: GoogleFonts.farro(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down, color: Colors.white),
                ],
              ),
            ),
          ),

          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : weather == null
                ? const Center(
              child: Text(
                "No data available",
                style: TextStyle(color: Colors.white),
              ),
            )
                : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 220,
                  width: 220,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        'assets/Images/WeatherIcons/${weather!.conditionCode}${weather!.isDay}.png',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Text(
                  "${weather!.temperature.toStringAsFixed(1)}°C",
                  style: GoogleFonts.farro(
                    color: Colors.white,
                    fontSize: 50,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  weather!.weather,
                  style: GoogleFonts.farro(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "Feels like ${weather!.feelsLike.toStringAsFixed(1)}°C",
                  style: GoogleFonts.farro(
                    color: Colors.white,
                    fontSize: 25,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.wind_power, color: Colors.white),
                    Text(
                      " ${weather!.wind.toStringAsFixed(1)} mph",
                      style: GoogleFonts.farro(
                        color: Colors.white,
                        fontSize: 25,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  @override
  void initState() {
    super.initState();
    _determinePosition(); // automatically fetch location on start
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // Get current position
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Reverse geocoding to get city name
    List<Placemark> placemarks =
    await placemarkFromCoordinates(position.latitude, position.longitude);

    if (placemarks.isNotEmpty) {
      setState(() {
        city = placemarks.first.locality ?? "Unknown";
      });
      fetchWeather(); // fetch weather automatically
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          const SizedBox(height: 70),
          showWeatherData(),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 27,
                    child: Text(
                      "Today",
                      style: GoogleFonts.farro(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => WeeklyWeather(city: city),));
                      },
                      child: Text("Weekly Data"))
                ],
              ),
            ),
          ),
          Container(
            child: showHourlyForecast(),
          ),
        ],
      )
    );
  }
}
