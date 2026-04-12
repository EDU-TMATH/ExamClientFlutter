import 'package:exam_client_flutter/constants/layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'TMath',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      themeMode: ThemeMode.system,
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
      builder: (context, child) => Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),
          child!,
        ],
      ),
    );
  }

  ThemeData _buildLightTheme() {
    const scheme = ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF0F3D69),
      onPrimary: Colors.white,
      primaryContainer: Color(0xFFD9E6F4),
      onPrimaryContainer: Color(0xFF0B2238),
      secondary: Color(0xFF4B5563),
      onSecondary: Colors.white,
      secondaryContainer: Color(0xFFE8EDF2),
      onSecondaryContainer: Color(0xFF1F2937),
      tertiary: Color(0xFF0B7285),
      onTertiary: Colors.white,
      tertiaryContainer: Color(0xFFD7EFF3),
      onTertiaryContainer: Color(0xFF082A30),
      error: Color(0xFFB42318),
      onError: Colors.white,
      errorContainer: Color(0xFFFEE4E2),
      onErrorContainer: Color(0xFF55160C),
      surface: Color(0xFFF4F7FA),
      onSurface: Color(0xFF111827),
      surfaceContainerLowest: Colors.white,
      surfaceContainerLow: Color(0xFFF8FAFC),
      surfaceContainer: Color(0xFFF1F5F9),
      surfaceContainerHigh: Color(0xFFE8EEF4),
      surfaceContainerHighest: Color(0xFFDCE4EC),
      onSurfaceVariant: Color(0xFF475467),
      outline: Color(0xFF98A2B3),
      outlineVariant: Color(0xFFD0D5DD),
      shadow: Color(0x12000000),
      scrim: Color(0x33000000),
      inverseSurface: Color(0xFF111827),
      onInverseSurface: Color(0xFFF8FAFC),
      inversePrimary: Color(0xFFAAC3DD),
      surfaceTint: Colors.transparent,
    );

    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: 'BeVietnamPro',
      colorScheme: scheme,
    );
    return _refineTheme(base);
  }

  ThemeData _buildDarkTheme() {
    const scheme = ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFF8EB7DB),
      onPrimary: Color(0xFF0B2238),
      primaryContainer: Color(0xFF143556),
      onPrimaryContainer: Color(0xFFD9E6F4),
      secondary: Color(0xFFB4BDC8),
      onSecondary: Color(0xFF1B2430),
      secondaryContainer: Color(0xFF273341),
      onSecondaryContainer: Color(0xFFE5E7EB),
      tertiary: Color(0xFF72C5D2),
      onTertiary: Color(0xFF072A31),
      tertiaryContainer: Color(0xFF0D4953),
      onTertiaryContainer: Color(0xFFD7EFF3),
      error: Color(0xFFF97066),
      onError: Color(0xFF55160C),
      errorContainer: Color(0xFF7A271A),
      onErrorContainer: Color(0xFFFEE4E2),
      surface: Color(0xFF0B1020),
      onSurface: Color(0xFFF8FAFC),
      surfaceContainerLowest: Color(0xFF111827),
      surfaceContainerLow: Color(0xFF121A2C),
      surfaceContainer: Color(0xFF182132),
      surfaceContainerHigh: Color(0xFF212C3E),
      surfaceContainerHighest: Color(0xFF293548),
      onSurfaceVariant: Color(0xFF98A2B3),
      outline: Color(0xFF667085),
      outlineVariant: Color(0xFF344054),
      shadow: Colors.black,
      scrim: Color(0x66000000),
      inverseSurface: Color(0xFFF8FAFC),
      onInverseSurface: Color(0xFF0F172A),
      inversePrimary: Color(0xFF0F3D69),
      surfaceTint: Colors.transparent,
    );

    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: 'BeVietnamPro',
      colorScheme: scheme,
    );
    return _refineTheme(base);
  }

  ThemeData _refineTheme(ThemeData base) {
    final scheme = base.colorScheme;
    final textTheme = _buildTextTheme(base.textTheme, scheme);

    return base.copyWith(
      textTheme: textTheme,
      pageTransitionsTheme: _pageTransitionsTheme,
      visualDensity: VisualDensity.compact,
      scaffoldBackgroundColor: Colors.transparent,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: scheme.primary,
        selectionColor: scheme.primary.withValues(alpha: 0.18),
        selectionHandleColor: scheme.primary,
      ),
      appBarTheme: base.appBarTheme.copyWith(
        elevation: 0,
        centerTitle: false,
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: scheme.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Layout.borderRadiusLg),
          side: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),
      listTileTheme: const ListTileThemeData(
        dense: true,
        horizontalTitleGap: 12,
        minVerticalPadding: 4,
      ),
      inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        filled: true,
        fillColor: scheme.surfaceContainerLow,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        labelStyle: textTheme.labelLarge?.copyWith(
          color: scheme.onSurfaceVariant,
          fontWeight: FontWeight.w600,
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: scheme.onSurfaceVariant.withValues(alpha: 0.9),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Layout.borderRadiusMd),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Layout.borderRadiusMd),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Layout.borderRadiusMd),
          borderSide: BorderSide(color: scheme.primary, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Layout.borderRadiusMd),
          borderSide: BorderSide(color: scheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Layout.borderRadiusMd),
          borderSide: BorderSide(color: scheme.error, width: 1.4),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: scheme.surfaceContainer,
        side: BorderSide(color: scheme.outlineVariant),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Layout.borderRadiusMd),
        ),
        labelStyle: textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w800,
          letterSpacing: 0.4,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: _buttonStyle(
          scheme: scheme,
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          borderColor: scheme.primary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: _buttonStyle(
          scheme: scheme,
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          borderColor: scheme.primary,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: _buttonStyle(
          scheme: scheme,
          backgroundColor: scheme.surfaceContainerLowest,
          foregroundColor: scheme.onSurface,
          borderColor: scheme.outline,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.primary,
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: 0.3,
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: scheme.onSurfaceVariant,
          backgroundColor: scheme.surfaceContainer,
          hoverColor: scheme.surfaceContainerHigh,
          highlightColor: scheme.surfaceContainerHigh,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Layout.borderRadiusMd),
            side: BorderSide(color: scheme.outlineVariant),
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: scheme.onInverseSurface,
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.primary,
        linearTrackColor: scheme.surfaceContainerHigh,
        circularTrackColor: scheme.surfaceContainerHigh,
      ),
    );
  }

  TextTheme _buildTextTheme(TextTheme base, ColorScheme scheme) {
    return base.copyWith(
      displaySmall: base.displaySmall?.copyWith(
        fontWeight: FontWeight.w800,
        letterSpacing: -1.0,
        height: 1.05,
      ),
      headlineSmall: base.headlineSmall?.copyWith(
        fontWeight: FontWeight.w800,
        letterSpacing: -0.6,
        height: 1.1,
      ),
      titleLarge: base.titleLarge?.copyWith(
        fontWeight: FontWeight.w800,
        letterSpacing: -0.2,
        height: 1.15,
      ),
      titleMedium: base.titleMedium?.copyWith(
        fontWeight: FontWeight.w700,
        height: 1.15,
      ),
      bodyLarge: base.bodyLarge?.copyWith(
        color: scheme.onSurface,
        height: 1.35,
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        color: scheme.onSurface,
        height: 1.35,
      ),
      bodySmall: base.bodySmall?.copyWith(
        color: scheme.onSurfaceVariant,
        height: 1.35,
      ),
      labelLarge: base.labelLarge?.copyWith(
        fontWeight: FontWeight.w800,
        letterSpacing: 0.35,
      ),
      labelMedium: base.labelMedium?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: 0.3,
      ),
      labelSmall: base.labelSmall?.copyWith(
        color: scheme.onSurfaceVariant,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
      ),
    );
  }

  ButtonStyle _buttonStyle({
    required ColorScheme scheme,
    required Color backgroundColor,
    required Color foregroundColor,
    required Color borderColor,
  }) {
    return ButtonStyle(
      elevation: const WidgetStatePropertyAll(0),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return scheme.surfaceContainerHighest;
        }
        if (states.contains(WidgetState.pressed)) {
          return Color.alphaBlend(
            scheme.onSurface.withValues(alpha: 0.08),
            backgroundColor,
          );
        }
        return backgroundColor;
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return scheme.onSurfaceVariant;
        }
        return foregroundColor;
      }),
      overlayColor: WidgetStatePropertyAll(
        scheme.onSurface.withValues(alpha: 0.06),
      ),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      ),
      minimumSize: const WidgetStatePropertyAll(Size(0, 44)),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Layout.borderRadiusMd),
          side: BorderSide(color: borderColor),
        ),
      ),
      textStyle: const WidgetStatePropertyAll(
        TextStyle(
          fontFamily: 'BeVietnamPro',
          fontSize: Layout.textSm,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.3,
        ),
      ),
      iconSize: const WidgetStatePropertyAll(18),
    );
  }

  static const PageTransitionsTheme _pageTransitionsTheme =
      PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeScalePageTransitionsBuilder(),
          TargetPlatform.iOS: FadeScalePageTransitionsBuilder(),
          TargetPlatform.macOS: FadeScalePageTransitionsBuilder(),
          TargetPlatform.windows: FadeScalePageTransitionsBuilder(),
          TargetPlatform.linux: FadeScalePageTransitionsBuilder(),
        },
      );
}

class FadeScalePageTransitionsBuilder extends PageTransitionsBuilder {
  const FadeScalePageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final fastCurve = CurvedAnimation(
      parent: animation,
      curve: const Interval(0.0, 0.45, curve: Curves.easeOutCubic),
    );

    final fadeAnimation = CurvedAnimation(
      parent: fastCurve,
      curve: Curves.linear,
    );

    final scaleAnimation = Tween<double>(
      begin: 0.985,
      end: 1,
    ).animate(fastCurve);

    return FadeTransition(
      opacity: fadeAnimation,
      child: ScaleTransition(scale: scaleAnimation, child: child),
    );
  }
}
