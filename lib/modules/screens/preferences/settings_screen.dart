import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_rating_app/common/navigation.dart';
import 'package:food_rating_app/modules/providers/preferences_provider.dart';
import 'package:food_rating_app/modules/providers/scheduling_provider.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  customDialog(BuildContext context) {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('Segera!'),
            content: const Text('Fitur ini belum tersedia'),
            actions: [
              CupertinoDialogAction(
                child: const Text('Okay'),
                onPressed: () {
                  Navigation.back();
                },
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Segera!'),
            content: const Text('Fitur ini belum tersedia'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigation.back();
                },
                child: const Text('Okay'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(96.0),
        child: AppBar(
          elevation: 0.0,
          titleSpacing: 24.0,
          centerTitle: false,
          automaticallyImplyLeading: false,
          toolbarHeight: 96.0,
          backgroundColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarBrightness: Theme.of(context).brightness,
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Setelan',
                style: Theme.of(context).appBarTheme.toolbarTextStyle,
              ),
            ],
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        children: [
          Material(
            color: Colors.transparent,
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Dark Theme'),
              trailing: Consumer<PreferencesProvider>(
                builder: (context, provider, _) {
                  return Switch.adaptive(
                    value: provider.isDarkTheme,
                    onChanged: (value) {
                      provider.enableDarkTheme(value);
                    },
                    inactiveThumbColor:
                        Theme.of(context).colorScheme.primaryVariant,
                    activeColor: Theme.of(context).colorScheme.secondary,
                  );
                },
              ),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Daily Restaurant'),
              trailing: Consumer<SchedulingProvider>(
                builder: (context, provider, _) {
                  return Switch.adaptive(
                    value: provider.isScheduled,
                    onChanged: (value) async {
                      if (Platform.isIOS) {
                        customDialog(context);
                      } else {
                        provider.scheduledDailyRestaurant(value);
                      }
                    },
                    inactiveThumbColor:
                        Theme.of(context).colorScheme.primaryVariant,
                    activeColor: Theme.of(context).colorScheme.secondary,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
