import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsi_flutter/core/theme/app_theme.dart';
import 'package:responsi_flutter/services/local_storage_service.dart';
import 'package:responsi_flutter/services/weather_api_service.dart';
import 'package:responsi_flutter/viewmodels/search_viewmodel.dart';
import 'package:responsi_flutter/viewmodels/weather_viewmodel.dart';
import 'package:responsi_flutter/views/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final apiService = WeatherApiService();
  final storageService = LocalStorageService(prefs);

  runApp(
    ResponsiWeatherApp(
      apiService: apiService,
      storageService: storageService,
    ),
  );
}

class ResponsiWeatherApp extends StatelessWidget {
  final WeatherApiService apiService;
  final LocalStorageService storageService;

  const ResponsiWeatherApp({
    super.key,
    required this.apiService,
    required this.storageService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => WeatherViewModel(
            apiService: apiService,
            storageService: storageService,
          )..init(),
        ),
        ChangeNotifierProvider(
          create: (_) => SearchViewModel(
            apiService: apiService,
            storageService: storageService,
          )..init(),
        ),
      ],
      child: MaterialApp(
        title: 'Responsi Cuaca',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const HomeScreen(),
      ),
    );
  }
}