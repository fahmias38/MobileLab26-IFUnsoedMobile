import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsi_flutter/models/location_model.dart';
import 'package:responsi_flutter/viewmodels/weather_viewmodel.dart';
import 'package:responsi_flutter/views/screens/search_screen.dart';
import 'package:responsi_flutter/views/widgets/current_weather_card.dart';
import 'package:responsi_flutter/views/widgets/daily_forecast_list.dart';
import 'package:responsi_flutter/views/widgets/state_feedback_view.dart';
import 'package:responsi_flutter/views/widgets/weather_metrics_grid.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _openSearch(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const SearchScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<WeatherViewModel>(
      builder: (context, viewModel, _) {
        final location = viewModel.selectedLocation;
        final isFav = location != null && viewModel.isFavorite(location);

        return Scaffold(
          appBar: AppBar(
            title: location == null
                ? const Text('Cuaca')
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        location.name,
                        style: theme.textTheme.titleLarge,
                      ),
                      Text(
                        location.subtitle,
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
            actions: [
              if (location != null)
                IconButton(
                  tooltip:
                      isFav ? 'Hapus dari favorit' : 'Simpan ke favorit',
                  onPressed: () => viewModel.toggleFavorite(location),
                  icon: Icon(
                    isFav ? Icons.star_rounded : Icons.star_outline_rounded,
                    color: isFav ? Colors.amber : null,
                  ),
                ),
              IconButton(
                tooltip: 'Cari Lokasi',
                onPressed: () => _openSearch(context),
                icon: const Icon(Icons.search_rounded),
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: viewModel.refreshWeather,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 840),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (viewModel.favorites.isNotEmpty) ...[
                        _FavoritesChipBar(
                          favorites: viewModel.favorites,
                          selected: location,
                          onSelect: viewModel.selectLocation,
                        ),
                        const SizedBox(height: 16),
                      ],
                      _buildWeatherBody(context, viewModel),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildWeatherBody(
    BuildContext context,
    WeatherViewModel viewModel,
  ) {
    final theme = Theme.of(context);

    switch (viewModel.state) {
      case ViewState.initial:
      case ViewState.loading:
        return StateFeedbackView.loading(
          message: 'Mengambil data cuaca terkini...',
        );
      case ViewState.error:
        return StateFeedbackView.error(
          message: viewModel.errorMessage ?? 'Gagal memuat data cuaca.',
          onRetry: viewModel.refreshWeather,
        );
      case ViewState.empty:
        return StateFeedbackView.empty(
          title: 'Data cuaca tidak tersedia',
          subtitle: 'Coba pilih lokasi lain atau muat ulang.',
        );
      case ViewState.loaded:
        final weather = viewModel.weather!;
        final todayForecast =
            weather.daily.isNotEmpty ? weather.daily.first : null;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CurrentWeatherCard(
              current: weather.current,
              todayForecast: todayForecast,
            ),
            const SizedBox(height: 24),
            Text(
              'Detail Kondisi Saat Ini',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            WeatherMetricsGrid(
              current: weather.current,
              todayForecast: todayForecast,
            ),
            const SizedBox(height: 24),
            Text(
              'Prakiraan Beberapa Hari Ke Depan',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            DailyForecastList(forecasts: weather.daily),
          ],
        );
    }
  }
}

class _FavoritesChipBar extends StatelessWidget {
  final List<LocationModel> favorites;
  final LocationModel? selected;
  final ValueChanged<LocationModel> onSelect;

  const _FavoritesChipBar({
    required this.favorites,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: favorites.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final city = favorites[index];
          final isSelected = city == selected;

          return ChoiceChip(
            label: Text(city.name),
            avatar: Icon(
              Icons.star_rounded,
              size: 16,
              color: isSelected ? null : Colors.amber,
            ),
            selected: isSelected,
            onSelected: (_) => onSelect(city),
          );
        },
      ),
    );
  }
}