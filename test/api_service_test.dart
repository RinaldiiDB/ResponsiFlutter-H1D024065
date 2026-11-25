import 'package:flutter_test/flutter_test.dart';
import 'package:responsi_weather/services/api_service.dart';

void main() {
  test('ApiService live integration test', () async {
    final apiService = ApiService();

    // Test Geocoding API
    final searchResults = await apiService.searchLocations('Jakarta');
    expect(searchResults, isNotEmpty);
    final firstResult = searchResults.first;
    expect(firstResult.name.toLowerCase(), contains('jakarta'));

    // Test Forecast API
    final weather = await apiService.fetchWeather(
      latitude: firstResult.latitude,
      longitude: firstResult.longitude,
    );

    expect(weather.current.temperature, isNotNull);
    expect(weather.current.relativeHumidity, isNotNull);
    expect(weather.current.apparentTemperature, isNotNull);
    expect(weather.current.precipitation, isNotNull);
    expect(weather.current.weatherCode, isNotNull);
    expect(weather.current.windSpeed, isNotNull);
    expect(weather.dailyForecast, isNotEmpty);
  });
}
