import 'package:flutter/material.dart';
import 'package:responsi_flutter/core/utils/date_formatter.dart';
import 'package:responsi_flutter/core/utils/weather_code_mapper.dart';
import 'package:responsi_flutter/models/daily_forecast_model.dart';

class DailyForecastList extends StatelessWidget {
  final List<DailyForecastModel> forecasts;

  const DailyForecastList({
    super.key,
    required this.forecasts,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.6),
        ),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: forecasts.length,
        separatorBuilder: (_, _) => Divider(
          height: 1,
          indent: 16,
          endIndent: 16,
          color: colorScheme.outlineVariant.withValues(alpha: 0.45),
        ),
        itemBuilder: (context, index) {
          final day = forecasts[index];
          final info = WeatherCodeMapper.fromCode(day.weatherCode);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    DateFormatter.formatForecastDate(day.date, index: index),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: index == 0 ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ),
                Icon(info.icon, color: info.color, size: 22),
                const SizedBox(width: 8),
                SizedBox(
                  width: 48,
                  child: Text(
                    '${day.precipitationProbabilityMax}%',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    '${day.temperatureMin.round()}° / ${day.temperatureMax.round()}°',
                    textAlign: TextAlign.end,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}