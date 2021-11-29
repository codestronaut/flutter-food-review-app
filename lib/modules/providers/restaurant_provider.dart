import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:food_rating_app/data/api/api_service.dart';
import 'package:food_rating_app/data/models/restaurant.dart';

enum FetchResultState { loading, noData, hasData, failure }

class ListProvider extends ChangeNotifier {
  final ApiService apiService;

  /// Restaurant List
  Restaurants? _restaurants;
  Restaurants? get restaurants => _restaurants;

  String _message = '';
  String get message => _message;

  FetchResultState? _fetchListState;
  FetchResultState? get fetchListState => _fetchListState;

  ListProvider({required this.apiService}) {
    fetchRestaurantList();
  }

  void setFetchListState(FetchResultState newState) {
    _fetchListState = newState;
    notifyListeners();
  }

  Future<dynamic> fetchRestaurantList() async {
    try {
      _fetchListState = FetchResultState.loading;

      final restaurantsData = await apiService.getRestaurantList();

      if (restaurantsData.count == 0) {
        _fetchListState = FetchResultState.noData;
        notifyListeners();
        return _message = restaurantsData.message!;
      } else {
        _fetchListState = FetchResultState.hasData;
        notifyListeners();
        return _restaurants = restaurantsData;
      }
    } on TimeoutException catch (e) {
      _fetchListState = FetchResultState.failure;
      notifyListeners();
      return _message = 'TIMEOUT: $e';
    } on SocketException catch (e) {
      _fetchListState = FetchResultState.failure;
      notifyListeners();
      return _message = 'NO CONNECTION: $e';
    } on Error catch (e) {
      _fetchListState = FetchResultState.failure;
      notifyListeners();
      return _message = 'ERROR: $e';
    }
  }
}

class DetailProvider extends ChangeNotifier {
  final ApiService apiService;

  /// Restaurant Detail
  Restaurant? _restaurant;
  Restaurant? get restaurant => _restaurant;

  String _message = '';
  String get message => _message;

  FetchResultState? _fetchDetailState;
  FetchResultState? get fetchDetailState => _fetchDetailState;

  DetailProvider({required this.apiService});

  void setFetchDetailState(FetchResultState newState) {
    _fetchDetailState = newState;
    notifyListeners();
  }

  Future<dynamic> fetchRestaurantDetail(String id) async {
    try {
      _fetchDetailState = FetchResultState.loading;

      final restaurantData = await apiService.getRestaurantDetailById(id);

      if (restaurantData.item == null) {
        _fetchDetailState = FetchResultState.noData;
        notifyListeners();
        return _message = restaurantData.message!;
      } else {
        _fetchDetailState = FetchResultState.hasData;
        notifyListeners();
        return _restaurant = restaurantData;
      }
    } on TimeoutException catch (e) {
      _fetchDetailState = FetchResultState.failure;
      notifyListeners();
      return _message = 'TIMEOUT: $e';
    } on SocketException catch (e) {
      _fetchDetailState = FetchResultState.failure;
      notifyListeners();
      return _message = 'NO CONNECTION: $e';
    } on Error catch (e) {
      _fetchDetailState = FetchResultState.failure;
      notifyListeners();
      return _message = 'ERROR: $e';
    }
  }
}

enum SearchResultState { searching, hasData, noData, failure }

class SearchProvider extends ChangeNotifier {
  final ApiService apiService;

  /// Restaurant List
  Restaurants? _restaurants;
  Restaurants? get restaurants => _restaurants;

  String _message = '';
  String get message => _message;

  SearchResultState? _searchState;
  SearchResultState? get searchState => _searchState;

  SearchProvider({required this.apiService});

  void setSearchState(SearchResultState newState) {
    _searchState = newState;
    notifyListeners();
  }

  Future<dynamic> fetchRestaurantSearchResult({String query = ''}) async {
    try {
      _searchState = SearchResultState.searching;

      final restaurantsData = await apiService.searchRestaurant(query);

      if (restaurantsData.founded! > 0) {
        _searchState = SearchResultState.hasData;
        notifyListeners();
        return _restaurants = restaurantsData;
      } else {
        _searchState = SearchResultState.noData;
        notifyListeners();
        return _message = 'No Data';
      }
    } on TimeoutException catch (e) {
      _searchState = SearchResultState.failure;
      notifyListeners();
      return _message = 'TIMEOUT: $e';
    } on SocketException catch (e) {
      _searchState = SearchResultState.failure;
      notifyListeners();
      return _message = 'NO CONNECTION: $e';
    } on Error catch (e) {
      _searchState = SearchResultState.failure;
      notifyListeners();
      return _message = 'ERROR: $e';
    }
  }
}

enum PostResultState { idle, loading, success, failure }

class ReviewProvider extends ChangeNotifier {
  final ApiService apiService;

  /// Restaurant Review
  CustomerReview? _review;
  CustomerReview? get review => _review;

  String _message = '';
  String get message => _message;

  PostResultState? _postState = PostResultState.idle;
  PostResultState? get postState => _postState;

  ReviewProvider({required this.apiService});

  void setPostState(PostResultState newState) {
    _postState = newState;
    notifyListeners();
  }

  Future<dynamic> postReviewById({
    required String id,
    required String name,
    required String review,
  }) async {
    try {
      _postState = PostResultState.loading;
      notifyListeners();

      final restoReview = await apiService.postReviewById(
        id: id,
        name: name,
        review: review,
      );

      if (restoReview) {
        _postState = PostResultState.success;
        notifyListeners();
        return _message = 'Success';
      }
    } on TimeoutException catch (e) {
      _postState = PostResultState.failure;
      notifyListeners();
      return _message = 'TIMEOUT: $e';
    } on SocketException catch (e) {
      _postState = PostResultState.failure;
      notifyListeners();
      return _message = 'NO CONNECTION: $e';
    } on Error catch (e) {
      _postState = PostResultState.failure;
      notifyListeners();
      return _message = 'ERROR: $e';
    }
  }
}
