import 'package:flutter/material.dart';
import '../models/order.dart';
import '../models/cart_item.dart';

class OrderProvider extends ChangeNotifier {
  final List<Order> _orders = [];

  List<Order> get orders => List.unmodifiable(_orders);

  List<Order> getByStatus(OrderStatus status) =>
      _orders.where((o) => o.status == status).toList();

  void placeOrder({
    required List<CartItem> items,
    required String address,
    required String paymentMethod,
  }) {
    final order = Order(
      id: 'ORD-${DateTime.now().millisecondsSinceEpoch}',
      items: List.from(items),
      address: address,
      paymentMethod: paymentMethod,
      status: OrderStatus.pending,
      createdAt: DateTime.now(),
    );
    _orders.insert(0, order);
    notifyListeners();
  }

  void cancelOrder(String orderId) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index < 0) return;
    final old = _orders[index];
    _orders[index] = Order(
      id: old.id,
      items: old.items,
      address: old.address,
      paymentMethod: old.paymentMethod,
      status: OrderStatus.cancelled,
      createdAt: old.createdAt,
    );
    notifyListeners();
  }
}
