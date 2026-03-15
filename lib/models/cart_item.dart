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
        'product_id': product.id,
        'size': size,
        'color': color,
        'quantity': quantity,
        'is_checked': isChecked,
      };
}
