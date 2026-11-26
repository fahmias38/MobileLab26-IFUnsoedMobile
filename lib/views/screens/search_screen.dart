import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsi_flutter/models/location_model.dart';
import 'package:responsi_flutter/viewmodels/search_viewmodel.dart';
import 'package:responsi_flutter/viewmodels/weather_viewmodel.dart';
import 'package:responsi_flutter/views/widgets/state_feedback_view.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onQueryChanged(String value) {
    setState(() {});
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 450), () {
      if (!mounted) return;
      context.read<SearchViewModel>().search(value);
    });
  }

  Future<void> _selectLocation(LocationModel location) async {
    final searchVm = context.read<SearchViewModel>();
    final weatherVm = context.read<WeatherViewModel>();

    await searchVm.addToHistory(location);
    unawaited(weatherVm.selectLocation(location));

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchVm = context.watch<SearchViewModel>();
    final weatherVm = context.watch<WeatherViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cari Lokasi'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 840),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: TextField(
                  controller: _controller,
                  textInputAction: TextInputAction.search,
                  onChanged: _onQueryChanged,
                  onSubmitted: (value) {
                    _debounce?.cancel();
                    searchVm.search(value);
                  },
                  decoration: InputDecoration(
                    hintText: 'Ketik nama kota (mis. Jakarta, Tokyo)...',
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _controller.text.isNotEmpty
                        ? IconButton(
                            tooltip: 'Bersihkan',
                            onPressed: () {
                              _debounce?.cancel();
                              _controller.clear();
                              setState(() {});
                              searchVm.clearSearch();
                            },
                            icon: const Icon(Icons.close_rounded),
                          )
                        : null,
                  ),
                ),
              ),
              Expanded(
                child: _buildBody(context, searchVm, weatherVm),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    SearchViewModel searchVm,
    WeatherViewModel weatherVm,
  ) {
    if (_controller.text.trim().isEmpty) {
      return _SavedLocationsView(
        favorites: weatherVm.favorites,
        history: searchVm.history,
        onSelect: _selectLocation,
        onRemoveFavorite: weatherVm.removeFavorite,
        onRemoveHistory: searchVm.removeFromHistory,
        onClearHistory: searchVm.clearHistory,
      );
    }

    switch (searchVm.state) {
      case ViewState.initial:
        return StateFeedbackView.loading(message: 'Menyiapkan pencarian...');
      case ViewState.loading:
        return StateFeedbackView.loading(message: 'Mencari kota...');
      case ViewState.empty:
        return StateFeedbackView.empty(
          title: 'Kota tidak ditemukan',
          subtitle: 'Coba periksa ejaan atau gunakan nama kota lain.',
        );
      case ViewState.error:
        return StateFeedbackView.error(
          message: searchVm.errorMessage ?? 'Gagal melakukan pencarian.',
          onRetry: () => searchVm.search(_controller.text),
        );
      case ViewState.loaded:
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
          itemCount: searchVm.results.length,
          separatorBuilder: (_, _) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final city = searchVm.results[index];
            final isFav = weatherVm.isFavorite(city);

            return Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: Theme.of(context)
                      .colorScheme
                      .outlineVariant
                      .withValues(alpha: 0.6),
                ),
              ),
              child: ListTile(
                leading: const Icon(Icons.location_on_outlined),
                title: Text(city.name),
                subtitle: Text(
                  '${city.subtitle} • ${city.latitude.toStringAsFixed(2)}, ${city.longitude.toStringAsFixed(2)}',
                ),
                trailing: IconButton(
                  tooltip:
                      isFav ? 'Hapus dari favorit' : 'Simpan sebagai favorit',
                  onPressed: () => weatherVm.toggleFavorite(city),
                  icon: Icon(
                    isFav ? Icons.star_rounded : Icons.star_outline_rounded,
                    color: isFav ? Colors.amber : null,
                  ),
                ),
                onTap: () => _selectLocation(city),
              ),
            );
          },
        );
    }
  }
}

class _SavedLocationsView extends StatelessWidget {
  final List<LocationModel> favorites;
  final List<LocationModel> history;
  final ValueChanged<LocationModel> onSelect;
  final ValueChanged<LocationModel> onRemoveFavorite;
  final ValueChanged<LocationModel> onRemoveHistory;
  final VoidCallback onClearHistory;

  const _SavedLocationsView({
    required this.favorites,
    required this.history,
    required this.onSelect,
    required this.onRemoveFavorite,
    required this.onRemoveHistory,
    required this.onClearHistory,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (favorites.isEmpty && history.isEmpty) {
      return StateFeedbackView.empty(
        icon: Icons.travel_explore_rounded,
        title: 'Cari kota untuk melihat cuaca',
        subtitle:
            'Lokasi favorit dan riwayat pencarian Anda akan muncul di sini.',
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      children: [
        if (favorites.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Lokasi Favorit',
              style: theme.textTheme.titleMedium,
            ),
          ),
          ...favorites.map(
            (city) => Card(
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: const Icon(Icons.star_rounded, color: Colors.amber),
                title: Text(city.name),
                subtitle: Text(city.subtitle),
                trailing: IconButton(
                  tooltip: 'Hapus favorit',
                  onPressed: () => onRemoveFavorite(city),
                  icon: const Icon(Icons.delete_outline_rounded),
                ),
                onTap: () => onSelect(city),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
        if (history.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Riwayat Pencarian',
                style: theme.textTheme.titleMedium,
              ),
              TextButton(
                onPressed: onClearHistory,
                child: const Text('Hapus Semua'),
              ),
            ],
          ),
          ...history.map(
            (city) => Card(
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: const Icon(Icons.history_rounded),
                title: Text(city.name),
                subtitle: Text(city.subtitle),
                trailing: IconButton(
                  tooltip: 'Hapus riwayat',
                  onPressed: () => onRemoveHistory(city),
                  icon: const Icon(Icons.close_rounded),
                ),
                onTap: () => onSelect(city),
              ),
            ),
          ),
        ],
      ],
    );
  }
}