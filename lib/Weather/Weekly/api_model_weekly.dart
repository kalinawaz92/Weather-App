class WeatherWeekly {
  final List<ForecastDay> forecastDays;

  WeatherWeekly({required this.forecastDays});

  factory WeatherWeekly.fromJson(Map<String, dynamic> json) {
    return WeatherWeekly(
      forecastDays: List<ForecastDay>.from(
        json['forecast']['forecastday'].map((x) => ForecastDay.fromJson(x)),
      ),
    );
  }
}

class ForecastDay {
  final String date;
  final double minTempC;
  final double maxTempC;
  final double avgTempC;
  final double maxWindKph;
  final double avgHumidity;
  final String conditionText;
  final int conditionCode;

  ForecastDay({
    required this.date,
    required this.minTempC,
    required this.maxTempC,
    required this.avgTempC,
    required this.maxWindKph,
    required this.avgHumidity,
    required this.conditionText,
    required this.conditionCode,
  });

  factory ForecastDay.fromJson(Map<String, dynamic> json) {
    return ForecastDay(
      date: json['date'],
      minTempC: (json['day']['mintemp_c'] as num).toDouble(),
      maxTempC: (json['day']['maxtemp_c'] as num).toDouble(),
      avgTempC: (json['day']['avgtemp_c'] as num).toDouble(),
      maxWindKph: (json['day']['maxwind_kph'] as num).toDouble(),
      avgHumidity: (json['day']['avghumidity'] as num).toDouble(),
      conditionText: json['day']['condition']['text'],
      conditionCode: json['day']['condition']['code'],
    );
  }
}
