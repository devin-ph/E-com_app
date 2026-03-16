import 'cart_item.dart';

enum OrderStatus { pending, delivering, delivered, cancelled }

extension OrderStatusLabel on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.pending:
        return 'Chờ xác nhận';
      case OrderStatus.delivering:
        return 'Đang giao';
      case OrderStatus.delivered:
        return 'Đã giao';
      case OrderStatus.cancelled:
        return 'Đã hủy';
    }
  }
}

class Order {
  final String id;
  final List<CartItem> items;
  final String address;
  final String paymentMethod;
  final OrderStatus status;
  final DateTime createdAt;

  const Order({
    required this.id,
    required this.items,
    required this.address,
    required this.paymentMethod,
    this.status = OrderStatus.pending,
    required this.createdAt,
  });

  double get totalAmount =>
      items.fold(0, (sum, item) => sum + item.subtotal);

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  Map<String, dynamic> toJson() => {
        'id': id,
        'items': items.map((e) => e.toJson()).toList(),
        'address': address,
        'paymentMethod': paymentMethod,
        'status': status.index,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String,
      items: (json['items'] as List)
          .map((e) => CartItem.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      address: json['address'] as String,
      paymentMethod: json['paymentMethod'] as String,
      status: OrderStatus.values[(json['status'] as num?)?.toInt() ?? 0],
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
