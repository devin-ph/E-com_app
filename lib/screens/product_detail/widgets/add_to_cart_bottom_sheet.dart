import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/product.dart';
import '../../../providers/cart_provider.dart';
import '../../../utils/formatters.dart';

const List<String> _defaultSizes = ['S', 'M', 'L', 'XL', 'XXL'];
const List<String> _electronicsCapacities = ['128Gb', '256Gb', '512Gb', '1Tb'];
const List<Map<String, dynamic>> _defaultColors = [
  {'label': 'Đen', 'value': 'black', 'color': Colors.black},
  {'label': 'Trắng', 'value': 'white', 'color': Colors.white},
  {'label': 'Đỏ', 'value': 'red', 'color': Colors.red},
  {'label': 'Xanh', 'value': 'blue', 'color': Colors.blue},
  {'label': 'Vàng', 'value': 'yellow', 'color': Colors.amber},
];

const List<String> _jewelrySizes = ['13', '14', '15', '16', '17'];
const List<Map<String, dynamic>> _jewelryColors = [
  {'label': 'Bạc', 'value': 'silver', 'color': Color(0xFFC0C0C0)},
  {'label': 'Vàng kim', 'value': 'gold', 'color': Color(0xFFD4AF37)},
];

const Map<int, String> _productTitlesVi = {
  1: 'Balo Fjallraven Foldsack số 1 cho laptop 15 inch',
  2: 'Áo thun nam dáng ôm cao cấp tay raglan',
  3: 'Áo khoác nam cotton chính hãng',
  4: 'Áo sơ mi nam casual slim fit',
  5: 'Vòng tay rồng bạc và vàng nguyên khối',
  6: 'Nhẫn vàng nguyên khối Petite Micropave',
  7: 'Nhẫn công chúa vàng trắng',
  8: 'Khuyên tai mạ vàng hồng',
  9: 'Ổ cứng di động WD 2TB USB 3.0',
  10: 'Ổ cứng SSD SanDisk 1TB',
  11: 'SSD Silicon Power 256GB 3D NAND',
  12: 'SSD WD 4TB tương thích PlayStation 5',
  13: 'Màn hình gaming Acer 21.5 inch Full HD',
  14: 'Màn hình cong Samsung 49 inch siêu rộng',
  15: 'Áo khoác nữ 3-trong-1 chống gió',
  16: 'Áo khoác mô tô nữ giả da',
  17: 'Áo mưa nữ chống gió đi xe đạp',
  18: 'Áo thun nữ tay ngắn cổ tròn',
  19: 'Áo thun nữ cotton cổ tim',
  20: 'Áo blouse nữ form rộng',
};

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
  String _selectedSize = _defaultSizes.first;
  String _selectedColor = _defaultColors.first['value'] as String;
  int _quantity = 1;

  static const double _vndStepByCapacity = 500000;
  static const double _vndPerUsd = 25000;

  bool get _isJewelry =>
      widget.product.category.toLowerCase().trim() == 'jewelery';

  bool get _isElectronics =>
      widget.product.category.toLowerCase().trim() == 'electronics';

  List<String> get _sizes {
    if (_isElectronics) return _electronicsCapacities;
    if (_isJewelry) return _jewelrySizes;
    return _defaultSizes;
  }

  List<Map<String, dynamic>> get _colors =>
      _isJewelry ? _jewelryColors : _defaultColors;

  int get _capacityStepIndex {
    if (!_isElectronics) return 0;
    return _electronicsCapacities
        .indexOf(_selectedSize)
        .clamp(0, _electronicsCapacities.length - 1);
  }

  double get _effectivePrice {
    if (!_isElectronics) return widget.product.price;
    final increaseUsd = (_capacityStepIndex * _vndStepByCapacity) / _vndPerUsd;
    return widget.product.price + increaseUsd;
  }

  String get _displayTitle {
    return _productTitlesVi[widget.product.id] ?? 'Sản phẩm cao cấp';
  }

  String get _displayPrice => Formatters.vnd(_effectivePrice);

  @override
  void initState() {
    super.initState();
    _selectedSize = _sizes.first;
    _selectedColor = _isElectronics ? 'none' : _colors.first['value'] as String;
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
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
                        _displayTitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _displayPrice,
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
              _isElectronics ? 'Chọn dung lượng' : 'Chọn Kích cỡ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _sizes.map((size) {
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
            if (_isElectronics)
              ...[]
            else ...[
              const SizedBox(height: 16),
              // Color selector
              const Text(
                'Chọn Màu sắc',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _colors.map((c) {
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
            ],
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
    final productForCart = _isElectronics
        ? Product(
            id: widget.product.id,
            title: widget.product.title,
            price: _effectivePrice,
            description: widget.product.description,
            category: widget.product.category,
            image: widget.product.image,
            rating: widget.product.rating,
            ratingCount: widget.product.ratingCount,
            discountPercent: widget.product.discountPercent,
          )
        : widget.product;

    context.read<CartProvider>().addItem(
      product: productForCart,
      size: _selectedSize,
      color: _selectedColor,
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
