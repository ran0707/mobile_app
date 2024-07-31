class Weather {
  final int id;
  final String main;
  final String description;
  final String icon;
  final double temperature;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final double pressure;
  final double humidity;
  final int visibility;
  final double windSpeed;
  final double windGust;
  final int windDeg;
  final int cloudiness;
  final int sunrise;
  final int sunset;
  final int conditionCode;

  Weather({
    required this.id,
    required this.main,
    required this.description,
    required this.icon,
    required this.temperature,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.pressure,
    required this.humidity,
    required this.visibility,
    required this.windSpeed,
    required this.windGust,
    required this.windDeg,
    required this.cloudiness,
    required this.sunrise,
    required this.sunset,
    required this.conditionCode,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      id: json['weather'] != null && json['weather'].isNotEmpty ? json['weather'][0]['id'] ?? 0 : 0,
      main: json['weather'] != null && json['weather'].isNotEmpty ? json['weather'][0]['main'] ?? '' : '',
      description: json['weather'] != null && json['weather'].isNotEmpty ? json['weather'][0]['description'] ?? '' : '',
      icon: json['weather'] != null && json['weather'].isNotEmpty ? json['weather'][0]['icon'] ?? '' : '',
      temperature: (json['main']['temp'] as num?)?.toDouble() ?? 0.0,
      feelsLike: (json['main']['feels_like'] as num?)?.toDouble() ?? 0.0,
      tempMin: (json['main']['temp_min'] as num?)?.toDouble() ?? 0.0,
      tempMax: (json['main']['temp_max'] as num?)?.toDouble() ?? 0.0,
      pressure: (json['main']['pressure'] as num?)?.toDouble() ?? 0.0,
      humidity: (json['main']['humidity'] as num?)?.toDouble() ?? 0.0,
      visibility: json['visibility'] ?? 0,
      windSpeed: (json['wind']['speed'] as num?)?.toDouble() ?? 0.0,
      windGust: (json['wind']['gust'] as num?)?.toDouble() ?? 0.0,
      windDeg: json['wind']['deg'] ?? 0,
      cloudiness: json['clouds']['all'] ?? 0,
      sunrise: json['sys']['sunrise'] ?? 0,
      sunset: json['sys']['sunset'] ?? 0,
      conditionCode: json['weather'] != null && json['weather'].isNotEmpty ? json['weather'][0]['id'] ?? 0 : 0,
    );
  }
}
