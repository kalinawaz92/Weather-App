import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:weatherapp/Weather/Weekly/api_model_weekly.dart' as model;

class WeeklyWeather extends StatefulWidget {
  final String city;
  const WeeklyWeather({super.key, required this.city});

  @override
  State<WeeklyWeather> createState() => _WeeklyWeatherState();
}

class _WeeklyWeatherState extends State<WeeklyWeather> {
  model.WeatherWeekly? weatherWeekly;
  bool isLoading = false;

  Uri fetchWeekData(String cityName) {
    return Uri.parse(
      "https://api.weatherapi.com/v1/forecast.json?key=3282066549db4c8dbf1182159250611&q=$cityName&days=7&aqi=no&alerts=no",
    );
  }

  Future<void> fetchWeeklyData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(fetchWeekData(widget.city));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          weatherWeekly = model.WeatherWeekly.fromJson(data);
        });
      } else {
        throw Exception("Failed to fetch weekly data");
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchWeeklyData();
  }

  String formatDate(String date) {
    final dt = DateTime.parse(date);
    final weekdays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    final months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    return "${weekdays[dt.weekday - 1]}, ${dt.day} ${months[dt.month - 1]}";
  }

  @override
  Widget build(BuildContext context) {
    final firstDay = weatherWeekly?.forecastDays[0];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Forecasts",
          style: GoogleFonts.farro(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Color(0xFF6C9CFA),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
        child: SizedBox.expand(
          child: Stack(
            children: [
              Positioned(
                top: 0,
                right: 0,
                left: 0,
                child: Container(
                  height: 165,
                  width: 400,
                  color: Color(0xFF6C9CFA),
                ),
              ),
              Positioned(
                top: 130,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFF9FBFA),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 50,
                left: 25,
                right: 25,
                child: Column(
                  children: [
                    Container(
                      height: 230,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blueAccent,
                            blurRadius: 30,
                            blurStyle: BlurStyle.outer,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      height: 120,
                                      width: 120,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                            firstDay != null
                                                ? "assets/Images/WeatherIcons/${firstDay.conditionCode}day.png"
                                                : "assets/Images/WeatherIcons/1003day.png",
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Text(firstDay?.conditionText ?? ""),
                                  ],
                                ),
                                Column(
                                  children: [
                                    SizedBox(height: 30),
                                    Text(
                                      firstDay != null
                                          ? "${firstDay.avgTempC.toStringAsFixed(0)}°C"
                                          : "18°C",
                                      style: GoogleFonts.farro(
                                        fontSize: 55,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF95C4F0),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 15),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      height: 35,
                                      width: 35,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              "assets/Images/WeatherIcons/wind.png"),
                                        ),
                                      ),
                                    ),
                                    Text(firstDay != null
                                        ? "${firstDay.maxWindKph.toStringAsFixed(0)} km/h"
                                        : "32 km/h"),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Container(
                                      height: 35,
                                      width: 35,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              "assets/Images/WeatherIcons/humidity.png"),
                                        ),
                                      ),
                                    ),
                                    Text(firstDay != null
                                        ? "${firstDay.avgHumidity.toStringAsFixed(0)}%"
                                        : "50%"),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 330,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.only(top: 10),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF9FBFA),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: weatherWeekly == null
                      ? const Center(child: Text("No data available"))
                      : ListView.builder(
                    padding: const EdgeInsets.all(15),
                    itemCount: weatherWeekly!.forecastDays.length,
                    itemBuilder: (context, index) {
                      final day =
                      weatherWeekly!.forecastDays[index];
                      return Container(
                        height: 90,
                        width: double.infinity,
                        margin:
                        const EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.blueAccent,
                              blurStyle: BlurStyle.outer,
                              blurRadius: 3,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Text(
                                    formatDate(day.date),
                                    style: GoogleFonts.farro(
                                        fontSize: 17,
                                        fontWeight:
                                        FontWeight.w600),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "${day.minTempC.toStringAsFixed(0)}°",
                                        style: GoogleFonts.farro
                                            (
                                          color:
                                          Color(0xFF96C5F0),
                                          fontSize: 19,
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        "${day.maxTempC.toStringAsFixed(0)}°",
                                        style: GoogleFonts.farro
                                           (
                                          color:
                                          Color(0xFF7EA1E5),
                                          fontSize: 19,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(
                                                "assets/Images/WeatherIcons/${day.conditionCode}night.png"),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 7),
                                      Text(
                                        day.conditionText,
                                        style: GoogleFonts.farro(
                                            fontWeight:
                                            FontWeight.w300),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                          "${day.avgHumidity.toStringAsFixed(0)}%"),
                                      SizedBox(width: 7),
                                      Container(
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(
                                                "assets/Images/WeatherIcons/${day.conditionCode}night.png"),
                                            fit: BoxFit.cover,
                                          ),
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
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
