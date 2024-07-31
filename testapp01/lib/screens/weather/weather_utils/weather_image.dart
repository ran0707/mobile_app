String getWeatherImage(int conditionCode) {
  if (conditionCode < 300) {
    return 'Images/thunderstorm.png';
  } else if (conditionCode < 400) {
    return 'Images/drizzle.png';
  } else if (conditionCode < 600) {
    return 'Images/rain.png';
  } else if (conditionCode < 700) {
    return 'Images/snow.png';
  } else if (conditionCode < 800) {
    return 'Images/fog.png';
  } else if (conditionCode == 800) {
    return 'Images/clear.png';
  } else if (conditionCode <= 804) {
    return 'Images/clouds.png';
  } else {
    return 'Images/unknown.png';
  }
}
