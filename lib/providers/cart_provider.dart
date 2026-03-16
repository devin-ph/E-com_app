import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class CartProvider extends ChangeNotifier {
  final ApiService _api = ApiService();
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get itemCount => _items.length;

  // Only checked items
  List<CartItem> get checkedItems =>
      _items.where((item) => item.isChecked).toList();

  double get totalPrice =>
      checkedItems.fold(0, (sum, item) => sum + item.subtotal);

  bool get allChecked =>
      _items.isNotEmpty && _items.every((item) => item.isChecked);

  CartProvider() {
    _loadFromStorage();
  }

  void addItem({
    required Product product,
    required String size,
    required String color,
    int quantity = 1,
  }) {
    final key = '${product.id}_${size}_$color';
    final index = _items.indexWhere((item) => item.key == key);
    if (index >= 0) {
      _items[index].quantity += quantity;
    } else {
      _items.add(CartItem(
        product: product,
        size: size,
        color: color,
        quantity: quantity,
      ));
    }
    _saveToStorage();
    notifyListeners();
  }

  void removeItem(String key) {
    _items.removeWhere((item) => item.key == key);
    _saveToStorage();
    notifyListeners();
  }

  void updateQuantity(String key, int delta) {
    final index = _items.indexWhere((item) => item.key == key);
    if (index < 0) return;
    final newQty = _items[index].quantity + delta;
    if (newQty <= 0) {
      // Caller should confirm before calling this; just remove
      _items.removeAt(index);
    } else {
      _items[index].quantity = newQty;
    }
    _saveToStorage();
    notifyListeners();
  }

  void toggleItem(String key, bool value) {
    final index = _items.indexWhere((item) => item.key == key);
    if (index < 0) return;
    _items[index].isChecked = value;
    _saveToStorage();
    notifyListeners();
  }

  void toggleSelectAll(bool value) {
    for (final item in _items) {
      item.isChecked = value;
    }
    _saveToStorage();
    notifyListeners();
  }

  /// Remove all checked items (after successful checkout)
  void removeCheckedItems() {
    _items.removeWhere((item) => item.isChecked);
    _saveToStorage();
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    _saveToStorage();
    notifyListeners();
  }

  // ---------- Persistence ----------
  Future<void> _saveToStorage() async {
    await StorageService.saveCartKeys(
      _items
          .map((e) => {
                'product': e.product.toJson(),
                'size': e.size,
                'color': e.color,
                'quantity': e.quantity,
                'is_checked': e.isChecked,
              })
          .toList(),
    );
  }

  Future<void> _loadFromStorage() async {
    final stored = await StorageService.loadCartKeys();
    if (stored.isEmpty) return;

    final restored = <CartItem>[];
    for (final raw in stored) {
      try {
        final Product product;
        final productData = raw['product'];
        if (productData is Map) {
          product = Product.fromJson(Map<String, dynamic>.from(productData));
        } else {
          // legacy: only product_id saved — fetch from API as fallback
          final id = (raw['product_id'] as num?)?.toInt();
          if (id == null) continue;
          product = await _api.fetchProductById(id);
        }
        restored.add(CartItem(
          product: product,
          size: (raw['size'] as String?) ?? '',
          color: (raw['color'] as String?) ?? '',
          quantity: (raw['quantity'] as num?)?.toInt() ?? 1,
          isChecked: raw['is_checked'] as bool? ?? true,
        ));
      } catch (_) {
        // skip corrupted entries
        continue;
      }
    }

    if (restored.isEmpty) return;
    _items
      ..clear()
      ..addAll(restored);
    notifyListeners();
  }

  /// Call once at app start (awaited in main) so cart is ready before first frame.
  Future<void> restoreCart() => _loadFromStorage();
}
