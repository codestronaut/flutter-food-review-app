import 'package:dio/dio.dart';
import 'package:food_rating_app/data/models/restaurant.dart';
import 'package:food_rating_app/data/api/urls.dart';

class ApiService {
  final Dio _client = Dio(
    BaseOptions(
      baseUrl: Urls.baseUrl,
      connectTimeout: 5000,
      receiveTimeout: 3000,
      contentType: Headers.formUrlEncodedContentType,
    ),
  );

  Future<Restaurants> getRestaurantList() async {
    final response = await _client.get(Urls.restaurantList);

    if (response.statusCode == 200) {
      return Restaurants.fromMap(response.data);
    } else {
      throw Exception('Failed to load restaurant list!');
    }
  }

  Future<Restaurants> searchRestaurant(String query) async {
    final response = await _client.get(
      Urls.searchRestaurant,
      queryParameters: {'q': query},
    );

    if (response.statusCode == 200) {
      return Restaurants.fromSearchMap(response.data);
    } else {
      throw Exception('Failed to load search result!');
    }
  }

  Future<Restaurant> getRestaurantDetailById(String id) async {
    final response = await _client.get(Urls.restaurantDetail(id));

    if (response.statusCode == 200) {
      return Restaurant.fromMap(response.data);
    } else {
      throw Exception('Failed to load restaurant detail!');
    }
  }

  Future<bool> postReviewById({
    required String id,
    required String name,
    required String review,
  }) async {
    _client.interceptors.add(LogInterceptor(requestBody: true));
    final request = await _client.post(
      Urls.restraurantReview,
      data: {'id': id, 'name': name, 'review': review},
    );

    if (request.statusCode == 201) {
      return true;
    } else {
      throw Exception('Failed to post review!');
    }
  }
}
