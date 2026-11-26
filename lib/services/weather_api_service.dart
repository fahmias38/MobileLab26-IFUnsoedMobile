import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:responsi_flutter/core/constants/api_constants.dart';
import 'package:responsi_flutter/models/location_model.dart';
import 'package:responsi_flutter/models/weather_response_model.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class WeatherApiService {
  final http.Client _client;

  WeatherApiService({http.Client? client}) : _client = client ?? http.Client();

  /// Mengambil data cuaca terkini & prakiraan harian via HTTP GET Open-Meteo.
  Future<WeatherResponseModel> fetchWeather({
    required double latitude,
    required double longitude,
  }) async {
    final uri = Uri.https(
      ApiConstants.weatherHost,
      ApiConstants.weatherPath,
      {
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'current': ApiConstants.currentFields,
        'daily': ApiConstants.dailyFields,
        'timezone': 'auto',
        'forecast_days': '7',
      },
    );

    final jsonMap = await _getJson(uri);
    if (!jsonMap.containsKey('current') || !jsonMap.containsKey('daily')) {
      throw const ApiException('Data cuaca dari server tidak lengkap.');
    }
    return WeatherResponseModel.fromJson(jsonMap);
  }

  /// Mencari daftar kota berdasarkan nama via Open-Meteo Geocoding API.
  Future<List<LocationModel>> searchLocations(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return const [];

    final uri = Uri.https(
      ApiConstants.geocodingHost,
      ApiConstants.geocodingPath,
      {
        'name': trimmed,
        'count': '10',
        'language': 'en',
        'format': 'json',
      },
    );

    final jsonMap = await _getJson(uri);
    final results = jsonMap['results'] as List<dynamic>?;
    if (results == null || results.isEmpty) {
      return const [];
    }

    return results
        .whereType<Map<String, dynamic>>()
        .map(LocationModel.fromGeocodingJson)
        .toList();
  }

  Future<Map<String, dynamic>> _getJson(Uri uri) async {
    try {
      final response = await _client
          .get(uri, headers: const {'Accept': 'application/json'})
          .timeout(ApiConstants.requestTimeout);

      if (response.statusCode != 200) {
        throw ApiException(
          'Permintaan API gagal (kode ${response.statusCode}).',
          statusCode: response.statusCode,
        );
      }

      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        throw const ApiException('Format respons JSON tidak sesuai.');
      }

      if (decoded['error'] == true) {
        throw ApiException(
          decoded['reason']?.toString() ?? 'Terjadi kesalahan pada API.',
        );
      }

      return decoded;
    } on TimeoutException {
      throw const ApiException(
        'Koneksi timeout. Periksa jaringan internet Anda.',
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Tidak dapat terhubung ke server: $e');
    }
  }
}