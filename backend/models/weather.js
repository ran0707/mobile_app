const mongoose = require('mongoose');

const WeatherSchema = new mongoose.Schema({
  temperature2m: Number,
  rain: Number,
  windSpeed80m: Number,
  soilTemperature0cm: Number,
  soilMoisture0To1cm: Number,
  isDay: Boolean,
  sunshineDuration: Number,
  timestamp: Date
});

module.exports = mongoose.model('Weather', WeatherSchema);
