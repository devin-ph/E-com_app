class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final double rating;
  final int ratingCount;
  final int discountPercent;

  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
    required this.ratingCount,
    required this.discountPercent,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final rawDiscount = (json['discountPercentage'] as num?)?.round() ?? 10;
    final discountPercent = rawDiscount.clamp(10, 35);

    return Product(
      id: json['id'] as int,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      category: json['category'] as String,
      image:
          (json['thumbnail'] ?? (json['images'] as List<dynamic>).first)
              as String,
      rating: (json['rating'] as num).toDouble(),
      ratingCount: (json['stock'] as num?)?.toInt() ?? 0,
      discountPercent: discountPercent,
    );
  }

  // Fake sold count based on rating count for display purposes
  String get soldDisplay {
    if (ratingCount >= 1000) {
      final shortValue = (ratingCount / 1000)
          .toStringAsFixed(ratingCount >= 10000 ? 0 : 1)
          .replaceAll('.0', '');
      return 'Đã bán ${shortValue}k';
    }
    return 'Đã bán $ratingCount';
  }

  double get originalPrice => price / (1 - (discountPercent / 100));

  String get discountTag => '-$discountPercent%';

  List<String> get images => [image, image, image];

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'price': price,
        'description': description,
        'category': category,
        'thumbnail': image,
        'rating': rating,
        'stock': ratingCount,
        'discountPercentage': discountPercent,
      };
}
