import 'package:alfred_app/generated/colors.gen.dart';
import 'package:alfred_app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DefaultAppTheme extends AppTheme {
  @override
  ThemeData data = _defaultTheme;

  final ButtonStyle _iconButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: AppColors.colorPrimary,
    foregroundColor: Colors.white,
    shape: const CircleBorder(),
    minimumSize: const Size.square(40),
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    padding: EdgeInsets.zero,
    elevation: 0,
  );

  @override
  ButtonStyle get iconButtonStyle => _iconButtonStyle;

  @override
  ButtonStyle get secondaryIconButtonStyle => _iconButtonStyle.copyWith(
      // backgroundColor: const MaterialStatePropertyAll(Colors.black26),
      // foregroundColor: const MaterialStatePropertyAll(AppColors.colorPrimary),
      );
}

final _defaultTheme = ThemeData(
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.colorBackgroundPopUp,
    shadowColor: Colors.transparent,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.w700,
    ),
  ),
  colorScheme: ColorScheme.fromSwatch().copyWith(
    primary: AppColors.colorPrimary,
    // error: AppColors.error,
    onPrimary: Colors.white,
  ),
  textTheme: GoogleFonts.latoTextTheme(
    TextTheme(
      displayLarge: GoogleFonts.lato(
        fontSize: 32,
        height: 40 / 32,
        color: Colors.white,
        fontWeight: FontWeight.w700,
      ),
      displayMedium: GoogleFonts.lato(
        fontSize: 26,
        height: 34 / 26,
        color: Colors.white,
        fontWeight: FontWeight.w700,
      ),
      displaySmall: GoogleFonts.lato(
        fontSize: 22,
        height: 31 / 22,
        color: Colors.white,
        fontWeight: FontWeight.w700,
      ),
      headlineMedium: GoogleFonts.lato(
        fontSize: 20,
        height: 28 / 29,
        color: Colors.white,
        fontWeight: FontWeight.w700,
      ),
      headlineSmall: GoogleFonts.lato(
        fontSize: 18,
        height: 28 / 18,
        color: Colors.white,
        fontWeight: FontWeight.w700,
      ),
      titleLarge: GoogleFonts.lato(
        fontSize: 16,
        height: 24 / 16,
        color: Colors.white,
        fontWeight: FontWeight.w700,
      ),
      titleMedium: GoogleFonts.lato(
        fontSize: 16,
        height: 24 / 16,
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: GoogleFonts.lato(
        fontSize: 14,
        height: 22 / 14,
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: _bodyLarge,
      bodyMedium: _bodyMedium,
      bodySmall: _bodySmall,
      labelSmall: GoogleFonts.lato(
        fontSize: 12,
        height: 18 / 12,
        color: Colors.white,
        fontWeight: FontWeight.w700,
      ),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    labelStyle: _bodyLarge.copyWith(),
    border: const UnderlineInputBorder(
      borderSide: BorderSide(
        color: AppColors.colorPrimary,
      ),
    ),
    enabledBorder: const UnderlineInputBorder(
      borderSide: BorderSide(
        color: AppColors.colorPrimary,
      ),
    ),
    focusedBorder: const UnderlineInputBorder(
      borderSide: BorderSide(
        color: AppColors.colorPrimary,
      ),
    ),
    errorStyle: _bodySmall,
    // hintStyle: _bodyMedium.copyWith(color: AppColors.gray600),
    contentPadding: const EdgeInsets.symmetric(
      vertical: 11,
      horizontal: 14,
    ),
    isDense: true,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      minimumSize: const Size(0, 48),
      textStyle: _bodyLarge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      textStyle: _bodyMedium.copyWith(
        fontWeight: FontWeight.w600,
        // color: Colors.white,
      ),
      // foregroundColor: AppColors.info,
      minimumSize: Size.zero,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  ),
  dividerTheme: const DividerThemeData(
    thickness: 1,
    space: 1,
    // color: AppColors.gray300,
  ),
  chipTheme: ChipThemeData(
    showCheckmark: false,
    // selectedColor: AppColors.primary,
    backgroundColor: Colors.white,
    labelStyle: _bodyMedium.copyWith(color: Colors.white),
    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
    ),
    shadowColor: Colors.transparent,
    selectedShadowColor: Colors.transparent,
  ),
  scaffoldBackgroundColor: AppColors.colorPrimaryBackground,
);

final _bodyLarge = GoogleFonts.lato(
  fontSize: 16,
  height: 24 / 16,
  color: Colors.white,
  fontWeight: FontWeight.w400,
);

final _bodyMedium = GoogleFonts.lato(
  fontSize: 14,
  height: 22 / 14,
  color: Colors.white,
  fontWeight: FontWeight.w400,
);

final _bodySmall = GoogleFonts.lato(
  fontSize: 12,
  height: 18 / 12,
  color: Colors.white,
  fontWeight: FontWeight.w400,
);
