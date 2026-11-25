import 'package:flutter/material.dart';

class WeatherCondition {
  final String description;
  final IconData icon;
  final List<Color> gradientColors;

  const WeatherCondition({
    required this.description,
    required this.icon,
    required this.gradientColors,
  });
}

class WeatherCodeHelper {
  static WeatherCondition getCondition(int code, {bool isDay = true}) {
    switch (code) {
      case 0:
        return WeatherCondition(
          description: 'Cerah',
          icon: isDay ? Icons.wb_sunny : Icons.nightlight_round,
          gradientColors: isDay
              ? [const Color(0xFF2193b0), const Color(0xFF6dd5ed)]
              : [const Color(0xFF0F2027), const Color(0xFF203A43)],
        );
      case 1:
        return WeatherCondition(
          description: 'Sebagian Besar Cerah',
          icon: isDay ? Icons.wb_sunny_outlined : Icons.nightlight_outlined,
          gradientColors: [const Color(0xFF3a7bd5), const Color(0xFF3a6073)],
        );
      case 2:
        return const WeatherCondition(
          description: 'Sebagian Berawan',
          icon: Icons.cloud_queue,
          gradientColors: [Color(0xFF4b6cb7), Color(0xFF182848)],
        );
      case 3:
        return const WeatherCondition(
          description: 'Mendung',
          icon: Icons.cloud,
          gradientColors: [Color(0xFF536976), Color(0xFF292E49)],
        );
      case 45:
      case 48:
        return const WeatherCondition(
          description: 'Berkabut',
          icon: Icons.foggy,
          gradientColors: [Color(0xFF606c88), Color(0xFF3f4c6b)],
        );
      case 51:
      case 53:
      case 55:
        return const WeatherCondition(
          description: 'Gerimis Ringan',
          icon: Icons.grain,
          gradientColors: [Color(0xFF314755), Color(0xFF26a0da)],
        );
      case 56:
      case 57:
        return const WeatherCondition(
          description: 'Gerimis Dingin',
          icon: Icons.ac_unit,
          gradientColors: [Color(0xFF2c3e50), Color(0xFF3498db)],
        );
      case 61:
        return const WeatherCondition(
          description: 'Hujan Ringan',
          icon: Icons.water_drop,
          gradientColors: [Color(0xFF2b5876), Color(0xFF4e4376)],
        );
      case 63:
        return const WeatherCondition(
          description: 'Hujan Sedang',
          icon: Icons.shower,
          gradientColors: [Color(0xFF1e3c72), Color(0xFF2a5298)],
        );
      case 65:
        return const WeatherCondition(
          description: 'Hujan Lebat',
          icon: Icons.thunderstorm,
          gradientColors: [Color(0xFF141E30), Color(0xFF243B55)],
        );
      case 66:
      case 67:
        return const WeatherCondition(
          description: 'Hujan Es',
          icon: Icons.severe_cold,
          gradientColors: [Color(0xFF1CB5E0), Color(0xFF000046)],
        );
      case 71:
      case 73:
      case 75:
      case 77:
        return const WeatherCondition(
          description: 'Bersalju',
          icon: Icons.ac_unit,
          gradientColors: [Color(0xFF83a4d4), Color(0xFFb6fbff)],
        );
      case 80:
      case 81:
      case 82:
        return const WeatherCondition(
          description: 'Hujan Petir Sesaat',
          icon: Icons.flash_on,
          gradientColors: [Color(0xFF0f2027), Color(0xFF2c5364)],
        );
      case 85:
      case 86:
        return const WeatherCondition(
          description: 'Hujan Salju Lebat',
          icon: Icons.cloudy_snowing,
          gradientColors: [Color(0xFF4b6cb7), Color(0xFF182848)],
        );
      case 95:
        return const WeatherCondition(
          description: 'Badai Petir',
          icon: Icons.bolt,
          gradientColors: [Color(0xFF1f1c2c), Color(0xFF928DAB)],
        );
      case 96:
      case 99:
        return const WeatherCondition(
          description: 'Badai Petir & Es',
          icon: Icons.thunderstorm,
          gradientColors: [Color(0xFF0F2027), Color(0xFF203A43)],
        );
      default:
        return const WeatherCondition(
          description: 'Cerah Berawan',
          icon: Icons.cloud_queue,
          gradientColors: [Color(0xFF2193b0), Color(0xFF6dd5ed)],
        );
    }
  }
}
