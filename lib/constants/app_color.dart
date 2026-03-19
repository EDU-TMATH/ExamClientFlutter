import 'package:flutter/material.dart';

class ColorPalette {
  final Map<int, Color> colors;

  const ColorPalette(this.colors);

  Color shade(int shade) => colors[shade]!;
}

const gray = ColorPalette({
  50: Color(0xFFF9FAFB),
  100: Color(0xFFF3F4F6),
  200: Color(0xFFE5E7EB),
  300: Color(0xFFD1D5DB),
  400: Color(0xFF9CA3AF),
  500: Color(0xFF6B7280),
  600: Color(0xFF4B5563),
  700: Color(0xFF374151),
  800: Color(0xFF1F2937),
  900: Color(0xFF111827),
  950: Color(0xFF030712),
});

const red = ColorPalette({
  50: Color(0xFFFEF2F2),
  100: Color(0xFFFEE2E2),
  200: Color(0xFFFECACA),
  300: Color(0xFFFCA5A5),
  400: Color(0xFFF87171),
  500: Color(0xFFEF4444),
  600: Color(0xFFDC2626),
  700: Color(0xFFB91C1C),
  800: Color(0xFF991B1B),
  900: Color(0xFF7F1D1D),
  950: Color(0xFF450A0A),
});

const indigo = ColorPalette({
  50: Color(0xFFEEF2FF),
  100: Color(0xFFE0E7FF),
  200: Color(0xFFC7D2FE),
  300: Color(0xFFA5B4FC),
  400: Color(0xFF818CF8),
  500: Color(0xFF6366F1),
  600: Color(0xFF4F46E5),
  700: Color(0xFF4338CA),
  800: Color(0xFF3730A3),
  900: Color(0xFF312E81),
  950: Color(0xFF1E1B4B),
});

const blue = ColorPalette({
  50: Color(0xFFEFF6FF),
  100: Color(0xFFDBEAFE),
  200: Color(0xFFBFDBFE),
  300: Color(0xFF93C5FD),
  400: Color(0xFF60A5FA),
  500: Color(0xFF3B82F6),
  600: Color(0xFF2563EB),
  700: Color(0xFF1D4ED8),
  800: Color(0xFF1E40AF),
  900: Color(0xFF1E3A8A),
  950: Color(0xFF172554),
});

const green = ColorPalette({
  50: Color(0xFFF0FDF4),
  100: Color(0xFFDCFCE7),
  200: Color(0xFFBBF7D0),
  300: Color(0xFF86EFAC),
  400: Color(0xFF4ADE80),
  500: Color(0xFF22C55E),
  600: Color(0xFF16A34A),
  700: Color(0xFF15803D),
  800: Color(0xFF166534),
  900: Color(0xFF14532D),
  950: Color(0xFF052E16),
});

const sky = ColorPalette({
  50: Color(0xFFF0F9FF),
  100: Color(0xFFE0F2FE),
  200: Color(0xFFBAE6FD),
  300: Color(0xFF7DD3FC),
  400: Color(0xFF38BDF8),
  500: Color(0xFF0EA5E9),
  600: Color(0xFF0284C7),
  700: Color(0xFF0369A1),
  800: Color(0xFF075985),
  900: Color(0xFF0C4A6E),
  950: Color(0xFF082F49),
});

const violet = ColorPalette({
  50: Color(0xFFF5F3FF),
  100: Color(0xFFEDE9FE),
  200: Color(0xFFDDD6FE),
  300: Color(0xFFC4B5FD),
  400: Color(0xFFA78BFA),
  500: Color(0xFF8B5CF6),
  600: Color(0xFF7C3AED),
  700: Color(0xFF6D28D9),
  800: Color(0xFF5B21B6),
  900: Color(0xFF4C1D95),
  950: Color(0xFF2E1065),
});

const purple = ColorPalette({
  50: Color(0xFFFAF5FF),
  100: Color(0xFFF3E8FF),
  200: Color(0xFFE9D5FF),
  300: Color(0xFFD8B4FE),
  400: Color(0xFFC084FC),
  500: Color(0xFFA855F7),
  600: Color(0xFF9333EA),
  700: Color(0xFF7E22CE),
  800: Color(0xFF6B21A8),
  900: Color(0xFF581C87),
  950: Color(0xFF3B0764),
});

const slate = ColorPalette({
  50: Color(0xFFFAFAFA),
  100: Color(0xFFF4F4F5),
  200: Color(0xFFE4E4E7),
  300: Color(0xFFD4D4D8),
  400: Color(0xFFA1A1AA),
  500: Color(0xFF71717A),
  600: Color(0xFF52525B),
  700: Color(0xFF3F3F46),
  800: Color(0xFF27272A),
  900: Color(0xFF18181B),
  950: Color(0xFF09090B),
});

const orange = ColorPalette({
  50: Color(0xFFFFF7ED),
  100: Color(0xFFFFEDD5),
  200: Color(0xFFFFDAB4),
  300: Color(0xFFFFB981),
  400: Color(0xFFFF924C),
  500: Color(0xFFFF7A1F),
  600: Color(0xFFFB5607),
  700: Color(0xFFEF4444),
  800: Color(0xFFDC2626),
  900: Color(0xFFB91C1C),
  950: Color(0xFF7F1D1D),
});

const yellow = ColorPalette({
  50: Color(0xFFFFFCE7),
  100: Color(0xFFFFF9C3),
  200: Color(0xFFFFF59E),
  300: Color(0xFFFFF066),
  400: Color(0xFFFFE44B),
  500: Color(0xFFFFD700),
  600: Color(0xFFFFC107),
  700: Color(0xFFFFA000),
  800: Color(0xFFFF8F00),
  900: Color(0xFFFF6F00),
  950: Color(0xFFFF3D00),
});

const cyan = ColorPalette({
  50: Color(0xFFECFEFF),
  100: Color(0xFFCFFAFE),
  200: Color(0xFFA5F3FC),
  300: Color(0xFF67E8F9),
  400: Color(0xFF22D3EE),
  500: Color(0xFF06B6D4),
  600: Color(0xFF0891B2),
  700: Color(0xFF0E7490),
  800: Color(0xFF155E75),
  900: Color(0xFF164E63),
  950: Color(0xFF083344),
});
