import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:food_rating_app/utilities/background_service.dart';
import 'package:food_rating_app/utilities/date_time_helper.dart';

class SchedulingProvider extends ChangeNotifier {
  bool _isScheduled = false;
  bool get isScheduled => _isScheduled;

  Future<bool> scheduledDailyRestaurant(bool value) async {
    _isScheduled = value;
    if (_isScheduled) {
      print('Scheduling acitvated');
      notifyListeners();
      return await AndroidAlarmManager.periodic(
        const Duration(hours: 24),
        1,
        BackgroundService.callback,
        startAt: DateTimeHelper.format(),
        exact: true,
        wakeup: true,
      );
    } else {
      print('Scheduling canceled');
      notifyListeners();
      return await AndroidAlarmManager.cancel(1);
    }
  }
}
