import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testapp01/screens/weather/weatherForecasting.dart';
import 'package:testapp01/services/weather_service.dart';
import 'package:testapp01/screens/weather/weather_models/weather.dart';

class WeatherCard extends StatefulWidget {
  final String primaryLocality;
  final String fallbackLocality;

  const WeatherCard({required this.primaryLocality, required this.fallbackLocality, super.key});

  @override
  State<WeatherCard> createState() => _WeatherCardState();
}

class _WeatherCardState extends State<WeatherCard> {
  final WeatherService weatherService = WeatherService();
  Weather? weather;
  bool _isLoading = true;
  double _temperatureCelcius = 0.0;
  bool _isDay = true;
  String displayedLocality = '';

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  void _fetchWeather() async {
    try {
      final fetchedWeather = await weatherService.fetchWeather(widget.primaryLocality);
      if (fetchedWeather == null) {
        print('Retrying with fallback locality: ${widget.fallbackLocality}');
        final fallbackWeather = await weatherService.fetchWeather(widget.fallbackLocality);
        setState(() {
          weather = fallbackWeather;
          if (fallbackWeather != null) {
            _temperatureCelcius = fallbackWeather.temperature;
            _isDay = _temperatureCelcius > 20.0;
            displayedLocality = widget.fallbackLocality;
          } else {
            print('Failed to load fallback weather data');
          }
        });
      } else {
        setState(() {
          weather = fetchedWeather;
          _temperatureCelcius = fetchedWeather.temperature;
          _isDay = _temperatureCelcius > 20.0;
          displayedLocality = widget.primaryLocality;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error fetching weather')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WeatherForecastingPage(locality: displayedLocality),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10.0),
        width: double.infinity,
        child: Card(
          color: const Color(0xffd2e3fc),
          shape: const StadiumBorder(
            side: BorderSide(
              color: Color(0xff6087ed),
              width: 1.0,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : weather == null
                ? const Text('Weather data unavailable')
                : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          CupertinoIcons.location_solid,
                          size: 16.0,
                          color: Color(0xff4a4a4a),
                        ),
                        Text(
                          displayedLocality,
                          style: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0,),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        weather!.description,
                        style: const TextStyle(fontSize: 12.0),
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "${_temperatureCelcius.toStringAsFixed(1)}°C",
                            style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 10.0),
                          // Image.asset(
                          //   getWeatherImage(weather!.conditionCode), // Add your images in the assets folder
                          //   width: 30,
                          //   height: 30,
                          // ),
                          Image.network(
                            "http://openweathermap.org/img/wn/${weather!.icon}@2x.png",
                            width: 55,
                            height: 55,
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
