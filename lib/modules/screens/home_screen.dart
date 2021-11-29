import 'package:flutter/material.dart';
import 'package:food_rating_app/modules/screens/restaurant/detail_screen.dart';
import 'package:food_rating_app/modules/screens/restaurant/favorite_screen.dart';
import 'package:food_rating_app/modules/screens/restaurant/list_screen.dart';
import 'package:food_rating_app/modules/screens/preferences/settings_screen.dart';
import 'package:food_rating_app/common/styles.dart';
import 'package:food_rating_app/utilities/notification_helper.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NotificationHelper _notificationHelper = NotificationHelper();

  @override
  void initState() {
    super.initState();
    _notificationHelper.configureSelectNotificationSubject(
      DetailScreen.routeName,
    );
  }

  @override
  void dispose() {
    selectNotificationSubject.close();
    super.dispose();
  }

  List<Widget> _buildScreens() {
    return [
      const ListScreen(),
      const FavoriteScreen(),
      const SettingsScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarItems(BuildContext context) {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.view_agenda),
        title: 'Beranda',
        textStyle: TextStyles.kRegularTitle.copyWith(
          fontWeight: FontWeight.w400,
        ),
        activeColorPrimary:
            Theme.of(context).bottomNavigationBarTheme.selectedItemColor!,
        inactiveColorPrimary:
            Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.favorite),
        title: 'Favorit',
        textStyle: TextStyles.kRegularTitle.copyWith(
          fontWeight: FontWeight.w400,
        ),
        activeColorPrimary:
            Theme.of(context).bottomNavigationBarTheme.selectedItemColor!,
        inactiveColorPrimary:
            Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.settings),
        title: 'Setelan',
        textStyle: TextStyles.kRegularTitle.copyWith(
          fontWeight: FontWeight.w400,
        ),
        activeColorPrimary:
            Theme.of(context).bottomNavigationBarTheme.selectedItemColor!,
        inactiveColorPrimary:
            Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      screens: _buildScreens(),
      items: _navBarItems(context),
      confineInSafeArea: true,
      backgroundColor:
          Theme.of(context).bottomNavigationBarTheme.backgroundColor!,
      navBarStyle: NavBarStyle.style9,
    );
  }
}
