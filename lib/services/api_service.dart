import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/location_model.dart';
import '../models/weather_model.dart';

class ApiService {
  static const String _forecastBaseUrl = 'https://api.open-meteo.com/v1/forecast';
  static const String _geocodingBaseUrl = 'https://geocoding-api.open-meteo.com/v1/search';

  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  Future<WeatherModel> fetchWeather({
    required double latitude,
    required double longitude,
  }) async {
    final uri = Uri.parse(_forecastBaseUrl).replace(
      queryParameters: {
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'current':
            'temperature_2m,relative_humidity_2m,apparent_temperature,precipitation,weather_code,wind_speed_10m',
        'daily':
            'weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max',
        'timezone': 'auto',
      },
    );

    try {
      final response = await _client.get(uri).timeout(
        const Duration(seconds: 12),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return WeatherModel.fromJson(data);
      } else {
        throw HttpException(
          'Gagal memuat data cuaca. Kode status: ${response.statusCode}',
          uri: uri,
        );
      }
    } on SocketException {
      throw const SocketException(
        'Tidak dapat terhubung ke internet. Silakan periksa koneksi Anda.',
      );
    } catch (e) {
      if (e is SocketException || e is HttpException) rethrow;
      throw Exception('Terjadi kesalahan saat mengambil cuaca: $e');
    }
  }

  Future<List<LocationModel>> searchLocations(String query) async {
    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) return [];

    final uri = Uri.parse(_geocodingBaseUrl).replace(
      queryParameters: {
        'name': trimmedQuery,
        'count': '10',
        'language': 'id',
        'format': 'json',
      },
    );

    try {
      final response = await _client.get(uri).timeout(
        const Duration(seconds: 12),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data.containsKey('results') && data['results'] != null) {
          final List results = data['results'] as List;
          return results
              .map((item) => LocationModel.fromJson(item as Map<String, dynamic>))
              .toList();
        }
        return [];
      } else {
        throw HttpException(
          'Gagal mencari lokasi. Kode status: ${response.statusCode}',
          uri: uri,
        );
      }
    } on SocketException {
      throw const SocketException(
        'Tidak dapat terhubung ke internet. Periksa koneksi Anda.',
      );
    } catch (e) {
      if (e is SocketException || e is HttpException) rethrow;
      throw Exception('Terjadi kesalahan saat mencari lokasi: $e');
    }
  }
}
