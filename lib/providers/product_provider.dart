import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class ProductProvider extends ChangeNotifier {
  final ApiService _api = ApiService();

  List<Product> _products = [];
  bool _isLoading = false;
  bool _hasMore = true;
  String? _error;
  String _selectedCategory = ''; // empty = all
  int _currentPage = 1;
  static const int _pageSize = 10;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;
  String? get error => _error;
  String get selectedCategory => _selectedCategory;

  Future<void> loadProducts({bool refresh = false}) async {
    if (_isLoading) return;
    if (refresh) {
      _currentPage = 1;
      _hasMore = true;
      _products = [];
    }
    if (!_hasMore) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newProducts = await _api.fetchProducts(
        category: _selectedCategory.isEmpty ? null : _selectedCategory,
        limit: _pageSize,
        page: _currentPage,
      );
      if (newProducts.length < _pageSize) {
        _hasMore = false;
      }
      if (refresh) {
        _products = newProducts;
      } else {
        _products = [..._products, ...newProducts];
      }
      _currentPage++;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setCategory(String category) {
    if (_selectedCategory == category) return;
    _selectedCategory = category;
    loadProducts(refresh: true);
  }
}
