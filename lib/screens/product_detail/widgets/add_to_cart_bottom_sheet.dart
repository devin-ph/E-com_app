import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/product.dart';
import '../../../providers/cart_provider.dart';
import '../../../utils/formatters.dart';

const List<String> _sizes = ['S', 'M', 'L', 'XL', 'XXL'];
const List<String> _electronicsSizes = ['128Gb', '256Gb', '512Gb', '1Tb'];
const List<String> _jewelrySizes = [
  'Size 13',
  'Size 14',
  'Size 15',
  'Size 16',
  'Size 17',
  'Size 18',
  'Size 19',
  'Size 20',
];
const List<Map<String, dynamic>> _colors = [
  {'label': 'Đen', 'value': 'black', 'color': Colors.black},
  {'label': 'Trắng', 'value': 'white', 'color': Colors.white},
  {'label': 'Đỏ', 'value': 'red', 'color': Colors.red},
  {'label': 'Xanh', 'value': 'blue', 'color': Colors.blue},
  {'label': 'Vàng', 'value': 'yellow', 'color': Colors.amber},
];
const List<Map<String, dynamic>> _jewelryColors = [
  {'label': 'Bạc', 'value': 'silver', 'color': Color(0xFFC0C0C0)},
  {'label': 'Vàng', 'value': 'gold', 'color': Color(0xFFFFC107)},
];

class AddToCartBottomSheet extends StatefulWidget {
  final Product product;
  final bool buyNow;

  const AddToCartBottomSheet({
    super.key,
    required this.product,
    this.buyNow = false,
  });

  static Future<void> show(
    BuildContext context,
    Product product, {
    bool buyNow = false,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddToCartBottomSheet(product: product, buyNow: buyNow),
    );
  }

  @override
  State<AddToCartBottomSheet> createState() => _AddToCartBottomSheetState();
}

class _AddToCartBottomSheetState extends State<AddToCartBottomSheet> {
  late String _selectedSize;
  late String _selectedColor;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _selectedSize = _availableSizes.first;
    _selectedColor = (_availableColors.first['value'] as String);
  }

  bool get _isJewelryProduct {
    return widget.product.category.toLowerCase().trim() == 'jewelery';
  }

  bool get _isElectronicsProduct {
    return widget.product.category.toLowerCase().trim() == 'electronics';
  }

  List<String> get _availableSizes {
    if (_isJewelryProduct) return _jewelrySizes;
    if (_isElectronicsProduct) return _electronicsSizes;
    return _sizes;
  }

  List<Map<String, dynamic>> get _availableColors {
    return _isJewelryProduct ? _jewelryColors : _colors;
  }

  bool get _showsColorSelector => !_isElectronicsProduct;

  double get _selectedPrice {
    if (!_isElectronicsProduct) return widget.product.price;
    final index = _electronicsSizes.indexOf(_selectedSize);
    final adjustedIndex = index < 0 ? 0 : index;
    return widget.product.price + (adjustedIndex * 20);
  }

  Product get _selectedVariantProduct {
    if (!_isElectronicsProduct) return widget.product;
    return Product(
      id: widget.product.id,
      title: widget.product.title,
      price: _selectedPrice,
      description: widget.product.description,
      category: widget.product.category,
      image: widget.product.image,
      rating: widget.product.rating,
      ratingCount: widget.product.ratingCount,
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final displayPrice = _selectedPrice;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Product preview
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Hero(
                    tag: 'product_${product.id}_sheet',
                    child: Image.network(
                      product.image,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) =>
                          Container(width: 80, height: 80, color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        Formatters.currency(displayPrice),
                        style: const TextStyle(
                          color: Color(0xFFEE4D2D),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Size selector
            Text(
              _isElectronicsProduct ? 'Chọn dung lượng' : 'Chọn Kích cỡ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _availableSizes.map((size) {
                final selected = size == _selectedSize;
                return GestureDetector(
                  onTap: () => setState(() => _selectedSize = size),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: selected
                          ? const Color(0xFFEE4D2D)
                          : Colors.transparent,
                      border: Border.all(
                        color: selected
                            ? const Color(0xFFEE4D2D)
                            : Colors.grey.shade400,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      size,
                      style: TextStyle(
                        color: selected ? Colors.white : Colors.black87,
                        fontWeight: selected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            if (_showsColorSelector) ...[
              const SizedBox(height: 16),
              // Color selector
              const Text(
                'Chọn Màu sắc',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _availableColors.map((c) {
                  final selected = c['value'] == _selectedColor;
                  return GestureDetector(
                    onTap: () =>
                        setState(() => _selectedColor = c['value'] as String),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: selected
                              ? const Color(0xFFEE4D2D)
                              : Colors.grey.shade400,
                          width: selected ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              color: c['color'] as Color,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(c['label'] as String),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ] else
              const SizedBox(height: 16),
            // Quantity selector
            Row(
              children: [
                const Text(
                  'Số lượng',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                _QuantityButton(
                  icon: Icons.remove,
                  onTap: _quantity > 1
                      ? () => setState(() => _quantity--)
                      : null,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    '$_quantity',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _QuantityButton(
                  icon: Icons.add,
                  onTap: () => setState(() => _quantity++),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Confirm button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _confirm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEE4D2D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  widget.buyNow ? 'Mua ngay' : 'Thêm vào giỏ hàng',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirm() {
    context.read<CartProvider>().addItem(
      product: _selectedVariantProduct,
      size: _selectedSize,
      color: _showsColorSelector ? _selectedColor : 'khong-mau',
      quantity: _quantity,
    );
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✓ Đã thêm vào giỏ hàng thành công!'),
        backgroundColor: Color(0xFF2E7D32),
        duration: Duration(seconds: 2),
      ),
    );
    if (widget.buyNow) {
      Navigator.pushNamed(context, '/cart');
    }
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _QuantityButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          border: Border.all(
            color: onTap != null ? Colors.grey.shade400 : Colors.grey.shade200,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(
          icon,
          size: 18,
          color: onTap != null ? Colors.black87 : Colors.grey.shade300,
        ),
      ),
    );
  }
}
