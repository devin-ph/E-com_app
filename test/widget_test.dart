import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:e_com_app/models/product.dart';
import 'package:e_com_app/providers/cart_provider.dart';
import 'package:e_com_app/providers/product_provider.dart';
import 'package:e_com_app/screens/home/home_screen.dart';

void main() {
  testWidgets('Home screen renders key shopping sections', (
    WidgetTester tester,
  ) async {
    final productProvider = _TestProductProvider();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<CartProvider>(create: (_) => CartProvider()),
          ChangeNotifierProvider<ProductProvider>.value(value: productProvider),
        ],
        child: const MaterialApp(home: HomeScreen()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('TH4 - Nhóm G3-C3'), findsOneWidget);
    expect(find.text('Danh mục sản phẩm'), findsOneWidget);
    expect(find.textContaining('Tìm kiếm sản phẩm'), findsOneWidget);
    expect(find.byIcon(Icons.shopping_cart_outlined), findsOneWidget);

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -600));
    await tester.pump();

    expect(find.text('Gợi ý hôm nay'), findsOneWidget);
  });
}

class _TestProductProvider extends ProductProvider {
  final List<Product> _items = const [
    Product(
      id: 1,
      title: 'Oversized Basic T Shirt',
      price: 15.0,
      description: 'Test product',
      category: "men's clothing",
      image: 'https://example.com/product-1.png',
      rating: 4.8,
      ratingCount: 1200,
      discountPercent: 18,
    ),
    Product(
      id: 2,
      title: 'Noise Cancelling Bluetooth Headphones',
      price: 32.5,
      description: 'Test product',
      category: 'electronics',
      image: 'https://example.com/product-2.png',
      rating: 4.6,
      ratingCount: 850,
      discountPercent: 27,
    ),
  ];

  String _selectedCategory = '';

  @override
  List<Product> get products => _items;

  @override
  bool get isLoading => false;

  @override
  bool get hasMore => false;

  @override
  String? get error => null;

  @override
  String get selectedCategory => _selectedCategory;

  @override
  Future<void> loadProducts({bool refresh = false}) async {}

  @override
  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }
}
