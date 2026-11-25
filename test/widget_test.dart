import 'package:flutter_test/flutter_test.dart';
import 'package:responsi_weather/models/location_model.dart';
import 'package:responsi_weather/models/weather_model.dart';
import 'package:responsi_weather/utils/weather_code_helper.dart';

void main() {
  group('Model & Helper Unit Tests', () {
    test('LocationModel serialization test', () {
      const location = LocationModel(
        name: 'Jakarta',
        latitude: -6.2088,
        longitude: 106.8456,
        country: 'Indonesia',
        admin1: 'DKI Jakarta',
        isFavorite: true,
      );

      final json = location.toJson();
      final fromJson = LocationModel.fromJson(json);

      expect(fromJson.name, 'Jakarta');
      expect(fromJson.latitude, -6.2088);
      expect(fromJson.longitude, 106.8456);
      expect(fromJson.country, 'Indonesia');
      expect(fromJson.displayName, 'Jakarta, DKI Jakarta, Indonesia');
      expect(fromJson.isFavorite, true);
    });

    test('WeatherModel JSON parsing test', () {
      final sampleJson = {
        'latitude': -6.2,
        'longitude': 106.8,
        'timezone': 'Asia/Jakarta',
        'current': {
          'temperature_2m': 28.5,
          'relative_humidity_2m': 75,
          'apparent_temperature': 31.2,
          'precipitation': 1.5,
          'weather_code': 61,
          'wind_speed_10m': 12.4,
          'time': '2026-11-25T16:00',
        },
        'daily': {
          'time': ['2026-11-25', '2026-11-26'],
          'weather_code': [61, 0],
          'temperature_2m_max': [32.0, 33.5],
          'temperature_2m_min': [24.0, 25.0],
          'precipitation_probability_max': [80, 20],
        }
      };

      final weather = WeatherModel.fromJson(sampleJson);

      expect(weather.current.temperature, 28.5);
      expect(weather.current.relativeHumidity, 75);
      expect(weather.current.apparentTemperature, 31.2);
      expect(weather.current.precipitation, 1.5);
      expect(weather.current.weatherCode, 61);
      expect(weather.current.windSpeed, 12.4);

      expect(weather.dailyForecast.length, 2);
      expect(weather.dailyForecast.first.maxTemperature, 32.0);
      expect(weather.dailyForecast.first.minTemperature, 24.0);
      expect(weather.dailyForecast.first.precipitationProbabilityMax, 80);
      expect(weather.dailyForecast.first.weatherCode, 61);
    });

    test('WeatherCodeHelper interpretation test', () {
      final sunny = WeatherCodeHelper.getCondition(0);
      expect(sunny.description, 'Cerah');

      final rain = WeatherCodeHelper.getCondition(61);
      expect(rain.description, 'Hujan Ringan');

      final thunderstorm = WeatherCodeHelper.getCondition(95);
      expect(thunderstorm.description, 'Badai Petir');
    });
  });
}
