class Restaurants {
  bool? error;
  String? message;
  int? founded;
  int? count;
  List<Item>? items;

  Restaurants({
    this.error,
    this.message,
    this.founded,
    this.count,
    this.items,
  });

  factory Restaurants.fromMap(Map<String, dynamic> map) {
    return Restaurants(
      error: map["error"],
      message: map["message"],
      count: map["count"],
      items: List<Item>.from(
        map["restaurants"].map(
          (x) => Item.fromMapMinimal(x),
        ),
      ),
    );
  }

  factory Restaurants.fromSearchMap(Map<String, dynamic> map) {
    return Restaurants(
      error: map["error"],
      founded: map["founded"],
      count: map["count"],
      items: List<Item>.from(
        map["restaurants"].map(
          (x) => Item.fromMapMinimal(x),
        ),
      ),
    );
  }

  Map<String, dynamic> toMap() => {
        'error': error,
        'message': message,
        'count': count,
        'restaurants': List<dynamic>.from(items!.map((x) => x.toMap())),
      };
}

class Restaurant {
  bool? error;
  String? message;
  Item? item;

  Restaurant({this.error, this.message, this.item});

  factory Restaurant.fromMap(Map<String, dynamic> map) {
    return Restaurant(
      error: map["error"],
      message: map["message"],
      item: Item.fromMapDetail(map["restaurant"]),
    );
  }

  Map<String, dynamic> toMap() => {
        'error': error,
        'message': message,
        'item': item!.toMap(),
      };
}

class Item {
  String? id;
  String? name;
  String? description;
  String? city;
  String? address;
  String? pictureId;
  List<Category>? categories;
  Menus? menus;
  double? rating;
  List<CustomerReview>? customerReviews;

  Item({
    this.id,
    this.name,
    this.description,
    this.city,
    this.address,
    this.pictureId,
    this.categories,
    this.menus,
    this.rating,
    this.customerReviews,
  });

  factory Item.fromMapMinimal(Map<String, dynamic> map) {
    return Item(
      id: map["id"],
      name: map["name"],
      description: map["description"],
      city: map["city"],
      pictureId: map["pictureId"],
      rating: map["rating"].toDouble(),
    );
  }

  factory Item.fromMapDetail(Map<String, dynamic> map) {
    return Item(
      id: map["id"],
      name: map["name"],
      description: map["description"],
      city: map["city"],
      address: map["address"],
      pictureId: map["pictureId"],
      categories: List<Category>.from(
        map["categories"].map(
          (x) => Category.fromMap(x),
        ),
      ),
      menus: Menus.fromMap(map["menus"]),
      rating: map["rating"].toDouble(),
      customerReviews: List<CustomerReview>.from(
        map["customerReviews"].map(
          (x) => CustomerReview.fromMap(x),
        ),
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'city': city,
      'pictureId': pictureId,
      'rating': rating,
    };
  }
}

class Category {
  String? name;

  Category({this.name});

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      name: map['name'],
    );
  }
}

class Menus {
  List<Category>? foods;
  List<Category>? drinks;
  Menus({this.foods, this.drinks});

  factory Menus.fromMap(Map<String, dynamic> map) {
    return Menus(
      foods: List<Category>.from(
        map['foods'].map(
          (x) => Category.fromMap(x),
        ),
      ),
      drinks: List<Category>.from(
        map['drinks'].map(
          (x) => Category.fromMap(x),
        ),
      ),
    );
  }
}

class CustomerReview {
  String? id;
  String? name;
  String? review;
  String? date;
  CustomerReview({this.id, this.name, this.review, this.date});

  factory CustomerReview.fromMap(Map<String, dynamic> map) {
    return CustomerReview(
      name: map['name'],
      review: map['review'],
      date: map['date'],
    );
  }
}
