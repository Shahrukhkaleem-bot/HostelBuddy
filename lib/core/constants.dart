import 'package:flutter/material.dart';

class AppColors {
  // Primary - Deep Navy
  static const Color navy = Color(0xFF0F1B33);
  static const Color navyLight = Color(0xFF1B2A4A);
  static const Color navyLighter = Color(0xFF2C3E6B);
  static const Color navyMid = Color(0xFF3A4F7A);

  // Neutrals
  static const Color white = Color(0xFFFFFFFF);
  static const Color offWhite = Color(0xFFF8FAFC);
  static const Color gray50 = Color(0xFFF5F7FA);
  static const Color gray100 = Color(0xFFE8ECF1);
  static const Color gray200 = Color(0xFFD1D8E0);
  static const Color gray300 = Color(0xFFB0BCC8);
  static const Color gray500 = Color(0xFF6B7A8F);
  static const Color gray700 = Color(0xFF3D4A5C);
  static const Color gray900 = Color(0xFF1A1A2E);

  // Green - success / accents
  static const Color green = Color(0xFF00866A);
  static const Color greenLight = Color(0xFF55EFC4);
  static const Color greenDark = Color(0xFF009973);
  static const Color greenBg = Color(0xFFE6F9F3);

  // Semantic
  static const Color error = Color(0xFFE74C3C);
  static const Color warning = Color(0xFFF39C12);
  static const Color info = Color(0xFF3498DB);
  static const Color whatsapp = Color(0xFF25D366);

  // Success states
  static const Color successLight = Color(0xFFE6F9F3);
  static const Color successMain = Color(0xFF00866A);
  static const Color successDark = Color(0xFF009973);

  // Info/Highlight
  static const Color infoLight = Color(0xFFEBF5FF);
  static const Color infoMain = Color(0xFF3498DB);

  // Backgrounds
  static const Color bgSubtle = Color(0xFFFAFBFC);
  static const Color bgAccent = Color(0xFFF0F4F9);
}

class AppSpacing {
  static const double space1 = 4.0;
  static const double space2 = 8.0;
  static const double space3 = 12.0;
  static const double space4 = 16.0;
  static const double space5 = 20.0;
  static const double space6 = 24.0;
  static const double space8 = 32.0;
  static const double space10 = 40.0;
  static const double space12 = 48.0;
}

class AppRadius {
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double full = 9999.0;
}

class AppTypography {
  static const String fontFamily = 'Roboto';

  static const double fontSize_xs = 11.0;
  static const double fontSize_sm = 13.0;
  static const double fontSize_base = 15.0;
  static const double fontSize_lg = 18.0;
  static const double fontSize_xl = 22.0;
  static const double fontSize_2xl = 28.0;
}

class AppShadows {
  static const BoxShadow sm = BoxShadow(
    color: Color.fromRGBO(15, 27, 51, 0.08),
    blurRadius: 3,
    offset: Offset(0, 1),
  );

  static const BoxShadow md = BoxShadow(
    color: Color.fromRGBO(15, 27, 51, 0.12),
    blurRadius: 16,
    offset: Offset(0, 4),
  );

  static const BoxShadow lg = BoxShadow(
    color: Color.fromRGBO(15, 27, 51, 0.16),
    blurRadius: 32,
    offset: Offset(0, 8),
  );

  static const BoxShadow xl = BoxShadow(
    color: Color.fromRGBO(15, 27, 51, 0.20),
    blurRadius: 48,
    offset: Offset(0, 12),
  );
}

class AppDurations {
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration med = Duration(milliseconds: 350);
  static const Duration slow = Duration(milliseconds: 500);
}
