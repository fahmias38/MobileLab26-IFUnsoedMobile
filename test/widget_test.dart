import 'package:flutter_test/flutter_test.dart';
import 'package:responsi_flutter/models/location_model.dart';
import 'package:responsi_flutter/models/weather_response_model.dart';

void main() {
  group('Open-Meteo JSON Parsing', () {
    test('WeatherResponseModel.fromJson parses current and daily data', () {
      final sampleJson = <String, dynamic>{
        'latitude': -7.75,
        'longitude': 110.375,
        'timezone': 'Asia/Jakarta',
        'current': {
          'time': '2026-11-25T15:00',
          'temperature_2m': 30.5,
          'relative_humidity_2m': 70,
          'apparent_temperature': 34.2,
          'precipitation': 0.2,
          'weather_code': 2,
          'wind_speed_10m': 11.4,
          'is_day': 1,
        },
        'daily': {
          'time': ['2026-11-25', '2026-11-26'],
          'weather_code': [2, 61],
          'temperature_2m_max': [32.0, 29.5],
          'temperature_2m_min': [24.0, 23.2],
          'precipitation_probability_max': [40, 80],
        },
      };

      final response = WeatherResponseModel.fromJson(sampleJson);

      expect(response.current.temperature2m, 30.5);
      expect(response.current.relativeHumidity2m, 70);
      expect(response.current.apparentTemperature, 34.2);
      expect(response.current.precipitation, 0.2);
      expect(response.current.weatherCode, 2);
      expect(response.current.windSpeed10m, 11.4);
      expect(response.daily.length, 2);
      expect(response.daily.first.temperatureMax, 32.0);
      expect(response.daily.last.precipitationProbabilityMax, 80);
    });

    test('LocationModel.fromGeocodingJson parses city metadata', () {
      final sampleLocation = <String, dynamic>{
        'id': 1642911,
        'name': 'Jakarta',
        'latitude': -6.21462,
        'longitude': 106.84513,
        'country': 'Indonesia',
        'admin1': 'Jakarta',
      };

      final location = LocationModel.fromGeocodingJson(sampleLocation);

      expect(location.name, 'Jakarta');
      expect(location.subtitle, 'Jakarta, Indonesia');
    });
  });
}