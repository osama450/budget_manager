import 'package:flutter/material.dart';

/// Brand + status palette. Single source of truth for colors.
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF17876D);
  static const Color primaryDark = Color(0xFF0F6453);
  static const Color background = Color(0xFFF1F7F6);
  static const Color surface = Colors.white;

  /// Vibrant red — over-budget alert.
  static const Color danger = Color(0xFFE53935);

  // 4-tier category status colors.
  static const Color statusLow = Color(0xFF2E9E6B); // green
  static const Color statusWithin = Color(0xFFE0A50B); // yellow/amber
  static const Color statusNear = Color(0xFFEF7C1B); // orange
  static const Color statusOver = danger; // red
  static const Color statusNeutral = Color(0xFF94A39E); // no budget
}
