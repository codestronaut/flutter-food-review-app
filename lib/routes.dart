import 'package:flutter/material.dart';
import 'package:food_rating_app/modules/screens/home_screen.dart';
import 'package:food_rating_app/modules/screens/restaurant/detail_screen.dart';
import 'package:food_rating_app/modules/screens/restaurant/list_screen.dart';
import 'package:food_rating_app/modules/screens/restaurant/review_screen.dart';
import 'package:food_rating_app/modules/screens/restaurant/search_screen.dart';

Map<String, WidgetBuilder> allRoute(BuildContext context) {
  return {
    HomeScreen.routeName: (context) => const HomeScreen(),
    ListScreen.routeName: (context) => const ListScreen(),
    DetailScreen.routeName: (context) => DetailScreen(
          id: ModalRoute.of(context)!.settings.arguments as String,
        ),
    ReviewScreen.routeName: (context) => ReviewScreen(
          id: ModalRoute.of(context)!.settings.arguments as String,
        ),
    SearchScreen.routeName: (context) => const SearchScreen()

    /// TODO: Add more later
  };
}
