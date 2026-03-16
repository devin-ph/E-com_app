import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class ProductProvider extends ChangeNotifier {
  final ApiService _api = ApiService();
  static const Set<String> _apiCategories = {...kDummyJsonCategorySlugs};

  List<Product> _products = [];
  bool _isLoading = false;
  bool _hasMore = true;
  String? _error;
  String _selectedCategory = ''; // empty = all
  String _searchQuery = '';
  int _currentPage = 1;
  static const int _pageSize = 10;

  List<Product> get products => _products;
  List<Product> get visibleProducts {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) {
      return _products;
    }
    return _products
        .where((product) => product.title.toLowerCase().contains(query))
        .toList();
  }

  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;
  String? get error => _error;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  Future<void> loadProducts({bool refresh = false}) async {
    if (_isLoading) return;
    final selected = _selectedCategory;

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
      final apiCategory = _apiCategories.contains(selected) ? selected : null;
      final fetchedProducts = await _api.fetchProducts(
        category: apiCategory,
        limit: _pageSize,
        page: _currentPage,
      );

      if (fetchedProducts.length < _pageSize) {
        _hasMore = false;
      }

      if (_currentPage == 1) {
        _products = fetchedProducts;
      } else {
        _products = [..._products, ...fetchedProducts];
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

  void setSearchQuery(String query) {
    if (_searchQuery == query) return;
    _searchQuery = query;
    notifyListeners();
  }
}
