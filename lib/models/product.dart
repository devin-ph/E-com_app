class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final double rating;
  final int ratingCount;

  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
    required this.ratingCount,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      category: json['category'] as String,
      image: json['image'] as String,
      rating: (json['rating']['rate'] as num).toDouble(),
      ratingCount: json['rating']['count'] as int,
    );
  }

  // Fake sold count based on rating count for display purposes
  String get soldDisplay {
    if (ratingCount >= 1000) {
      return 'Đã bán ${(ratingCount / 1000).toStringAsFixed(1)}k';
    }
    return 'Đã bán $ratingCount';
  }

  // Fake original price (10-30% higher)
  double get originalPrice => price * 1.2;

  // Fake discount tag
  String get discountTag => '-${((1 - price / originalPrice) * 100).toStringAsFixed(0)}%';

  // Extra images (same image but faking multiple angles for demo)
  List<String> get images => [image, image, image];
}
