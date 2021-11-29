import 'package:flutter_test/flutter_test.dart';
import 'package:food_rating_app/data/api/api_service.dart';
import 'package:food_rating_app/data/models/restaurant.dart';
import 'package:food_rating_app/modules/providers/restaurant_provider.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'restaurant_provider_test.mocks.dart';

@GenerateMocks([ApiService])
void main() {
  final MockApiService mockApiService = MockApiService();

  group('Verify JSON Parsing: Restaurant Provider', () {
    /// Testing ListProvider - Part of restaurant_provider
    test('list restaurants fetched successfully', () async {
      var restaurantsJson = {
        "error": false,
        "message": "success",
        "count": 20,
        "restaurants": [
          {
            "id": "rqdv5juczeskfw1e867",
            "name": "Melting Pot",
            "description":
                "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. ...",
            "pictureId": "14",
            "city": "Medan",
            "rating": 4.2
          },
          {
            "id": "s1knt6za9kkfw1e867",
            "name": "Kafe Kita",
            "description":
                "Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. ...",
            "pictureId": "25",
            "city": "Gorontalo",
            "rating": 4
          }
        ]
      };

      /// stub
      when(mockApiService.getRestaurantList()).thenAnswer(
          (_) async => Future.value(Restaurants.fromMap(restaurantsJson)));

      /// arrange
      ListProvider listProvider = ListProvider(apiService: mockApiService);
      await listProvider.fetchRestaurantList();

      /// act
      var testFromApiResultId = listProvider.restaurants!.items![0].id ==
          Restaurants.fromMap(restaurantsJson).items![0].id;
      var testFromApiResultName = listProvider.restaurants!.items![0].name ==
          Restaurants.fromMap(restaurantsJson).items![0].name;

      /// assert
      expect(testFromApiResultId, true);
      expect(testFromApiResultName, true);
    });

    /// Testing DetailProvider - Part of restaurant_provider
    test('detail restaurant fetched successfully', () async {
      var restaurantDetailJson = {
        "error": false,
        "message": "success",
        "restaurant": {
          "id": "rqdv5juczeskfw1e867",
          "name": "Melting Pot",
          "description":
              "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. ...",
          "city": "Medan",
          "address": "Jln. Pandeglang no 19",
          "pictureId": "14",
          "categories": [
            {"name": "Italia"},
            {"name": "Modern"}
          ],
          "menus": {
            "foods": [
              {"name": "Paket rosemary"},
              {"name": "Toastie salmon"}
            ],
            "drinks": [
              {"name": "Es krim"},
              {"name": "Sirup"}
            ]
          },
          "rating": 4.2,
          "customerReviews": [
            {
              "name": "Ahmad",
              "review": "Tidak rekomendasi untuk pelajar!",
              "date": "13 November 2019"
            }
          ]
        }
      };

      /// stub
      when(mockApiService.getRestaurantDetailById('rqdv5juczeskfw1e867'))
          .thenAnswer(
              (_) => Future.value(Restaurant.fromMap(restaurantDetailJson)));

      /// arrange
      DetailProvider detailProvider =
          DetailProvider(apiService: mockApiService);
      await detailProvider.fetchRestaurantDetail('rqdv5juczeskfw1e867');

      /// act
      var testFromApiResultId = detailProvider.restaurant!.item!.id ==
          Restaurant.fromMap(restaurantDetailJson).item!.id;
      var testFromApiResultName = detailProvider.restaurant!.item!.name ==
          Restaurant.fromMap(restaurantDetailJson).item!.name;

      /// assert
      expect(testFromApiResultId, true);
      expect(testFromApiResultName, true);
    });
  });
}
