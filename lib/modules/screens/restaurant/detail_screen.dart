import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:food_rating_app/common/navigation.dart';
import 'package:food_rating_app/data/api/urls.dart';
import 'package:food_rating_app/modules/providers/database_provider.dart';
import 'package:food_rating_app/data/models/restaurant.dart';
import 'package:food_rating_app/modules/providers/restaurant_provider.dart';
import 'package:food_rating_app/modules/screens/restaurant/review_screen.dart';
import 'package:food_rating_app/modules/screens/restaurant/widgets/animation_placeholder.dart';
import 'package:food_rating_app/common/styles.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

class DetailScreen extends StatefulWidget {
  static const routeName = '/detail';

  final String id;
  const DetailScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen>
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

  Widget _buildInfo(Item restaurant) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Categories
          Container(
            margin: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                for (final category in restaurant.categories!)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 4.0,
                    ),
                    margin: const EdgeInsets.only(right: 8.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primaryVariant
                          .withOpacity(0.8),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      category.name!,
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ),
              ],
            ),
          ),

          /// Name
          Container(
            margin: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              restaurant.name!,
              style: Theme.of(context)
                  .textTheme
                  .headline5!
                  .copyWith(fontWeight: FontWeight.w700),
            ),
          ),

          /// Rating, Location
          Container(
            margin: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                        color: customYellow,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: const Icon(
                        Icons.star,
                        color: Colors.white,
                        size: 20.0,
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Text(
                      '${restaurant.rating}',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ),
                const SizedBox(width: 32.0),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                        color: customBlue,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 20.0,
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Text(
                      restaurant.city!,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ),
              ],
            ),
          ),

          /// Description
          Container(
            margin: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: ReadMoreText(
              restaurant.description!,
              trimLines: 5,
              trimMode: TrimMode.Line,
              trimCollapsedText: 'Tampilkan lebih banyak',
              trimExpandedText: 'Tampilkan lebih sedikit',
              textAlign: TextAlign.justify,
              colorClickableText: Theme.of(context).colorScheme.secondary,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(letterSpacing: 0.2),
              moreStyle: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenus({required String label, required List<Category> menu}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 14.0),
            child: Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(fontSize: 18.0, fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(
            height: 64.0,
            child: ListView.builder(
              shrinkWrap: false,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              itemCount: menu.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.all(20.0),
                  margin: const EdgeInsets.only(right: 12.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).shadowColor.withOpacity(0.6),
                        spreadRadius: 1.0,
                        blurRadius: 30.0,
                        offset: const Offset(0, 3.0),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      menu[index].name!,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(letterSpacing: 0.0),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReview(List<CustomerReview> reviews) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 14.0),
            child: Text(
              'Apa kata mereka (${reviews.length})',
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(fontSize: 18.0, fontWeight: FontWeight.w600),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: reviews.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 14.0,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: 64.0,
                            width: 56.0,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryVariant
                                  .withOpacity(0.6),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Icon(
                              Icons.person_outline,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          flex: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                reviews[index].name!,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(fontWeight: FontWeight.w600),
                              ),
                              Text(
                                reviews[index].date!,
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                              const SizedBox(width: 10.0),
                              Text(
                                reviews[index].review!,
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Divider(
                      color: Theme.of(context).colorScheme.primaryVariant,
                      thickness: 0.8,
                    ),
                  ),
                ],
              );
            },
          )
        ],
      ),
    );
  }

  Widget _buildNewDetail({
    required FetchResultState state,
    required DetailProvider provider,
  }) {
    switch (provider.fetchDetailState) {
      case FetchResultState.loading:
        return const Center(
          child: SpinKitFadingCircle(
            color: customBlue,
          ),
        );
      case FetchResultState.noData:
        return Center(
          child: AnimationPlaceholder(
            animation: 'assets/not-found.json',
            text: 'Ops! Sepertinya restoran tidak tersedia',
            hasButton: true,
            buttonText: 'Refresh',
            onButtonTap: () => provider.fetchRestaurantDetail(widget.id),
          ),
        );
      case FetchResultState.hasData:
        final restaurant = provider.restaurant!.item!;
        return ListView(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 32.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: CachedNetworkImage(
                  imageUrl: Urls.largeRestaurantImage(
                    restaurant.pictureId!,
                  ),
                  height: 200.0,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                  progressIndicatorBuilder: (context, url, download) {
                    return Padding(
                      padding: const EdgeInsets.all(50.0),
                      child: FittedBox(
                        child: CircularProgressIndicator(
                          value: download.progress,
                          strokeWidth: 1.5,
                        ),
                      ),
                    );
                  },
                  errorWidget: (context, url, error) {
                    return const Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Icon(Icons.image),
                    );
                  },
                ),
              ),
            ),
            _buildInfo(restaurant),
            _buildMenus(
              label: 'Makanan Terpopuler',
              menu: restaurant.menus!.foods!,
            ),
            _buildMenus(
              label: 'Minuman Terpopuler',
              menu: restaurant.menus!.drinks!,
            ),
            _buildReview(restaurant.customerReviews!),

            /// Button Review
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 14.0,
              ),
              child: ElevatedButton(
                child: Text(
                  'Tulis Review',
                  style: TextStyles.kMediumTitle.copyWith(
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: customBlue,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 14.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onPressed: () => Navigation.intentWithData(
                  ReviewScreen.routeName,
                  arguments: restaurant.id!,
                ),
              ),
            ),
          ],
        );
      case FetchResultState.failure:
        return Center(
          child: AnimationPlaceholder(
            animation: 'assets/no-internet.json',
            text: 'Ops! Sepertinya koneksi internetmu dalam masalah',
            hasButton: true,
            buttonText: 'Refresh',
            onButtonTap: () => provider.fetchRestaurantDetail(widget.id),
          ),
        );
      default:
        return const SizedBox();
    }
  }

  Widget _buildFavoriteButton({
    required FetchResultState state,
    required DetailProvider provider,
  }) {
    if (state == FetchResultState.hasData) {
      final _restaurant = provider.restaurant!.item!;
      return Consumer<DetailProvider>(builder: (context, provider, _) {
        return Consumer<DatabaseProvider>(
          builder: (context, provider, _) {
            return FutureBuilder<bool>(
              future: provider.isFavorite(_restaurant.id!),
              builder: (context, snapshot) {
                var isFavorite = snapshot.data ?? false;
                return IconButton(
                  splashRadius: 24.0,
                  splashColor: Colors.grey[200],
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.favorite),
                  color: isFavorite ? Colors.redAccent : Colors.grey[300],
                  onPressed: () => !isFavorite
                      ? provider.addFavorite(_restaurant)
                      : provider.deleteFavoriteById(_restaurant.id!),
                );
              },
            );
          },
        );
      });
    }
    return IconButton(
      splashRadius: 24.0,
      splashColor: Colors.grey[200],
      padding: EdgeInsets.zero,
      icon: const Icon(Icons.favorite),
      color: Colors.grey[300],
      onPressed: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    _colorTween = ColorTween(
      begin: Theme.of(context).scaffoldBackgroundColor,
      end: Theme.of(context).appBarTheme.backgroundColor,
    ).animate(_colorAnimationController);

    Provider.of<DetailProvider>(
      context,
      listen: false,
    ).fetchRestaurantDetail(widget.id);

    return Consumer<DetailProvider>(
      builder: (context, provider, _) {
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
                      CircleAvatar(
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .primaryVariant
                            .withOpacity(0.6),
                        radius: 24.0,
                        child: IconButton(
                          splashRadius: 4.0,
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.arrow_back),
                          color: Theme.of(context).primaryIconTheme.color,
                          onPressed: () => Navigation.back(),
                        ),
                      ),
                      Text(
                        'Detail',
                        style: Theme.of(context).appBarTheme.toolbarTextStyle,
                      ),
                      _buildFavoriteButton(
                        state: provider.fetchDetailState!,
                        provider: provider,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          body: SafeArea(
            child: NotificationListener<ScrollNotification>(
              onNotification: _scrollListener,
              child: FadeInUp(
                from: 20.0,
                duration: const Duration(milliseconds: 500),
                child: _buildNewDetail(
                  state: provider.fetchDetailState!,
                  provider: provider,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
