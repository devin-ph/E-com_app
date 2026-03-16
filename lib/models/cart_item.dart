import 'product.dart';

class CartItem {
  final Product product;
  final String size;
  final String color;
  int quantity;
  bool isChecked;

  CartItem({
    required this.product,
    required this.size,
    required this.color,
    this.quantity = 1,
    this.isChecked = true,
  });

  double get subtotal => product.price * quantity;

  CartItem copyWith({
    String? size,
    String? color,
    int? quantity,
    bool? isChecked,
  }) {
    return CartItem(
      product: product,
      size: size ?? this.size,
      color: color ?? this.color,
      quantity: quantity ?? this.quantity,
      isChecked: isChecked ?? this.isChecked,
    );
  }

  // Unique key per variation
  String get key => '${product.id}_${size}_$color';

  Map<String, dynamic> toJson() => {
        'product': product.toJson(),
        'size': size,
        'color': color,
        'quantity': quantity,
        'is_checked': isChecked,
      };

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(
          Map<String, dynamic>.from(json['product'] as Map)),
      size: (json['size'] as String?) ?? '',
      color: (json['color'] as String?) ?? '',
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      isChecked: json['is_checked'] as bool? ?? true,
    );
  }
}
