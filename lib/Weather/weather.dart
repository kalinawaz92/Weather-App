import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '/Weather/api_model.dart' as model;

class Weather extends StatefulWidget {
  const Weather({super.key});

  @override
  State<Weather> createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {

  bool showSearch = false;
  final TextEditingController cityControl = TextEditingController();
  var city = "";
  model.Weather? weather;
  bool isLoading = false;

  Uri WeatherData(String cityName){
    return Uri.parse("https://api.openweathermap.org/data/2.5/weather?q=${cityName}&appid=0351a803db5fb9909d490aea340b481d&units=metric");
  }

  Future<void> fetchWeatherData() async{
    setState(() {
      isLoading = true;
    });
    try{
      final response = await http.get(WeatherData(city));
     if(response.statusCode == 200){
       final data = jsonDecode(response.body);
       setState(() {
         weather = model.Weather.fromJson(data);
       });
     } else {
       throw Exception("Failed to Load data!");
     }
    } catch (e){
      throw Exception("failed to Load data!");
    }
    setState(() {
      isLoading = false;
    });
  }


   dynamic showTitle(){
    if(city == "" || city == null){
      return Text("Weather", style: GoogleFonts.arOneSans(
          color: Colors.white,
          fontSize: 25
      ),);
    } else {
      return Text(weather!.name, style: GoogleFonts.arOneSans(
          color: Colors.white,
          fontSize: 25
      ),);
    }
  }

  @override

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchWeatherData();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFF1C1B1F),
      appBar: AppBar(
        backgroundColor: Color(0xFFFF121212),
        title: showSearch ?
        TextField(
          controller: cityControl,
          style: TextStyle(
            color: Colors.white
          ),
          decoration: InputDecoration(
              hint: Text("Enter City Name",style: GoogleFonts.arOneSans(
                color: Colors.white,
              ),
              ),
              border: InputBorder.none
          ),
          onChanged: (value) => city = value,
          onSubmitted: (value) {
            if(value.trim().isNotEmpty){
              setState(() {
                city = value.trim();
                showSearch = false;
                cityControl.clear();
              });
              fetchWeatherData();
            }
          },
        ) : showTitle(),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  showSearch = !showSearch;
                  cityControl.clear();
                });
              },
              icon: Icon(Icons.search, color: Colors.white,))
        ],
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              // ElevatedButton(
              //   onPressed: fetchWeatherData,
              //   child: const Text("Get Weather"),
              // ),
              const SizedBox(height: 20),
              if (isLoading) const CircularProgressIndicator(),
              if (!isLoading && weather != null) ...[
                // Text(
                //   weather!.name,
                //   style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold,  color: Colors.white),
                // ),

                Text(
                  "Temperature ${weather!.temperature.toStringAsFixed(1)}°C",
                  style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Text(
                  "Feels Like: ${weather!.feelsLike.toStringAsFixed(1)}°C",
                  style: const TextStyle(fontSize: 18,  color: Colors.white),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}



//
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:http/http.dart' as http;
// import '/Weather/api_model.dart' as model;
//
// class Weather extends StatefulWidget {
//   const Weather({super.key});
//
//   @override
//   State<Weather> createState() => _WeatherState();
// }
//
// class _WeatherState extends State<Weather> {
//   bool showSearch = false;
//   final TextEditingController cityControl = TextEditingController();
//   var city = "";
//   model.Weather? weather;
//   bool isLoading = false;
//
//   Uri _weatherData(String cityName) {
//     return Uri.parse(
//         "https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=0351a803db5fb9909d490aea340b481d&units=metric");
//   }
//
//   Future<void> fetchWeatherData() async {
//     if (city.isEmpty) return;
//
//     setState(() {
//       isLoading = true;
//     });
//
//     try {
//       final response = await http.get(_weatherData(city));
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         setState(() {
//           weather = model.Weather.fromJson(data);
//         });
//       } else {
//         throw Exception("Failed to load weather data!");
//       }
//     } catch (e) {
//       throw Exception("Failed to load weather data: $e");
//     }
//
//     setState(() {
//       isLoading = false;
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     // Initial fetch can be added here if you want a default city
//   }
//
//   Widget _buildTitle() {
//     if (weather?.name == null) {
//       return Text(
//         "Weather",
//         style: GoogleFonts.arOneSans(
//           color: Colors.white,
//           fontSize: 25,
//         ),
//       );
//     } else {
//       return Text(
//         weather!.name,
//         style: GoogleFonts.arOneSans(
//           color: Colors.white,
//           fontSize: 25,
//         ),
//       );
//     }
//   }
//
//   Widget _buildWeatherContent() {
//     if (isLoading) {
//       return const CircularProgressIndicator(
//         color: Colors.white,
//       );
//     }
//
//     if (weather == null) {
//       return Text(
//         "Search for a city",
//         style: GoogleFonts.arOneSans(
//           color: Colors.white54,
//           fontSize: 18,
//         ),
//       );
//     }
//
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         // Temperature - Large and prominent
//         Text(
//           "${weather!.temprature.toStringAsFixed(0)}°",
//           style: GoogleFonts.roboto(
//             color: const Color(0xFFFFCC00), // Vibrant yellow for temperature
//             fontSize: 64,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         const SizedBox(height: 8),
//
//         // City Name
//         Text(
//           weather!.name,
//           style: GoogleFonts.roboto(
//             color: Colors.white,
//             fontSize: 24,
//             fontWeight: FontWeight.w400,
//           ),
//         ),
//         const SizedBox(height: 16),
//
//         // Weather Condition
//         Text(
//           _capitalizeFirst(weather!.weather ?? ""),
//           style: GoogleFonts.roboto(
//             color: Colors.white,
//             fontSize: 18,
//           ),
//         ),
//         const SizedBox(height: 8),
//
//         // Feels Like Temperature
//         Text(
//           "Feels like ${weather!.feelsLikeTemp.toStringAsFixed(0)}°",
//           style: GoogleFonts.roboto(
//             color: const Color(0xFFC5C6D0), // Light gray for secondary info
//             fontSize: 16,
//           ),
//         ),
//       ],
//     );
//   }
//
//   String _capitalizeFirst(String text) {
//     if (text.isEmpty) return text;
//     return text[0].toUpperCase() + text.substring(1).toLowerCase();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF1C1B1F), // Dark background
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF121212), // Darker app bar
//         title: showSearch
//             ? TextField(
//           controller: cityControl,
//           style: const TextStyle(color: Colors.white),
//           decoration: InputDecoration(
//             hintText: "Enter City Name",
//             hintStyle: GoogleFonts.arOneSans(
//               color: Colors.white54,
//             ),
//             border: InputBorder.none,
//           ),
//           onChanged: (value) => city = value,
//           onSubmitted: (value) {
//             if (value.trim().isNotEmpty) {
//               setState(() {
//                 city = value.trim();
//                 showSearch = false;
//                 cityControl.clear();
//               });
//               fetchWeatherData();
//             }
//           },
//         )
//             : _buildTitle(),
//         actions: [
//           IconButton(
//             onPressed: () {
//               setState(() {
//                 showSearch = !showSearch;
//                 if (!showSearch) {
//                   cityControl.clear();
//                 }
//               });
//             },
//             icon: Icon(
//               showSearch ? Icons.close : Icons.search,
//               color: Colors.white,
//             ),
//           ),
//         ],
//         centerTitle: true,
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(24),
//           child: _buildWeatherContent(),
//         ),
//       ),
//     );
//   }
// }
