import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:testapp01/screens/weather/weather_models/weather.dart';
import 'package:testapp01/screens/weather/weather_models/weather_forecast.dart';
import 'package:testapp01/services/weather_service.dart';

class WeatherForecastingPage extends StatefulWidget {
  final String locality;

  const WeatherForecastingPage({super.key, required this.locality});

  @override
  _WeatherForecastingPageState createState() => _WeatherForecastingPageState();
}

class _WeatherForecastingPageState extends State<WeatherForecastingPage> {
  final WeatherService weatherService = WeatherService();
  Weather? weather;
  bool _isLoading = true;
  List<Forecast>? forecast;

  @override
  void initState() {
    super.initState();
    fetchWeatherData();
    fetchForecastData();
  }

  void fetchWeatherData() async {
    try {
      final fetchedWeather = await weatherService.fetchWeather(widget.locality);
      setState(() {
        weather = fetchedWeather;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error fetching weather: $e'),
      ));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void fetchForecastData() async {
    try {
      List<Forecast>? fetchedForecast =
          await weatherService.fetch3HourForecast(widget.locality);
      setState(() {
        forecast = fetchedForecast;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error fetching forecast: $e'),
      ));
    }
  }

  String formatTimestamp(int timestamp) {
    final DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    final DateFormat formatter = DateFormat('dd MMM\nHH:mm');
    return formatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // backgroundColor: Colors.amberAccent,
      appBar: AppBar(
        title: const Text('Weather Forecast'),
       // backgroundColor: Colors.amberAccent,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : weather == null
              ? const Center(child: Text('Weather data unavailable'))
              : SingleChildScrollView(

                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 25.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "${weather!.temperature.toStringAsFixed(1)}°C \n${widget.locality}",
                                  style: const TextStyle(
                                      fontSize: 32.0,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              const SizedBox(width: 20.0),
                              Image.network(
                                "http://openweathermap.org/img/wn/${weather!.icon}@2x.png",
                                width: 85,
                                height: 85,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        const Card(
                          color: Color(0xffddffdd),
                          elevation: 2.0,
                          shape: StadiumBorder(),
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                Icon(Icons.info_outline_rounded),
                                SizedBox(width: 20.0),
                                Expanded(
                                    child: Text(
                                        'Perfect for applying pesticide (sample)')),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        const Text("Daily Summary", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w400),),
                        const SizedBox(height: 10.0),
                        buildInfoCard([
                          InfoCardData(
                              icon: Icons.air,
                              value: "${(weather!.windSpeed * 3.6).toStringAsFixed(1)} Km/h",
                              label: "Wind"),
                          InfoCardData(
                              icon: Icons.water,
                              value: "${weather!.humidity}%",
                              label: "Humidity"),
                          InfoCardData(
                              icon: Icons.visibility,
                              value: "${weather!.visibility / 1000} Km",
                              label: "Visibility"),
                        ]),
                        const SizedBox(height: 10.0),
                        const Text("Weekly forecast", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w400),),
                        const SizedBox(height: 10.0),
                        forecast != null && forecast!.isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: SizedBox(
                                  height: 280.0,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: forecast?.length ?? 0,
                                    itemBuilder: (context, index) {
                                      final forecastItem = forecast![index];
                                      return Container(
                                        width: 190,
                                        margin: const EdgeInsets.all(8.0),
                                        padding: const EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                          color: const Color(0xffbce0fb),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 5.0,
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              formatTimestamp(
                                                  forecastItem.dateTime),
                                              style: const TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                            Image.network(
                                              "http://openweathermap.org/img/wn/${forecastItem.icon}@2x.png",
                                              width: 75,
                                              height: 75,
                                            ),
                                            // SizedBox(height: 8.0),
                                            Text(
                                              '${forecastItem.temperature.toStringAsFixed(1)}°C',
                                              style: const TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 8.0),
                                            Text(
                                              '${forecastItem.humidity}% Humidity',
                                              style: const TextStyle(fontSize: 14.0),
                                            ),
                                            const SizedBox(height: 8.0),
                                            Text(
                                              '${(forecastItem.windSpeed * 3.6).toStringAsFixed(2)} km/h Wind',
                                              style: const TextStyle(fontSize: 14.0),
                                            ),
                                            const SizedBox(height: 8.0),
                                            Text(
                                              forecastItem.description,
                                              style: const TextStyle(fontSize: 14.0),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              )
                            : const Center(
                                child: Text('No forecast data available'),
                              ),

                      ],
                    ),
                  ),
                ),
    );
  }

  Widget buildInfoCard(List<InfoCardData> data) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: data.map((item) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item.icon,
                  size: 30.0,
                  color: Colors.blue,
                ),
                const SizedBox(height: 8.0),
                Text(
                  item.value,
                  style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                Text(
                  item.label,
                  style: const TextStyle(fontSize: 16.0),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

class InfoCardData {
  final IconData icon;
  final String value;
  final String label;

  InfoCardData({required this.icon, required this.value, required this.label});
}
