import 'package:intl/intl.dart';

class Formatters {
  static final _usdFormat = NumberFormat.currency(symbol: '\$');
  static final _vndFormat = NumberFormat.currency(
    locale: 'vi_VN',
    symbol: 'đ',
    decimalDigits: 0,
  );

  /// Format a USD price from FakeStore API to display nicely
  static String currency(double price) {
    return _usdFormat.format(price);
  }

  /// Format as VND equivalent for demo purposes
  static String vnd(double price) {
    return _vndFormat.format(price * 25000);
  }

  static String shortNumber(int n) {
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
    return '$n';
  }
}
