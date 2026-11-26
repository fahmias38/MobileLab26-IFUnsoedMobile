import 'package:flutter/material.dart';
import 'package:responsi_flutter/core/utils/weather_code_mapper.dart';
import 'package:responsi_flutter/models/current_weather_model.dart';
import 'package:responsi_flutter/models/daily_forecast_model.dart';

class CurrentWeatherCard extends StatelessWidget {
  final CurrentWeatherModel current;
  final DailyForecastModel? todayForecast;

  const CurrentWeatherCard({
    super.key,
    required this.current,
    this.todayForecast,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final info = WeatherCodeMapper.fromCode(
      current.weatherCode,
      isDay: current.isDay,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            info.color.withValues(alpha: 0.90),
            info.color.withValues(alpha: 0.65),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: info.color.withValues(alpha: 0.25),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(info.icon, color: Colors.white, size: 32),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  info.label,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${current.temperature2m.round()}°',
                style: theme.textTheme.displayLarge?.copyWith(
                  color: Colors.white,
                  height: 1.0,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 8, left: 2),
                child: Text(
                  'C',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 16,
            runSpacing: 6,
            children: [
              Text(
                'Terasa seperti ${current.apparentTemperature.round()}°C',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withValues(alpha: 0.92),
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (todayForecast != null)
                Text(
                  'Min ${todayForecast!.temperatureMin.round()}°C  •  Maks ${todayForecast!.temperatureMax.round()}°C',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}