import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/api_service.dart';
import 'services/storage_service.dart';
import 'utils/theme.dart';
import 'viewmodels/search_viewmodel.dart';
import 'viewmodels/weather_viewmodel.dart';
import 'views/home/weather_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final apiService = ApiService();
  final storageService = StorageService();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => WeatherViewModel(
            apiService: apiService,
            storageService: storageService,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => SearchViewModel(
            apiService: apiService,
            storageService: storageService,
          ),
        ),
      ],
      child: const ResponsiWeatherApp(),
    ),
  );
}

class ResponsiWeatherApp extends StatelessWidget {
  const ResponsiWeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Responsi Weather App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const WeatherScreen(),
    );
  }
}
