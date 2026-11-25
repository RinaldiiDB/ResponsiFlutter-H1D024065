import 'package:flutter/foundation.dart';
import '../models/location_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class SearchViewModel extends ChangeNotifier {
  final ApiService _apiService;
  final StorageService _storageService;

  List<LocationModel> _searchResults = [];
  List<String> _searchHistory = [];
  bool _isSearching = false;
  String? _errorMessage;
  String _lastQuery = '';

  SearchViewModel({
    ApiService? apiService,
    StorageService? storageService,
  })  : _apiService = apiService ?? ApiService(),
        _storageService = storageService ?? StorageService();

  List<LocationModel> get searchResults => _searchResults;
  List<String> get searchHistory => _searchHistory;
  bool get isSearching => _isSearching;
  String? get errorMessage => _errorMessage;
  String get lastQuery => _lastQuery;

  Future<void> initialize() async {
    await loadHistory();
  }

  Future<void> loadHistory() async {
    try {
      _searchHistory = await _storageService.getSearchHistory();
      notifyListeners();
    } catch (e) {
      debugPrint('Gagal memuat riwayat: $e');
    }
  }

  Future<void> searchLocations(String query) async {
    final trimmed = query.trim();
    _lastQuery = trimmed;

    if (trimmed.isEmpty) {
      _searchResults = [];
      _errorMessage = null;
      _isSearching = false;
      notifyListeners();
      return;
    }

    _isSearching = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await _apiService.searchLocations(trimmed);
      _searchResults = results;
      _errorMessage = null;

      if (results.isNotEmpty) {
        await _storageService.addSearchHistory(trimmed);
        await loadHistory();
      }
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _searchResults = [];
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }

  Future<void> removeFromHistory(String query) async {
    await _storageService.removeSearchHistory(query);
    await loadHistory();
  }

  Future<void> clearHistory() async {
    await _storageService.clearSearchHistory();
    _searchHistory = [];
    notifyListeners();
  }

  void clearResults() {
    _searchResults = [];
    _errorMessage = null;
    _lastQuery = '';
    notifyListeners();
  }
}
