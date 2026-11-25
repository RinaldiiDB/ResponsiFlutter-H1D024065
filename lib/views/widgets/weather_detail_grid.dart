import 'package:flutter/material.dart';
import '../../models/weather_model.dart';

class WeatherDetailGrid extends StatelessWidget {
  final CurrentWeather current;

  const WeatherDetailGrid({
    super.key,
    required this.current,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Detail Cuaca',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.45,
          children: [
            _DetailCard(
              title: 'Kelembapan',
              value: '${current.relativeHumidity}%',
              icon: Icons.water_drop_outlined,
              iconColor: const Color(0xFF0288D1),
              subtitle: 'Kelembapan relatif',
            ),
            _DetailCard(
              title: 'Kecepatan Angin',
              value: '${current.windSpeed.toStringAsFixed(1)} km/j',
              icon: Icons.air_rounded,
              iconColor: const Color(0xFF0D9488),
              subtitle: 'Angin pada 10m',
            ),
            _DetailCard(
              title: 'Curah Hujan',
              value: '${current.precipitation.toStringAsFixed(1)} mm',
              icon: Icons.grain_rounded,
              iconColor: const Color(0xFF6366F1),
              subtitle: 'Prepitasi saat ini',
            ),
            _DetailCard(
              title: 'Suhu Dirasakan',
              value: '${current.apparentTemperature.round()}°C',
              icon: Icons.thermostat_rounded,
              iconColor: const Color(0xFFF97316),
              subtitle: 'Apparent Temp',
            ),
          ],
        ),
      ],
    );
  }
}

class _DetailCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;
  final String subtitle;

  const _DetailCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
              letterSpacing: -0.5,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }
}
