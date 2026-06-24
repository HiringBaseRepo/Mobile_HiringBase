import 'package:flutter/material.dart';

class DashboardStat {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const DashboardStat({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  DashboardStat copyWith({
    String? title,
    String? value,
    IconData? icon,
    Color? color,
  }) {
    return DashboardStat(
      title: title ?? this.title,
      value: value ?? this.value,
      icon: icon ?? this.icon,
      color: color ?? this.color,
    );
  }
}
