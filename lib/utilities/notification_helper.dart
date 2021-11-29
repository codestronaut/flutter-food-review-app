import 'dart:convert';
import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:food_rating_app/data/models/restaurant.dart';
import 'package:food_rating_app/common/navigation.dart';
import 'package:rxdart/subjects.dart';

final selectNotificationSubject = BehaviorSubject<String>();

class NotificationHelper {
  int index = Random().nextInt(20);
  static NotificationHelper? _instance;

  NotificationHelper._internal() {
    _instance = this;
  }

  factory NotificationHelper() => _instance ?? NotificationHelper._internal();

  Future<void> initNotifications(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
  ) async {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('app_icon');

    var initializationSettingsIOS = const IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
      if (payload != null) {
        print('notification payload: ' + payload);
      }

      selectNotificationSubject.add(payload ?? 'empty payload');
    });
  }

  Future<void> showNotification(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    Restaurants restaurants,
  ) async {
    var _channelId = '1';
    var _channelName = 'channel_01';
    var _channelDescription = 'daily restaurant channel';

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      styleInformation: const DefaultStyleInformation(true, true),
    );

    var iOSPlatformChannelSpecifics = const IOSNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    var notificationTitle = '<b>Rekomendasi Restoran Hari Ini</b>';
    var restaurantName = restaurants.items![index].name;

    await flutterLocalNotificationsPlugin.show(
      0,
      notificationTitle,
      restaurantName,
      platformChannelSpecifics,
      payload: json.encode(
        restaurants.toMap(),
      ),
    );
  }

  void configureSelectNotificationSubject(String route) {
    selectNotificationSubject.stream.listen((String payload) {
      var data = Restaurants.fromMap(json.decode(payload));
      var restaurant = data.items![index];
      Navigation.intentWithData(route, arguments: restaurant.id);
    });
  }
}
