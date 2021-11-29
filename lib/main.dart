import 'dart:io';

import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:food_rating_app/common/navigation.dart';
import 'package:food_rating_app/data/api/api_service.dart';
import 'package:food_rating_app/data/database/database_helper.dart';
import 'package:food_rating_app/modules/providers/database_provider.dart';
import 'package:food_rating_app/modules/providers/restaurant_provider.dart';
import 'package:food_rating_app/modules/providers/scheduling_provider.dart';
import 'package:food_rating_app/modules/screens/home_screen.dart';
import 'package:food_rating_app/modules/screens/preferences/preferences_helper.dart';
import 'package:food_rating_app/modules/providers/preferences_provider.dart';
import 'package:food_rating_app/routes.dart';
import 'package:food_rating_app/utilities/background_service.dart';
import 'package:food_rating_app/utilities/notification_helper.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final NotificationHelper _notificationHelper = NotificationHelper();
  final BackgroundService _service = BackgroundService();

  _service.initializeIsolate();

  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }

  await _notificationHelper.initNotifications(flutterLocalNotificationsPlugin);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ListProvider>(
          create: (_) => ListProvider(
            apiService: ApiService(),
          ),
        ),
        ChangeNotifierProvider<DetailProvider>(
          create: (_) => DetailProvider(
            apiService: ApiService(),
          ),
        ),
        ChangeNotifierProvider<SearchProvider>(
          create: (_) => SearchProvider(
            apiService: ApiService(),
          ),
        ),
        ChangeNotifierProvider<ReviewProvider>(
          create: (_) => ReviewProvider(
            apiService: ApiService(),
          ),
        ),
        ChangeNotifierProvider<DatabaseProvider>(
          create: (_) => DatabaseProvider(
            databaseHelper: DatabaseHelper(),
          ),
        ),
        ChangeNotifierProvider<PreferencesProvider>(
          create: (_) => PreferencesProvider(
            preferencesHelper: PreferencesHelper(
              sharedPreferences: SharedPreferences.getInstance(),
            ),
          ),
        ),
        ChangeNotifierProvider<SchedulingProvider>(
          create: (_) => SchedulingProvider(),
        ),
      ],
      child: const FoodRatingApp(),
    ),
  );
}

class FoodRatingApp extends StatelessWidget {
  const FoodRatingApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PreferencesProvider>(
      builder: (context, provider, _) {
        return MaterialApp(
          title: 'Food Rating App',
          debugShowCheckedModeBanner: false,
          theme: provider.themeData,
          initialRoute: HomeScreen.routeName,
          navigatorKey: navigatorKey,
          routes: allRoute(context),
        );
      },
    );
  }
}
