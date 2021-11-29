import 'package:flutter/material.dart';
import 'package:food_rating_app/modules/screens/preferences/preferences_helper.dart';
import 'package:food_rating_app/common/styles.dart';

class PreferencesProvider extends ChangeNotifier {
  final PreferencesHelper preferencesHelper;

  bool _isDarkTheme = false;
  bool get isDarkTheme => _isDarkTheme;

  bool _isDailyRestaurantActive = false;
  bool get isDailyRestaurantActive => _isDailyRestaurantActive;

  PreferencesProvider({required this.preferencesHelper}) {
    _getTheme();
    _getDailyRestaurant();
  }

  void _getTheme() async {
    _isDarkTheme = await preferencesHelper.isDarkTheme;
    notifyListeners();
  }

  void _getDailyRestaurant() async {
    _isDailyRestaurantActive = await preferencesHelper.isDailyRestaurantActive;
    notifyListeners();
  }

  void enableDarkTheme(bool value) async {
    preferencesHelper.setDarkTheme(value);
    _getTheme();
  }

  void enableDailyRestaurant(bool value) async {
    preferencesHelper.setDailyRestaurantActive(value);
    _getDailyRestaurant();
  }

  ThemeData get themeData => _isDarkTheme ? darkTheme : lightTheme;
}
