import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:food_rating_app/common/navigation.dart';
import 'package:food_rating_app/data/api/urls.dart';
import 'package:food_rating_app/modules/providers/restaurant_provider.dart';
import 'package:food_rating_app/modules/screens/restaurant/detail_screen.dart';
import 'package:food_rating_app/modules/screens/restaurant/widgets/animation_placeholder.dart';
import 'package:food_rating_app/modules/screens/restaurant/widgets/restaurant_card.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/search';
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
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
                  children: [
                    Expanded(
                      flex: 1,
                      child: CircleAvatar(
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
                          onPressed: () {
                            Provider.of<SearchProvider>(
                              context,
                              listen: false,
                            ).setSearchState(SearchResultState.searching);
                            Navigation.back();
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      flex: 6,
                      child: TextField(
                        controller: _searchController,
                        textAlignVertical: TextAlignVertical.center,
                        showCursor: true,
                        cursorColor: Theme.of(context).iconTheme.color,
                        decoration: InputDecoration(
                          hintText: 'Kafe Cemara',
                          isCollapsed: true,
                          filled: true,
                          fillColor: Theme.of(context)
                              .colorScheme
                              .primaryVariant
                              .withOpacity(0.8),
                          contentPadding: const EdgeInsets.all(10.0),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey[500]!,
                          ),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? GestureDetector(
                                  onTap: () {
                                    _searchController.clear();
                                    Provider.of<SearchProvider>(
                                      context,
                                      listen: false,
                                    ).fetchRestaurantSearchResult(query: '');
                                  },
                                  child: const Icon(Icons.close),
                                )
                              : null,
                        ),
                        onChanged: (query) {
                          if (query.isNotEmpty) {
                            Provider.of<SearchProvider>(
                              context,
                              listen: false,
                            ).fetchRestaurantSearchResult(query: query);
                          } else {
                            Provider.of<SearchProvider>(
                              context,
                              listen: false,
                            ).setSearchState(SearchResultState.searching);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: _scrollListener,
        child: SafeArea(
          child: Consumer<SearchProvider>(
            builder: (context, provider, _) {
              switch (provider.searchState) {
                case SearchResultState.searching:
                  return const AnimationPlaceholder(
                    animation: 'assets/loading.json',
                    text: 'Cari restoran',
                  );
                case SearchResultState.hasData:
                  return FadeInUp(
                    from: 20.0,
                    duration: const Duration(milliseconds: 500),
                    child: ListView.builder(
                      itemCount: provider.restaurants!.items!.length,
                      itemBuilder: (context, index) {
                        return RestaurantCard(
                          item: provider.restaurants!.items![index],
                        );
                      },
                    ),
                  );
                case SearchResultState.noData:
                  return const AnimationPlaceholder(
                    animation: 'assets/not-found.json',
                    text: 'Ops! Sepertinya restoran tidak tersedia',
                  );
                case SearchResultState.failure:
                  return AnimationPlaceholder(
                    animation: 'assets/no-internet.json',
                    text: 'Ops! Sepertinya koneksi internetmu dalam masalah',
                    hasButton: true,
                    buttonText: 'Refresh',
                    onButtonTap: () => provider.fetchRestaurantSearchResult(),
                  );
                default:
                  return const SizedBox();
              }
            },
          ),
        ),
      ),
    );
  }
}
