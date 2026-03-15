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
}
