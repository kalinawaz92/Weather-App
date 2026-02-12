
class weatherHourly {
  final time;
  final temp;
  final int conditionCode;
  final String isDay;

  weatherHourly({
    required this.conditionCode,
    required this.isDay,
    required this.temp,
    required this.time,
  });

  factory weatherHourly.fromJson(Map<String, dynamic> json){
    final isDay = json['is_day'] == 1 ? 'day' : 'night';
    return weatherHourly(
        conditionCode: json['condition']['code'],
        isDay: isDay,
        temp: json['temp_c'],
        time: json['time'],
    );
  }

}