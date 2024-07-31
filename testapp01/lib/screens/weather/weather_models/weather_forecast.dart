class Forecast {
  final int dateTime;
  final String description;
  final String icon;
  final double temperature;
  final double humidity;
  final double windSpeed;

  Forecast({

    required this.dateTime,
    required this.description,
    required this.icon,
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
  });

  factory Forecast.fromJson(Map<String, dynamic> json) {
    return Forecast(
      dateTime: DateTime.parse(json['dt_txt']).millisecondsSinceEpoch ~/ 1000,
      description: json['weather'] != null && json['weather'].isNotEmpty ? json['weather'][0]['description'] ?? '' : '',
      icon: json['weather'] != null && json['weather'].isNotEmpty ? json['weather'][0]['icon'] ?? '' : '',
      temperature: (json['main']['temp'] as num?)?.toDouble() ?? 0.0,
      humidity: (json['main']['humidity'] as num?)?.toDouble() ?? 0.0,
      windSpeed: (json['wind']['speed'] as num?)?.toDouble() ?? 0.0,

    );
  }
}
