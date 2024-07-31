const express = require('express');
const router = express.Router();
const fetch = require('node-fetch');
const Weather = require('../models/weather');

const params = {
  "latitude": 10.8824,
  "longitude": 76.9967,
  "hourly": ["temperature_2m", "rain", "wind_speed_80m", "soil_temperature_0cm", "soil_moisture_0_to_1cm", "is_day", "sunshine_duration"],
  "timezone": "auto"
};

router.get('/currentWeather', async (req, res) => {
  try {
    const response = await fetch(`https://api.open-meteo.com/v1/forecast?${new URLSearchParams(params)}`);
    const data = await response.json();

    // Process the data and save it to MongoDB
    const weatherData = {
      temperature2m: data.hourly.temperature_2m[0],
      rain: data.hourly.rain[0],
      windSpeed80m: data.hourly.wind_speed_80m[0],
      soilTemperature0cm: data.hourly.soil_temperature_0cm[0],
      soilMoisture0To1cm: data.hourly.soil_moisture_0_to_1cm[0],
      isDay: data.hourly.is_day[0],
      sunshineDuration: data.hourly.sunshine_duration[0],
      timestamp: new Date(data.hourly.time[0])
    };

    const weather = new Weather(weatherData);
    await weather.save();

    res.json(weatherData);
  } catch (error) {
    console.error('Error fetching weather data:', error);
    res.status(500).json({ error: 'Failed to fetch weather data' });
  }
});

module.exports = router;
