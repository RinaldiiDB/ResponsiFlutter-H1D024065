import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/weather_viewmodel.dart';
import '../search/search_screen.dart';
import '../widgets/current_weather_card.dart';
import '../widgets/daily_forecast_list.dart';
import '../widgets/error_state_view.dart';
import '../widgets/loading_state_view.dart';
import '../widgets/weather_detail_grid.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<WeatherViewModel>();
      if (vm.weather == null && !vm.isLoading) {
        vm.initialize();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherViewModel>(
      builder: (context, vm, child) {
        final location = vm.currentLocation;
        final weather = vm.weather;

        return Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.location_on_rounded,
                  color: Color(0xFF2563EB),
                  size: 22,
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    location?.name ?? 'Cuaca',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            actions: [
              if (location != null)
                IconButton(
                  tooltip: vm.isCurrentFavorite
                      ? 'Hapus dari favorit'
                      : 'Simpan ke favorit',
                  icon: Icon(
                    vm.isCurrentFavorite
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: vm.isCurrentFavorite ? Colors.redAccent : null,
                  ),
                  onPressed: () async {
                    await vm.toggleFavorite(location);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            vm.isCurrentFavorite
                                ? '${location.name} ditambahkan ke favorit'
                                : '${location.name} dihapus dari favorit',
                            style: const TextStyle(fontSize: 13),
                          ),
                          duration: const Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    }
                  },
                ),
              IconButton(
                tooltip: 'Cari Kota / Lokasi',
                icon: const Icon(Icons.search_rounded),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SearchScreen(),
                    ),
                  );
                },
              ),
              IconButton(
                tooltip: 'Perbarui Cuaca',
                icon: const Icon(Icons.refresh_rounded),
                onPressed: vm.isLoading ? null : () => vm.refreshWeather(),
              ),
            ],
          ),
          body: Builder(
            builder: (context) {
              if (vm.isLoading && weather == null) {
                return const LoadingStateView(
                  message: 'Sedang mengambil data cuaca dari Open-Meteo...',
                );
              }

              if (vm.errorMessage != null && weather == null) {
                return ErrorStateView(
                  message: vm.errorMessage!,
                  onRetry: () => vm.refreshWeather(),
                );
              }

              if (weather == null || location == null) {
                return const Center(
                  child: Text(
                    'Pilih lokasi untuk melihat cuaca.',
                    style: TextStyle(fontSize: 14),
                  ),
                );
              }

              return RefreshIndicator(
                color: const Color(0xFF2563EB),
                onRefresh: () => vm.refreshWeather(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CurrentWeatherCard(
                        location: location,
                        current: weather.current,
                      ),
                      const SizedBox(height: 22),
                      WeatherDetailGrid(
                        current: weather.current,
                      ),
                      const SizedBox(height: 24),
                      DailyForecastList(
                        dailyForecast: weather.dailyForecast,
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
