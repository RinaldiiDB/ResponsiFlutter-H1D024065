import 'package:flutter/foundation.dart';
import '../models/location_model.dart';
import '../models/weather_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class WeatherViewModel extends ChangeNotifier {
  final ApiService _apiService;
  final StorageService _storageService;

  LocationModel? _currentLocation;
  WeatherModel? _weather;
  bool _isLoading = false;
  String? _errorMessage;
  List<LocationModel> _favorites = [];

  WeatherViewModel({
    ApiService? apiService,
    StorageService? storageService,
  })  : _apiService = apiService ?? ApiService(),
        _storageService = storageService ?? StorageService();

  LocationModel? get currentLocation => _currentLocation;
  WeatherModel? get weather => _weather;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<LocationModel> get favorites => _favorites;

  bool get isCurrentFavorite {
    if (_currentLocation == null) return false;
    return _favorites.any((loc) =>
        loc.name == _currentLocation!.name &&
        (loc.latitude - _currentLocation!.latitude).abs() < 0.01 &&
        (loc.longitude - _currentLocation!.longitude).abs() < 0.01);
  }

  static const LocationModel defaultLocation = LocationModel(
    name: 'Jakarta',
    latitude: -6.2088,
    longitude: 106.8456,
    country: 'Indonesia',
    admin1: 'DKI Jakarta',
  );

  Future<void> initialize() async {
    await loadFavorites();
    final lastLoc = await _storageService.getLastLocation();
    final targetLoc = lastLoc ?? defaultLocation;
    await selectLocation(targetLoc);
  }

  Future<void> loadFavorites() async {
    try {
      _favorites = await _storageService.getFavorites();
      notifyListeners();
    } catch (e) {
      debugPrint('Gagal memuat favorit: $e');
    }
  }

  Future<void> selectLocation(LocationModel location) async {
    _currentLocation = location;
    _errorMessage = null;
    _isLoading = true;
    notifyListeners();

    try {
      await _storageService.saveLastLocation(location);

      _weather = await _apiService.fetchWeather(
        latitude: location.latitude,
        longitude: location.longitude,
      );
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _weather = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshWeather() async {
    if (_currentLocation == null) return;
    try {
      _weather = await _apiService.fetchWeather(
        latitude: _currentLocation!.latitude,
        longitude: _currentLocation!.longitude,
      );
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(LocationModel location) async {
    try {
      await _storageService.toggleFavorite(location);
      await loadFavorites();
      notifyListeners();
    } catch (e) {
      debugPrint('Gagal toggle favorit: $e');
    }
  }
}
