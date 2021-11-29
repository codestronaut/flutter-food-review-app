import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:food_rating_app/common/navigation.dart';
import 'package:food_rating_app/data/api/urls.dart';
import 'package:food_rating_app/modules/providers/restaurant_provider.dart';
import 'package:food_rating_app/modules/screens/restaurant/detail_screen.dart';
import 'package:food_rating_app/modules/screens/restaurant/search_screen.dart';
import 'package:food_rating_app/modules/screens/restaurant/widgets/animation_placeholder.dart';
import 'package:food_rating_app/modules/screens/restaurant/widgets/restaurant_card.dart';
import 'package:food_rating_app/common/styles.dart';
import 'package:provider/provider.dart';

class ListScreen extends StatefulWidget {
  static const routeName = '/list';
  const ListScreen({Key? key}) : super(key: key);

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> with TickerProviderStateMixin {
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

  Widget _buildGreetings(BuildContext context) {
    int hour = DateTime.now().hour;

    return FadeInUp(
      from: 20.0,
      duration: const Duration(milliseconds: 500),
      child: Container(
        margin: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              (hour >= 0 && hour < 12)
                  ? 'Selamat Pagi  🧇'
                  : (hour >= 12 && hour < 15)
                      ? 'Selamat Siang  🍨'
                      : (hour >= 15 && hour < 18)
                          ? 'Selamat Sore  ☕'
                          : 'Selamat Malam  🍗',
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 14.0),
            Text(
              'Telusuri Restoran Favoritmu',
              // style: TextStyles.kHeading1.copyWith(
              //   color: customBlack,
              //   fontSize: 32.0,
              //   height: 1.2,
              // ),
              style: Theme.of(context).textTheme.headline4!.copyWith(
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context) {
    return Consumer<ListProvider>(
      builder: (context, provider, _) {
        switch (provider.fetchListState) {
          case FetchResultState.loading:
            return const Padding(
              padding: EdgeInsets.only(top: 100.0),
              child: SpinKitFadingCircle(color: customBlue),
            );
          case FetchResultState.noData:
            return Padding(
              padding: const EdgeInsets.only(top: 100.0),
              child: AnimationPlaceholder(
                animation: 'assets/not-found.json',
                text: 'Ops! Sepertinya restoran tidak tersedia',
                hasButton: true,
                buttonText: 'Refresh',
                // onButtonTap: () => provider.fetchRestaurantList(),
                onButtonTap: () {},
              ),
            );
          case FetchResultState.hasData:
            return FadeInUp(
              from: 20.0,
              duration: const Duration(milliseconds: 500),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: provider.restaurants!.items!.length,
                itemBuilder: (context, index) {
                  return RestaurantCard(
                    item: provider.restaurants!.items!.reversed.toList()[index],
                  );
                },
              ),
            );
          case FetchResultState.failure:
            return Padding(
              padding: const EdgeInsets.only(top: 100.0),
              child: AnimationPlaceholder(
                animation: 'assets/no-internet.json',
                text: 'Ops! Sepertinya koneksi internetmu dalam masalah',
                hasButton: true,
                buttonText: 'Refresh',
                // onButtonTap: () => provider.fetchRestaurantList(),
                onButtonTap: () {},
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
              backgroundColor: _colorTween.value,
              toolbarHeight: 96.0,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'FoodReview',
                    style: Theme.of(context).appBarTheme.toolbarTextStyle,
                  ),
                  CircleAvatar(
                    backgroundColor: Theme.of(context)
                        .colorScheme
                        .primaryVariant
                        .withOpacity(0.6),
                    radius: 24,
                    child: IconButton(
                      splashRadius: 4.0,
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.search),
                      color: Theme.of(context).primaryIconTheme.color,
                      onPressed: () =>
                          Navigation.intentWithData(SearchScreen.routeName),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: _scrollListener,
        child: ListView(
          children: [
            _buildGreetings(context),
            _buildList(context),
          ],
        ),
      ),
    );
  }
}
