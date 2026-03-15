import 'package:intl/intl.dart';

class Formatters {
  static final _vndFormat = NumberFormat.currency(
    locale: 'vi_VN',
    symbol: 'đ',
    decimalDigits: 0,
  );
  static final _usdFormat = NumberFormat.currency(
    symbol: '\$',
    decimalDigits: 2,
  );

  /// Convert FakeStore API prices to VND for display in the app.
  static String currency(double price) {
    return _vndFormat.format(price * 25000);
  }

  /// Alias kept for compatibility with existing code paths.
  static String vnd(double price) {
    return _vndFormat.format(price * 25000);
  }

  static String usd(double price) {
    return _usdFormat.format(price);
  }

  static String shortNumber(int n) {
    if (n >= 1000) {
      final shortValue = (n / 1000)
          .toStringAsFixed(n >= 10000 ? 0 : 1)
          .replaceAll('.0', '');
      return '${shortValue}k';
    }
    return '$n';
  }
}
