import 'package:responsi_flutter/models/location_model.dart';

class ApiConstants {
  ApiConstants._();

  static const String weatherHost = 'api.open-meteo.com';
  static const String weatherPath = '/v1/forecast';

  static const String geocodingHost = 'geocoding-api.open-meteo.com';
  static const String geocodingPath = '/v1/search';

  static const String currentFields =
      'temperature_2m,relative_humidity_2m,apparent_temperature,precipitation,weather_code,wind_speed_10m,is_day';

  static const String dailyFields =
      'weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max';

  static const Duration requestTimeout = Duration(seconds: 15);

  static const LocationModel defaultLocation = LocationModel(
    id: 1621177,
    name: 'Yogyakarta',
    latitude: -7.7956,
    longitude: 110.3695,
    country: 'Indonesia',
    admin1: 'Special Region of Yogyakarta',
  );
}
