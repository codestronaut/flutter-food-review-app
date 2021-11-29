import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_rating_app/common/navigation.dart';
import 'package:food_rating_app/data/api/urls.dart';
import 'package:food_rating_app/data/models/restaurant.dart';
import 'package:food_rating_app/modules/screens/restaurant/detail_screen.dart';

class RestaurantCard extends StatelessWidget {
  final Item item;
  const RestaurantCard({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigation.intentWithData(
        DetailScreen.routeName,
        arguments: item.id!,
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 22.0,
          vertical: 12.0,
        ),
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
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 22.0,
                vertical: 16.0,
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: FittedBox(
                        child: CachedNetworkImage(
                          imageUrl: Urls.restaurantImage(item.pictureId!),
                          height: 80.0,
                          width: 80.0,
                          fit: BoxFit.cover,
                          progressIndicatorBuilder: (context, url, download) {
                            return Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: CircularProgressIndicator(
                                value: download.progress,
                                strokeWidth: 1.5,
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
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Text(
                            item.name!,
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                        Text(
                          item.description!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: Theme.of(context).colorScheme.primaryVariant,
              thickness: 0.8,
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 22.0,
                vertical: 16.0,
              ),
              child: Row(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondaryVariant,
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
                        '${item.rating}',
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
                          color: Theme.of(context).colorScheme.secondary,
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
                        item.city!,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
