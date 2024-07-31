import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:testapp01/screens/weather/weather_models/weather.dart';
import 'package:testapp01/screens/weather/weather_models/weather_forecast.dart';
import 'package:testapp01/services/weather_service.dart';

class WeatherForecastingPage extends StatefulWidget {
  final String locality;

  WeatherForecastingPage({required this.locality});

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
        title: Text('Weather Forecast'),
       // backgroundColor: Colors.amberAccent,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : weather == null
              ? Center(child: Text('Weather data unavailable'))
              : SingleChildScrollView(

                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 25.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "${weather!.temperature.toStringAsFixed(1)}°C \n${widget.locality}",
                                  style: TextStyle(
                                      fontSize: 32.0,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              SizedBox(width: 20.0),
                              Image.network(
                                "http://openweathermap.org/img/wn/${weather!.icon}@2x.png",
                                width: 85,
                                height: 85,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Card(
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
                        SizedBox(height: 10.0),
                        Text("Daily Summary", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w400),),
                        SizedBox(height: 10.0),
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
                        SizedBox(height: 10.0),
                        Text("Weekly forecast", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w400),),
                        SizedBox(height: 10.0),
                        forecast != null && forecast!.isNotEmpty
                            ? Padding(
                                padding: EdgeInsets.all(5.0),
                                child: SizedBox(
                                  height: 280.0,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: forecast?.length ?? 0,
                                    itemBuilder: (context, index) {
                                      final forecastItem = forecast![index];
                                      return Container(
                                        width: 190,
                                        margin: EdgeInsets.all(8.0),
                                        padding: EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                          color: Color(0xffbce0fb),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          boxShadow: [
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
                                              style: TextStyle(
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
                                              style: TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(height: 8.0),
                                            Text(
                                              '${forecastItem.humidity}% Humidity',
                                              style: TextStyle(fontSize: 14.0),
                                            ),
                                            SizedBox(height: 8.0),
                                            Text(
                                              '${(forecastItem.windSpeed * 3.6).toStringAsFixed(2)} km/h Wind',
                                              style: TextStyle(fontSize: 14.0),
                                            ),
                                            SizedBox(height: 8.0),
                                            Text(
                                              forecastItem.description,
                                              style: TextStyle(fontSize: 14.0),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              )
                            : Center(
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
        padding: EdgeInsets.all(16.0),
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
                SizedBox(height: 8.0),
                Text(
                  item.value,
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                Text(
                  item.label,
                  style: TextStyle(fontSize: 16.0),
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
