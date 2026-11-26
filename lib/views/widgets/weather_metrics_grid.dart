import 'package:flutter/material.dart';
import 'package:responsi_flutter/models/current_weather_model.dart';
import 'package:responsi_flutter/models/daily_forecast_model.dart';

class WeatherMetricsGrid extends StatelessWidget {
  final CurrentWeatherModel current;
  final DailyForecastModel? todayForecast;

  const WeatherMetricsGrid({
    super.key,
    required this.current,
    this.todayForecast,
  });

  @override
  Widget build(BuildContext context) {
    final rainChance = todayForecast?.precipitationProbabilityMax ?? 0;

    final metrics = [
      _MetricItem(
        icon: Icons.water_drop_outlined,
        label: 'Kelembapan',
        value: '${current.relativeHumidity2m}%',
      ),
      _MetricItem(
        icon: Icons.air_rounded,
        label: 'Kecepatan Angin',
        value: '${current.windSpeed10m.toStringAsFixed(1)} km/j',
      ),
      _MetricItem(
        icon: Icons.grain_rounded,
        label: 'Curah Hujan',
        value: '${current.precipitation.toStringAsFixed(1)} mm',
      ),
      _MetricItem(
        icon: Icons.umbrella_outlined,
        label: 'Peluang Hujan',
        value: '$rainChance%',
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 600 ? 4 : 2;
        const spacing = 12.0;
        final itemWidth =
            (constraints.maxWidth - spacing * (columns - 1)) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: metrics
              .map(
                (item) => SizedBox(
                  width: itemWidth,
                  child: _MetricCard(item: item),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _MetricItem {
  final IconData icon;
  final String label;
  final String value;

  const _MetricItem({
    required this.icon,
    required this.label,
    required this.value,
  });
}

class _MetricCard extends StatelessWidget {
  final _MetricItem item;

  const _MetricCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.6),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(item.icon, size: 18, color: colorScheme.primary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            item.value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}