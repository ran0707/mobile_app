import openmeteo_requests.Client
import openmeteo_requests
import requests_cache
from retry_requests import retry
import requests
import json
from geopy.geocoders import Nominatim


cache_session = requests_cache.CachedSession('.cache', expire_after=3600)
retry_session = retry(cache_session, retries=5, backoff_factor=0.2)
openmeteo = openmeteo_requests.Client(session=retry_session)




def fetch_weather(lat, long):
    url = "http://api.open-meteo.com/v1/forecast&current_weather=true"
    params = {
        "latitude": lat,
	    "longitude": long,
        "current" : True,
        "hourly":["temperature_2m" , "relative_humidity_2m", "rain", "soil_temperature_6cm", "soil_moisture_0_to_1cm"],
        "daily" : ["sunrise", "sunset" ,"rain_sum"],
        "timezone" : "auto"

    }

    responses = openmeteo.weather_api(url, params=params)

    responses = responses[0]
    current = responses.Current()
    current_temperature_2m = current.Variables(0).Value()
    current_cloud_cover = current.Variables(1).Value()


    hourly = responses.Hourly()
    hourly_temperature_2m = hourly.Variables(0).ValuesAsNumpy().tolist()
    hourly_relative_humidity_2m = hourly.Variables(1).ValuesAsNumpy().tolist()
    hourly_rain = hourly.Variables(2).ValuesAsNumpy().tolist()
    hourly_soil_temperature_6cm = hourly.Variables(3).ValuesAsNumpy().tolist()
    hourly_soil_moisture_0_to_1cm = hourly.Variables(4).ValuesAsNumpy().tolist()



    daily = response.Daily()
    daily_sunrise = daily.Variables(0).ValuesAsNumpy().tolist()
    daily_sunset = daily.Variables(1).ValuesAsNumpy().tolist()
    daily_rain_sum = daily.Variables(2).ValuesAsNumpy().tolist()




    weather_data = {
        "current": {
            "temperature_2m": current_temperature_2m,
            "cloud_cover": current_cloud_cover
        },
        "hourly": {
            "temperature_2m": hourly_temperature_2m,
            "relative_humidity_2m": hourly_relative_humidity_2m,
            "rain": hourly_rain,
            "soil_temperature_6cm": hourly_soil_temperature_6cm,
            "soil_moisture_0_to_1cm": hourly_soil_moisture_0_to_1cm
        },
        "daily": {
            "sunrise": daily_sunrise,
            "sunset": daily_sunset,
            "rain_sum": daily_rain_sum
        }
    }


    try:
        response = requests.post('http://10.0.2.2:3000/api/weather', json=weather_data)
        response.raise_for_status()
        print('Weather data sent successfully')
    except requests.exceptions.RequestException as e:
        print(f'Error sending weather data: {e}')


def get_location_coordinates(location_name):
    geolocator = Nominatim(user_agent = "geoapiExercises")
    location = geolocator.geocode(location_name)
    return location.latitude, location.longitude


if __name__ == '__main__':
    location_name = "India, Asia"
    lat, long = get_location_coordinates(location_name)
    fetch_weather(lat, long)


