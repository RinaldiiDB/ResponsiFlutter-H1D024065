import 'package:flutter/material.dart';
import '../../models/weather_model.dart';
import '../../utils/weather_code_helper.dart';

class DailyForecastList extends StatelessWidget {
  final List<DailyForecastItem> dailyForecast;

  const DailyForecastList({
    super.key,
    required this.dailyForecast,
  });

  String _formatDay(DateTime date, int index) {
    if (index == 0) return 'Hari ini';
    if (index == 1) return 'Besok';
    final dayName = _getDayNameIndonesian(date.weekday);
    final monthName = _getMonthNameIndonesian(date.month);
    return '$dayName, ${date.day} $monthName';
  }

  String _getDayNameIndonesian(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Senin';
      case DateTime.tuesday:
        return 'Selasa';
      case DateTime.wednesday:
        return 'Rabu';
      case DateTime.thursday:
        return 'Kamis';
      case DateTime.friday:
        return 'Jumat';
      case DateTime.saturday:
        return 'Sabtu';
      case DateTime.sunday:
        return 'Minggu';
      default:
        return '';
    }
  }

  String _getMonthNameIndonesian(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des'
    ];
    if (month >= 1 && month <= 12) {
      return months[month - 1];
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Perkiraan Cuaca Harian',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(22),
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
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: dailyForecast.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              indent: 16,
              endIndent: 16,
              color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
            ),
            itemBuilder: (context, index) {
              final item = dailyForecast[index];
              final condition =
                  WeatherCodeHelper.getCondition(item.weatherCode);

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    SizedBox(
                      width: 115,
                      child: Text(
                        _formatDay(item.date, index),
                        style: TextStyle(
                          fontWeight:
                              index == 0 ? FontWeight.w700 : FontWeight.w500,
                          fontSize: 13,
                          color: index == 0
                              ? (isDark
                                  ? const Color(0xFF60A5FA)
                                  : const Color(0xFF2563EB))
                              : (isDark ? Colors.white : const Color(0xFF0F172A)),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: (isDark ? Colors.amber[300] : Colors.amber[600])!
                            .withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        condition.icon,
                        color: isDark ? Colors.amber[300] : Colors.amber[700],
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            condition.description,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? const Color(0xFFCBD5E1)
                                  : const Color(0xFF334155),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (item.precipitationProbabilityMax > 0)
                            Row(
                              children: [
                                const Icon(
                                  Icons.umbrella_outlined,
                                  size: 12,
                                  color: Color(0xFF0288D1),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${item.precipitationProbabilityMax}% hujan',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF0288D1),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${item.maxTemperature.round()}°',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${item.minTemperature.round()}°',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isDark
                                ? const Color(0xFF64748B)
                                : const Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
