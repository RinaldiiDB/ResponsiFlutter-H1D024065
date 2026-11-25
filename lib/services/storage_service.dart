import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/location_model.dart';

class StorageService {
  static const String _keyFavorites = 'favorite_locations';
  static const String _keyHistory = 'search_history';
  static const String _keyLastLocation = 'last_location';

  Future<List<LocationModel>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_keyFavorites);
    if (jsonList == null || jsonList.isEmpty) return [];

    try {
      return jsonList
          .map((item) => LocationModel.fromJson(jsonDecode(item) as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<bool> toggleFavorite(LocationModel location) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();

    final index = favorites.indexWhere((loc) =>
        loc.name == location.name &&
        (loc.latitude - location.latitude).abs() < 0.01 &&
        (loc.longitude - location.longitude).abs() < 0.01);

    bool nowFavorite = false;
    if (index >= 0) {
      favorites.removeAt(index);
      nowFavorite = false;
    } else {
      favorites.add(location.copyWith(isFavorite: true));
      nowFavorite = true;
    }

    final stringList =
        favorites.map((loc) => jsonEncode(loc.toJson())).toList();
    await prefs.setStringList(_keyFavorites, stringList);
    return nowFavorite;
  }

  Future<bool> isFavorite(LocationModel location) async {
    final favorites = await getFavorites();
    return favorites.any((loc) =>
        loc.name == location.name &&
        (loc.latitude - location.latitude).abs() < 0.01 &&
        (loc.longitude - location.longitude).abs() < 0.01);
  }

  Future<void> saveLastLocation(LocationModel location) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLastLocation, jsonEncode(location.toJson()));
  }

  Future<LocationModel?> getLastLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_keyLastLocation);
    if (jsonStr == null) return null;
    try {
      return LocationModel.fromJson(jsonDecode(jsonStr) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<List<String>> getSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keyHistory) ?? [];
  }

  Future<void> addSearchHistory(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList(_keyHistory) ?? [];
    history.removeWhere((item) => item.toLowerCase() == trimmed.toLowerCase());
    history.insert(0, trimmed);

    if (history.length > 15) {
      history = history.sublist(0, 15);
    }

    await prefs.setStringList(_keyHistory, history);
  }

  Future<void> removeSearchHistory(String query) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList(_keyHistory) ?? [];
    history.remove(query);
    await prefs.setStringList(_keyHistory, history);
  }

  Future<void> clearSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyHistory);
  }
}
