import 'package:flutter/foundation.dart';
import 'package:responsi_flutter/core/constants/api_constants.dart';
import 'package:responsi_flutter/models/location_model.dart';
import 'package:responsi_flutter/models/weather_response_model.dart';
import 'package:responsi_flutter/services/local_storage_service.dart';
import 'package:responsi_flutter/services/weather_api_service.dart';

enum ViewState { initial, loading, loaded, empty, error }

class WeatherViewModel extends ChangeNotifier {
  final WeatherApiService _apiService;
  final LocalStorageService _storageService;

  WeatherViewModel({
    required WeatherApiService apiService,
    required LocalStorageService storageService,
  })  : _apiService = apiService,
        _storageService = storageService;

  ViewState _state = ViewState.initial;
  LocationModel? _selectedLocation;
  WeatherResponseModel? _weather;
  List<LocationModel> _favorites = <LocationModel>[];
  String? _errorMessage;

  ViewState get state => _state;
  LocationModel? get selectedLocation => _selectedLocation;
  WeatherResponseModel? get weather => _weather;
  List<LocationModel> get favorites => List.unmodifiable(_favorites);
  String? get errorMessage => _errorMessage;

  /// Memuat favorit & lokasi terakhir dari SharedPreferences lalu mengambil cuaca live.
  Future<void> init() async {
    _favorites = _storageService.getFavorites();

    final lastLocation = _storageService.getLastLocation();
    final initialLocation = lastLocation ??
        (_favorites.isNotEmpty
            ? _favorites.first
            : ApiConstants.defaultLocation);

    await selectLocation(initialLocation);
  }

  Future<void> selectLocation(LocationModel location) async {
    _selectedLocation = location;
    _state = ViewState.loading;
    _errorMessage = null;
    notifyListeners();

    await _storageService.saveLastLocation(location);
    await _fetchWeatherFor(location);
  }

  Future<void> refreshWeather() async {
    final location = _selectedLocation;
    if (location == null) return;

    _state = ViewState.loading;
    _errorMessage = null;
    notifyListeners();

    await _fetchWeatherFor(location);
  }

  Future<void> _fetchWeatherFor(LocationModel location) async {
    try {
      final result = await _apiService.fetchWeather(
        latitude: location.latitude,
        longitude: location.longitude,
      );

      if (result.daily.isEmpty) {
        _weather = result;
        _state = ViewState.empty;
      } else {
        _weather = result;
        _state = ViewState.loaded;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _state = ViewState.error;
    }
    notifyListeners();
  }

  bool isFavorite(LocationModel location) {
    return _favorites.contains(location);
  }

  Future<void> toggleFavorite(LocationModel location) async {
    final updated = List<LocationModel>.from(_favorites);
    if (updated.contains(location)) {
      updated.remove(location);
    } else {
      updated.insert(0, location);
    }

    _favorites = updated;
    await _storageService.saveFavorites(_favorites);
    notifyListeners();
  }

  Future<void> removeFavorite(LocationModel location) async {
    _favorites = _favorites.where((item) => item != location).toList();
    await _storageService.saveFavorites(_favorites);
    notifyListeners();
  }
}