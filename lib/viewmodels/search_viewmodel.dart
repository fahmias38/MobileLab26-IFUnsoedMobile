import 'package:flutter/foundation.dart';
import 'package:responsi_flutter/models/location_model.dart';
import 'package:responsi_flutter/services/local_storage_service.dart';
import 'package:responsi_flutter/services/weather_api_service.dart';
import 'package:responsi_flutter/viewmodels/weather_viewmodel.dart';

class SearchViewModel extends ChangeNotifier {
  static const int _maxHistoryItems = 10;

  final WeatherApiService _apiService;
  final LocalStorageService _storageService;

  SearchViewModel({
    required WeatherApiService apiService,
    required LocalStorageService storageService,
  })  : _apiService = apiService,
        _storageService = storageService;

  ViewState _state = ViewState.initial;
  List<LocationModel> _results = <LocationModel>[];
  List<LocationModel> _history = <LocationModel>[];
  String _query = '';
  String? _errorMessage;

  ViewState get state => _state;
  List<LocationModel> get results => List.unmodifiable(_results);
  List<LocationModel> get history => List.unmodifiable(_history);
  String get query => _query;
  String? get errorMessage => _errorMessage;

  void init() {
    _history = _storageService.getSearchHistory();
    notifyListeners();
  }

  Future<void> search(String rawQuery) async {
    final trimmed = rawQuery.trim();
    _query = trimmed;

    if (trimmed.isEmpty) {
      _results = <LocationModel>[];
      _errorMessage = null;
      _state = ViewState.initial;
      notifyListeners();
      return;
    }

    _state = ViewState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final locations = await _apiService.searchLocations(trimmed);
      if (_query != trimmed) return;

      _results = locations;
      _state = locations.isEmpty ? ViewState.empty : ViewState.loaded;
    } catch (e) {
      if (_query != trimmed) return;
      _errorMessage = e.toString();
      _state = ViewState.error;
    }
    notifyListeners();
  }

  void clearSearch() {
    _query = '';
    _results = <LocationModel>[];
    _errorMessage = null;
    _state = ViewState.initial;
    notifyListeners();
  }

  Future<void> addToHistory(LocationModel location) async {
    final updated = _history.where((item) => item != location).toList();
    updated.insert(0, location);
    if (updated.length > _maxHistoryItems) {
      updated.removeRange(_maxHistoryItems, updated.length);
    }

    _history = updated;
    await _storageService.saveSearchHistory(_history);
    notifyListeners();
  }

  Future<void> removeFromHistory(LocationModel location) async {
    _history = _history.where((item) => item != location).toList();
    await _storageService.saveSearchHistory(_history);
    notifyListeners();
  }

  Future<void> clearHistory() async {
    _history = <LocationModel>[];
    await _storageService.saveSearchHistory(_history);
    notifyListeners();
  }
}