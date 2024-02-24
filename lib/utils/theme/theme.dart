import 'package:flutter/material.dart';
import 'package:hungerheavend/utils/theme/custom_themes/appbar_theme.dart';
import 'package:hungerheavend/utils/theme/custom_themes/text_theme.dart';
import 'package:hungerheavend/utils/theme/custom_themes/text_field_theme.dart';
import 'package:hungerheavend/utils/theme/custom_themes/elevated_button_theme.dart';
import 'package:hungerheavend/utils/theme/custom_themes/bottom_sheet_theme.dart';
import 'package:hungerheavend/utils/theme/custom_themes/checkbox_theme.dart';
import 'package:hungerheavend/utils/theme/custom_themes/chip_theme.dart';
import 'package:hungerheavend/utils/theme/custom_themes/outlined_button_theme.dart';

class TAppTheme {
  TAppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: const Color.fromARGB(255, 230, 230, 230),
    textTheme: TTextTheme.darkTextTheme,
    elevatedButtonTheme: TElevatedButtonTheme.lightElevatedButtonTheme,
    appBarTheme: TAppBarTheme.lightAppBarTheme,
    chipTheme: TChipTheme.lightChipTheme,
    bottomSheetTheme: TBottomSheetTheme.lightBottomSheetThemeData,
    checkboxTheme: TCheckBoxTheme.lightCheckBoxTheme,
    outlinedButtonTheme: TOutlinedButtonTheme.lightOutlinedButtonTheme,
    inputDecorationTheme: TTextFormFieldTheme.lightInputDecorationTheme,
  );
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: const Color.fromARGB(60, 70, 70, 70),
    textTheme: TTextTheme.lightTextTheme,
    elevatedButtonTheme: TElevatedButtonTheme.darkElevatedButtonTheme,
    appBarTheme: TAppBarTheme.darkAppBarTheme,
    chipTheme: TChipTheme.darkChipTheme,
    bottomSheetTheme: TBottomSheetTheme.darkBottomSheetThemeData,
    checkboxTheme: TCheckBoxTheme.darkCheckBoxTheme,
    outlinedButtonTheme: TOutlinedButtonTheme.darkOutlinedButtonTheme,
    inputDecorationTheme: TTextFormFieldTheme.darkInputDecorationTheme,
  );
}
