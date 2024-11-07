import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:testapp01/screens/weather/weather_models/weather.dart';
import 'package:testapp01/screens/weather/weather_models/weather_forecast.dart';



class WeatherService {
  final String apiKey = '9dac1789f6909ca2205c94277b32f8bd';
  final String apiUrl = 'https://api.openweathermap.org/data/2.5/';

  Future<Weather?> fetchWeather(String locality, {String? fallbackLocality}) async {
    try {
      final url = '$apiUrl/weather?q=$locality&appid=$apiKey&units=metric';
     final response = await http.get(Uri.parse(url));
     // final response = await http.get(Uri.parse('$apiUrl?q=$locality&APPID=$apiKey&units=metric'));
     // print('API Request URL: $apiUrl?q=$locality&APPID=$apiKey&units=metric');
     print(url);
      if (response.statusCode == 200) {

        print('API Response: ${response.body}');
        return Weather.fromJson(jsonDecode(response.body));
      } else {

        print('Failed to load weather data: $locality: ${response.statusCode} ${response.reasonPhrase}');
         if(fallbackLocality != null){
           print('Trying fallback locality: $fallbackLocality');
           return await fetchWeather(fallbackLocality);
         } else {
           return null;
         }
      }
    } catch (e) {
      print('Error fetching weather data: $e');
      return null;
    }
  }

  Future<List<Forecast>?> fetch3HourForecast(String locality) async {
    try{
      final forecastUrl = '$apiUrl/forecast?q=$locality&appid=$apiKey&units=metric';
      final response = await http.get(Uri.parse(forecastUrl));
      print(forecastUrl);

      if(response.statusCode == 200){
        print('API response: ${response.body}');
        final Map<String,dynamic> data = json.decode(response.body);
        final List<dynamic> forecastList = data['list'];

        return forecastList.map((item) => Forecast.fromJson(item )).toList();
            }else{
        print('Failed to load forecast data: ${response.statusCode} ${response.reasonPhrase}');
        return null;
      }
    }catch(e){
      print('Error fetching forecast data: $e');
      return null;
    }
  }
}
