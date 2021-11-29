class Urls {
  static const String baseUrl = 'https://restaurant-api.dicoding.dev';
  static const String restaurantList = '/list';
  static String restaurantDetail(String id) => '/detail/$id';
  static const String searchRestaurant = '/search';
  static const String restraurantReview = '/review';
  static String restaurantImage(String pictureId) =>
      'https://restaurant-api.dicoding.dev/images/small/$pictureId';
  static String largeRestaurantImage(String pictureId) =>
      'https://restaurant-api.dicoding.dev/images/large/$pictureId';
}
