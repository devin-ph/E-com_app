import 'package:intl/intl.dart';

class Formatters {
  static final _vndFormat = NumberFormat.currency(
    locale: 'vi_VN',
    symbol: 'đ',
    decimalDigits: 0,
  );

  /// Convert FakeStore API prices to VND for display in the app.
  static String currency(double price) {
    return _vndFormat.format(price * 25000);
  }

  /// Alias kept for compatibility with existing code paths.
  static String vnd(double price) {
    return _vndFormat.format(price * 25000);
  }

  static String shortNumber(int n) {
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
    return '$n';
  }
}
