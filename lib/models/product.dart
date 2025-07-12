import 'dart:convert';

class Product {
  final int id;
  final String title;
  final String image;
  final double price;
  final double rating;

  Product({
    required this.id,
    required this.title,
    required this.image,
    required this.price,
    required this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'] as int,
        title: json['title'] as String,
        image: json['image'] as String,
        price: (json['price'] as num).toDouble(),
        rating: (json['rating']?['rate'] as num?)?.toDouble() ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'image': image,
        'price': price,
        'rating': rating,
      };

  /// Convenient JSON‐string form of this product
  String toJsonString() => jsonEncode(toJson());

  @override
  String toString() =>
      'Product(id: $id, title: $title, price: $price, rating: $rating)';
}
