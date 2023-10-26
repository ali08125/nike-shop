
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:nike/data/favorite_manager.dart';
import 'package:nike/data/repo/auth_repository.dart';
import 'package:nike/theme.dart';
import 'package:nike/ui/root.dart';

void main() async {
  await FavoriteManager.init();
  WidgetsFlutterBinding.ensureInitialized();
  authRepository.loadAuthInfo();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  final defaultTextStyle = const TextStyle(
      fontFamily: 'IranYekan', color: LightThemeColors.primaryTextColor);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
                extendedTextStyle: TextStyle(fontFamily: 'IranYekan')),
            inputDecorationTheme: InputDecorationTheme(
                border: const OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.black.withOpacity(0.1),
                    ))),
            appBarTheme: const AppBarTheme(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                elevation: 0),
            snackBarTheme: SnackBarThemeData(
                contentTextStyle: defaultTextStyle.apply(color: Colors.white)),
            colorScheme: const ColorScheme.light(
                primary: LightThemeColors.primaryColor,
                secondary: LightThemeColors.secondaryColor,
                onSecondary: Colors.white),
            dividerColor: Colors.grey.withOpacity(0.3),
            textTheme: TextTheme(
                labelLarge: defaultTextStyle.copyWith(
                    color: LightThemeColors.primaryColor,
                    fontWeight: FontWeight.bold),
                bodyMedium: defaultTextStyle,
                bodySmall: defaultTextStyle.apply(
                  color: LightThemeColors.secondaryTextColor,
                ),
                titleMedium: defaultTextStyle.copyWith(
                    color: LightThemeColors.secondaryTextColor),
                titleLarge:
                    defaultTextStyle.copyWith(fontWeight: FontWeight.bold))),
        home: const Directionality(
            textDirection: TextDirection.rtl, child: RootScreen()));
  }
}
