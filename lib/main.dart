import 'package:exam_client_flutter/constants/layout.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/router/app_router.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Exam Client',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      themeMode: ThemeMode.system,
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
    );
  }

  ThemeData _buildLightTheme() {
    final base = FlexThemeData.light(
      scheme: FlexScheme.blueM3,
      useMaterial3: true,
      surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
      blendLevel: 6,
      subThemesData: const FlexSubThemesData(
        blendOnLevel: 8,
        blendOnColors: false,
        cardRadius: 12,
        inputDecoratorRadius: 10,
        filledButtonRadius: 10,
        elevatedButtonRadius: 10,
        outlinedButtonRadius: 10,
      ),
      textTheme: GoogleFonts.interTextTheme(),
    );
    return _refineTheme(base);
  }

  ThemeData _buildDarkTheme() {
    final base = FlexThemeData.dark(
      scheme: FlexScheme.blueM3,
      useMaterial3: true,
      surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
      blendLevel: 10,
      subThemesData: const FlexSubThemesData(
        blendOnLevel: 12,
        blendOnColors: false,
        cardRadius: 12,
        inputDecoratorRadius: 10,
        filledButtonRadius: 10,
        elevatedButtonRadius: 10,
        outlinedButtonRadius: 10,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
    );
    return _refineTheme(base);
  }

  ThemeData _refineTheme(ThemeData base) {
    final scheme = base.colorScheme;
    final textTheme = base.textTheme;

    return base.copyWith(
      pageTransitionsTheme: _pageTransitionsTheme,
      visualDensity: VisualDensity.compact,
      scaffoldBackgroundColor: scheme.surface,
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
          borderRadius: BorderRadius.circular(Layout.borderRadiusXl),
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
          vertical: 10,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Layout.borderRadiusLg),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Layout.borderRadiusLg),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Layout.borderRadiusLg),
          borderSide: BorderSide(color: scheme.primary, width: 1.2),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: scheme.surfaceContainerHigh,
        side: BorderSide(color: scheme.outlineVariant),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Layout.borderRadiusLg),
        ),
        labelStyle: textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: scheme.onInverseSurface,
        ),
      ),
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
      curve: const Interval(0.0, 0.55, curve: Curves.easeOutCubic),
    );

    final fadeAnimation = CurvedAnimation(
      parent: fastCurve,
      curve: Curves.linear,
    );

    final scaleAnimation = Tween<double>(
      begin: 0.96,
      end: 1,
    ).animate(fastCurve);

    return FadeTransition(
      opacity: fadeAnimation,
      child: ScaleTransition(scale: scaleAnimation, child: child),
    );
  }
}
