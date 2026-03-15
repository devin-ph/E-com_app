import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _cartKey = 'cart_items';

  static Future<void> saveCartKeys(List<Map<String, dynamic>> items) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cartKey, json.encode(items));
  }

  static Future<List<Map<String, dynamic>>> loadCartKeys() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_cartKey);
    if (raw == null) return [];
    final decoded = json.decode(raw) as List<dynamic>;
    return decoded.cast<Map<String, dynamic>>();
  }

  static Future<void> clearCart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cartKey);
  }
}
