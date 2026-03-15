import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  static const String _baseUrl = 'https://fakestoreapi.com';

  Future<List<Product>> fetchProducts({
    String? category,
    int limit = 10,
    int page = 1,
  }) async {
    // FakeStore API uses limit but no page param directly.
    // We use limit= total items and slice locally for pagination.
    final endIndex = page * limit;
    final fetchLimit = endIndex;

    String url = '$_baseUrl/products?limit=$fetchLimit';
    if (category != null && category.isNotEmpty) {
      url = '$_baseUrl/products/category/${Uri.encodeComponent(category)}?limit=$fetchLimit';
    }

    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception('Failed to load products: ${response.statusCode}');
    }

    final List<dynamic> data = json.decode(response.body) as List<dynamic>;
    final startIndex = (page - 1) * limit;
    if (startIndex >= data.length) return [];
    final slice = data.sublist(
      startIndex,
      endIndex > data.length ? data.length : endIndex,
    );
    return slice
        .map((json) => Product.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<Product> fetchProductById(int id) async {
    final response = await http.get(Uri.parse('$_baseUrl/products/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to load product $id');
    }
    return Product.fromJson(
        json.decode(response.body) as Map<String, dynamic>);
  }

  Future<List<String>> fetchCategories() async {
    final response =
        await http.get(Uri.parse('$_baseUrl/products/categories'));
    if (response.statusCode != 200) {
      throw Exception('Failed to load categories');
    }
    return List<String>.from(json.decode(response.body) as List<dynamic>);
  }
}
