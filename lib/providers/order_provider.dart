import 'package:flutter/material.dart';
import '../models/order.dart';
import '../models/cart_item.dart';
import '../services/storage_service.dart';

class OrderProvider extends ChangeNotifier {
  final List<Order> _orders = [];

  List<Order> get orders => List.unmodifiable(_orders);

  List<Order> getByStatus(OrderStatus status) =>
      _orders.where((o) => o.status == status).toList();

  Future<void> restoreOrders() async {
    final stored = await StorageService.loadOrders();
    if (stored.isEmpty) return;
    final restored = stored
        .map((raw) {
          try {
            return Order.fromJson(raw);
          } catch (_) {
            return null;
          }
        })
        .whereType<Order>()
        .toList();
    if (restored.isEmpty) return;
    _orders
      ..clear()
      ..addAll(restored);
    notifyListeners();
  }

  Future<void> _saveToStorage() =>
      StorageService.saveOrders(_orders.map((o) => o.toJson()).toList());

  void placeOrder({
    required List<CartItem> items,
    required String address,
    required String paymentMethod,
  }) {
    final snapshotItems =
        items.map((item) => item.copyWith()).toList(growable: false);

    final order = Order(
      id: 'ORD-${DateTime.now().millisecondsSinceEpoch}',
      items: snapshotItems,
      address: address,
      paymentMethod: paymentMethod,
      status: OrderStatus.pending,
      createdAt: DateTime.now(),
    );
    _orders.insert(0, order);
    notifyListeners();
    _saveToStorage();
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
    _saveToStorage();
  }
}
