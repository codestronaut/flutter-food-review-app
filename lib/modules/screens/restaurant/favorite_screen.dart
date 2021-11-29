import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:food_rating_app/data/api/urls.dart';
import 'package:food_rating_app/modules/providers/database_provider.dart';
import 'package:food_rating_app/modules/screens/restaurant/detail_screen.dart';
import 'package:food_rating_app/modules/screens/restaurant/widgets/animation_placeholder.dart';
import 'package:food_rating_app/modules/screens/restaurant/widgets/restaurant_card.dart';
import 'package:food_rating_app/common/styles.dart';
import 'package:provider/provider.dart';

class FavoriteScreen extends StatefulWidget {
  static const routeName = '/favorite';
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen>
    with TickerProviderStateMixin {
  late AnimationController _colorAnimationController;
  late Animation _colorTween;

  @override
  void initState() {
    super.initState();
    _colorAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 0),
    );
  }

  @override
  void dispose() {
    _colorAnimationController.dispose();
    super.dispose();
  }

  bool _scrollListener(ScrollNotification scrollInfo) {
    if (scrollInfo.metrics.axis == Axis.vertical) {
      _colorAnimationController.animateTo(scrollInfo.metrics.pixels / 350);
      return true;
    }
    return false;
  }

  Widget _buildListFavorite(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (context, provider, _) {
        final favoriteRestaurants = provider.favorites;

        switch (provider.databaseResultState) {
          case DatabaseResultState.noData:
            return const Center(
              child: AnimationPlaceholder(
                animation: 'assets/empty.json',
                text: 'Tidak ada favorit untuk saat ini',
              ),
            );
          case DatabaseResultState.hasData:
            return FadeInUp(
              from: 20.0,
              duration: const Duration(milliseconds: 500),
              child: ListView.builder(
                itemCount: favoriteRestaurants.length,
                itemBuilder: (context, index) {
                  final favoriteRestaurant = favoriteRestaurants[index];
                  return RestaurantCard(item: favoriteRestaurant);
                },
              ),
            );
          case DatabaseResultState.error:
            return const Center(
              child: AnimationPlaceholder(
                animation: 'assets/not-found.json',
                text: 'Maaf, sepertinya ada masalah',
              ),
            );
          default:
            return const SizedBox();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _colorTween = ColorTween(
      begin: Theme.of(context).scaffoldBackgroundColor,
      end: Theme.of(context).appBarTheme.backgroundColor,
    ).animate(_colorAnimationController);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(96.0),
        child: AnimatedBuilder(
          animation: _colorAnimationController,
          builder: (context, child) {
            return AppBar(
              elevation: 0.0,
              titleSpacing: 24.0,
              centerTitle: false,
              automaticallyImplyLeading: false,
              backgroundColor: _colorTween.value,
              toolbarHeight: 96.0,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Favorite',
                    style: Theme.of(context).appBarTheme.toolbarTextStyle,
                  ),
                  IconButton(
                    splashRadius: 24.0,
                    splashColor: Colors.redAccent[100],
                    padding: EdgeInsets.zero,
                    icon: const Icon(
                      Icons.delete_forever,
                      color: Colors.redAccent,
                    ),
                    color: black,
                    onPressed: () {
                      Provider.of<DatabaseProvider>(
                        context,
                        listen: false,
                      ).deleteAllFavorite();
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: _scrollListener,
        child: _buildListFavorite(context),
      ),
    );
  }
}
