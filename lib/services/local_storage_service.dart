import 'dart:convert';

import 'package:responsi_flutter/models/location_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String _favoritesKey = 'favorite_locations_v1';
  static const String _historyKey = 'search_history_v1';
  static const String _lastLocationKey = 'last_selected_location_v1';

  final SharedPreferences _prefs;

  LocalStorageService(this._prefs);

  List<LocationModel> getFavorites() => _readLocationList(_favoritesKey);

  Future<void> saveFavorites(List<LocationModel> favorites) =>
      _writeLocationList(_favoritesKey, favorites);

  List<LocationModel> getSearchHistory() => _readLocationList(_historyKey);

  Future<void> saveSearchHistory(List<LocationModel> history) =>
      _writeLocationList(_historyKey, history);

  LocationModel? getLastLocation() {
    final raw = _prefs.getString(_lastLocationKey);
    if (raw == null || raw.isEmpty) return null;

    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        return LocationModel.fromJson(decoded);
      }
    } catch (_) {
      return null;
    }
    return null;
  }

  Future<void> saveLastLocation(LocationModel location) async {
    await _prefs.setString(_lastLocationKey, jsonEncode(location.toJson()));
  }

  List<LocationModel> _readLocationList(String key) {
    final raw = _prefs.getString(key);
    if (raw == null || raw.isEmpty) return <LocationModel>[];

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return <LocationModel>[];

      return decoded
          .whereType<Map<String, dynamic>>()
          .map(LocationModel.fromJson)
          .toList();
    } catch (_) {
      return <LocationModel>[];
    }
  }

  Future<void> _writeLocationList(
    String key,
    List<LocationModel> locations,
  ) async {
    final encoded = jsonEncode(locations.map((e) => e.toJson()).toList());
    await _prefs.setString(key, encoded);
  }
}