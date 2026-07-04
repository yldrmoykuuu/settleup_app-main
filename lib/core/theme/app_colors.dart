import 'package:flutter/material.dart';

class AppColors {
  //  DARK
  static const Color darkBackground = Color(0xFF0F172A);

  static const Color darkCard = Color(0xFF1E293B);
  static const Color darkPrimaryText = Color(0xFFEBF3FB);
  static const Color darkSecondaryText = Color(0xFF94A3B8);
  static const Color darkPrimary = Color(0xFF5DADE2);
  static const Color darkBorderColor = Color(0xFF334155);

  //  LIGHT
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightCard = Colors.white;
  static const Color primaryText = Color(0xFF1B3F6D);
  static const Color secondaryText = Color(0xFF4D6C8C);
  static const Color primary = Color(0xFF3498DB);
  static const Color borderColor = Color(0xFFBFDBFE);
  static const Color lightDark = Color(0xFF0B1326);
  static Color getStatusBg(bool isDark, double balance) {
    if (balance > 0) {
      return isDark
          ? Colors.green.withValues(alpha: 0.25)
          : Colors.green.withValues(alpha: 0.15);
    } else if (balance < 0) {
      return isDark
          ? Colors.red.withValues(alpha: 0.25)
          : Colors.red.withValues(alpha: 0.15);
    } else {
      return isDark
          ? Colors.grey.withValues(alpha: 0.3)
          : Colors.grey.withValues(alpha: 0.2);
    }
  }

  static Color getStatusText(bool isDark, double balance) {
    if (balance > 0) {
      return isDark ? Colors.green.shade300 : Colors.green.shade800;
    } else if (balance < 0) {
      return isDark ? Colors.red.shade300 : Colors.red.shade800;
    } else {
      return Colors.grey;
    }
  }

  static Color cardColor(bool isDark) => isDark ? darkCard : lightCard;

  static Color backgroundColor(bool isDark) =>
      isDark ? darkBackground : lightBackground;

  static Color textPrimary(bool isDark) =>
      isDark ? darkPrimaryText : primaryText;

  static Color textSecondary(bool isDark) =>
      isDark ? darkSecondaryText : secondaryText;

  static Color borderColorFor(bool isDark) =>
      isDark ? darkBorderColor : borderColor;
}
