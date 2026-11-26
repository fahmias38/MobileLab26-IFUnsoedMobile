import 'package:responsi_flutter/models/current_weather_model.dart';
import 'package:responsi_flutter/models/daily_forecast_model.dart';

class WeatherResponseModel {
  final double latitude;
  final double longitude;
  final String timezone;
  final CurrentWeatherModel current;
  final List<DailyForecastModel> daily;

  const WeatherResponseModel({
    required this.latitude,
    required this.longitude,
    required this.timezone,
    required this.current,
    required this.daily,
  });

  factory WeatherResponseModel.fromJson(Map<String, dynamic> json) {
    final currentMap = (json['current'] as Map<String, dynamic>?) ?? {};
    final dailyMap = (json['daily'] as Map<String, dynamic>?) ?? {};

    return WeatherResponseModel(
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      timezone: (json['timezone'] as String?) ?? 'auto',
      current: CurrentWeatherModel.fromJson(currentMap),
      daily: DailyForecastModel.fromDailyJson(dailyMap),
    );
  }
}