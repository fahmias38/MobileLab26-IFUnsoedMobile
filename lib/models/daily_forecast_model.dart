class DailyForecastModel {
  final String date;
  final int weatherCode;
  final double temperatureMax;
  final double temperatureMin;
  final int precipitationProbabilityMax;

  const DailyForecastModel({
    required this.date,
    required this.weatherCode,
    required this.temperatureMax,
    required this.temperatureMin,
    required this.precipitationProbabilityMax,
  });

  static List<DailyForecastModel> fromDailyJson(Map<String, dynamic> json) {
    final times = (json['time'] as List<dynamic>?) ?? const [];
    final codes = (json['weather_code'] as List<dynamic>?) ?? const [];
    final maxTemps =
        (json['temperature_2m_max'] as List<dynamic>?) ?? const [];
    final minTemps =
        (json['temperature_2m_min'] as List<dynamic>?) ?? const [];
    final rainProbs =
        (json['precipitation_probability_max'] as List<dynamic>?) ?? const [];

    final count = times.length;
    final forecasts = <DailyForecastModel>[];

    for (var i = 0; i < count; i++) {
      forecasts.add(
        DailyForecastModel(
          date: times[i]?.toString() ?? '',
          weatherCode: i < codes.length && codes[i] != null
              ? (codes[i] as num).toInt()
              : 0,
          temperatureMax: i < maxTemps.length && maxTemps[i] != null
              ? (maxTemps[i] as num).toDouble()
              : 0.0,
          temperatureMin: i < minTemps.length && minTemps[i] != null
              ? (minTemps[i] as num).toDouble()
              : 0.0,
          precipitationProbabilityMax:
              i < rainProbs.length && rainProbs[i] != null
                  ? (rainProbs[i] as num).toInt()
                  : 0,
        ),
      );
    }

    return forecasts;
  }
}