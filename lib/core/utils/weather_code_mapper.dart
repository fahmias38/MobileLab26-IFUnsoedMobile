import 'package:flutter/material.dart';

class WeatherInfo {
  final String label;
  final IconData icon;
  final Color color;

  const WeatherInfo({
    required this.label,
    required this.icon,
    required this.color,
  });
}

class WeatherCodeMapper {
  WeatherCodeMapper._();

  static WeatherInfo fromCode(int code, {bool isDay = true}) {
    switch (code) {
      case 0:
        return WeatherInfo(
          label: isDay ? 'Cerah' : 'Malam Cerah',
          icon: isDay ? Icons.wb_sunny_rounded : Icons.nightlight_round,
          color: isDay ? const Color(0xFFF59E0B) : const Color(0xFF6366F1),
        );
      case 1:
        return WeatherInfo(
          label: 'Umumnya Cerah',
          icon: isDay ? Icons.wb_sunny_outlined : Icons.nights_stay_outlined,
          color: const Color(0xFFF59E0B),
        );
      case 2:
        return const WeatherInfo(
          label: 'Berawan Sebagian',
          icon: Icons.cloud_queue_rounded,
          color: Color(0xFF3B82F6),
        );
      case 3:
        return const WeatherInfo(
          label: 'Berawan / Mendung',
          icon: Icons.cloud_rounded,
          color: Color(0xFF64748B),
        );
      case 45:
      case 48:
        return const WeatherInfo(
          label: 'Berkabut',
          icon: Icons.foggy,
          color: Color(0xFF94A3B8),
        );
      case 51:
      case 53:
      case 55:
      case 56:
      case 57:
        return const WeatherInfo(
          label: 'Gerimis',
          icon: Icons.grain_rounded,
          color: Color(0xFF0EA5E9),
        );
      case 61:
      case 63:
      case 66:
        return const WeatherInfo(
          label: 'Hujan Ringan - Sedang',
          icon: Icons.water_drop_rounded,
          color: Color(0xFF0284C7),
        );
      case 65:
      case 67:
        return const WeatherInfo(
          label: 'Hujan Lebat',
          icon: Icons.umbrella_rounded,
          color: Color(0xFF1D4ED8),
        );
      case 71:
      case 73:
      case 75:
      case 77:
      case 85:
      case 86:
        return const WeatherInfo(
          label: 'Salju',
          icon: Icons.ac_unit_rounded,
          color: Color(0xFF38BDF8),
        );
      case 80:
      case 81:
      case 82:
        return const WeatherInfo(
          label: 'Hujan Deras Sesaat',
          icon: Icons.shower_rounded,
          color: Color(0xFF2563EB),
        );
      case 95:
      case 96:
      case 99:
        return const WeatherInfo(
          label: 'Badai Petir',
          icon: Icons.thunderstorm_rounded,
          color: Color(0xFF7C3AED),
        );
      default:
        return const WeatherInfo(
          label: 'Tidak Diketahui',
          icon: Icons.help_outline_rounded,
          color: Color(0xFF64748B),
        );
    }
  }
}