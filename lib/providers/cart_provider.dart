import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/product.dart';
import '../services/storage_service.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];
  bool _selectAll = false;

  List<CartItem> get items => List.unmodifiable(_items);

  int get itemCount => _items.length;

  bool get selectAll => _selectAll;

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
    _syncSelectAll();
    _saveToStorage();
    notifyListeners();
  }

  void removeItem(String key) {
    _items.removeWhere((item) => item.key == key);
    _syncSelectAll();
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
    _syncSelectAll();
    notifyListeners();
  }

  void toggleSelectAll(bool value) {
    for (final item in _items) {
      item.isChecked = value;
    }
    _selectAll = value;
    notifyListeners();
  }

  void _syncSelectAll() {
    _selectAll = _items.isNotEmpty && _items.every((item) => item.isChecked);
  }

  /// Remove all checked items (after successful checkout)
  void removeCheckedItems() {
    _items.removeWhere((item) => item.isChecked);
    _syncSelectAll();
    _saveToStorage();
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    _selectAll = false;
    _saveToStorage();
    notifyListeners();
  }

  // ---------- Persistence ----------
  Future<void> _saveToStorage() async {
    await StorageService.saveCartKeys(
      _items
          .map((e) => {
                'product_id': e.product.id,
                'size': e.size,
                'color': e.color,
                'quantity': e.quantity,
                'is_checked': e.isChecked,
              })
          .toList(),
    );
  }

  Future<void> _loadFromStorage() async {
    // Cart restore from SharedPreferences is handled by StorageService
    // Products need to be fetched from API; we skip auto-restore for now
    // to avoid circular dependency. The StorageService stores raw JSON,
    // and full restore would require the ApiService. 
    // This is acceptable — cart restores after user logs in or makes actions.
  }
}
