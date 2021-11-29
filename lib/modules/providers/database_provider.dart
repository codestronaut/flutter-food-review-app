import 'package:flutter/material.dart';
import 'package:food_rating_app/data/database/database_helper.dart';
import 'package:food_rating_app/data/models/restaurant.dart';

enum DatabaseResultState { loading, noData, hasData, error }

class DatabaseProvider extends ChangeNotifier {
  final DatabaseHelper databaseHelper;

  List<Item> _favorites = [];
  List<Item> get favorites => _favorites;

  String _message = '';
  String get message => _message;

  DatabaseResultState? _databaseResultState;
  DatabaseResultState? get databaseResultState => _databaseResultState;

  DatabaseProvider({required this.databaseHelper}) {
    _getFavorites();
  }

  void _getFavorites() async {
    _favorites = await databaseHelper.getFavorites();

    if (_favorites.isNotEmpty) {
      _databaseResultState = DatabaseResultState.hasData;
    } else {
      _databaseResultState = DatabaseResultState.noData;
      _message = 'Database is empty';
    }

    notifyListeners();
  }

  Future<void> addFavorite(Item restaurant) async {
    try {
      await databaseHelper.insertFavorite(restaurant);
      _getFavorites();
    } catch (e) {
      _databaseResultState = DatabaseResultState.error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }

  Future<bool> isFavorite(String id) async {
    final favorite = await databaseHelper.getFavoriteById(id);
    return favorite.isNotEmpty;
  }

  void deleteFavoriteById(String id) async {
    try {
      await databaseHelper.deleteFavorite(id);
      _getFavorites();
    } catch (e) {
      _databaseResultState = DatabaseResultState.error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }

  void deleteAllFavorite() async {
    try {
      await databaseHelper.deleteAllFavorite();
      _getFavorites();
    } catch (e) {
      _databaseResultState = DatabaseResultState.error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }
}
