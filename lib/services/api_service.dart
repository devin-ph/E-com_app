import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  static const String _baseUrl = 'https://dummyjson.com';

  Future<List<Product>> fetchProducts({
    String? category,
    int limit = 10,
    int page = 1,
  }) async {
    final skip = (page - 1) * limit;

    String url = '$_baseUrl/products?limit=$limit&skip=$skip';
    if (category != null && category.isNotEmpty) {
      url =
          '$_baseUrl/products/category/${Uri.encodeComponent(category)}?limit=$limit&skip=$skip';
    }

    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception('Failed to load products: ${response.statusCode}');
    }

    final Map<String, dynamic> body =
        json.decode(response.body) as Map<String, dynamic>;
    final List<dynamic> data = body['products'] as List<dynamic>;

    return data
        .map((json) => Product.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<Product> fetchProductById(int id) async {
    final response = await http.get(Uri.parse('$_baseUrl/products/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to load product $id');
    }
    return Product.fromJson(json.decode(response.body) as Map<String, dynamic>);
  }

  Future<List<String>> fetchCategories() async {
    final response = await http.get(Uri.parse('$_baseUrl/products/categories'));
    if (response.statusCode != 200) {
      throw Exception('Failed to load categories');
    }
    final List<dynamic> rawCategories =
        json.decode(response.body) as List<dynamic>;
    return rawCategories
        .map((item) => (item as Map<String, dynamic>)['slug'] as String)
        .toList();
  }
}
