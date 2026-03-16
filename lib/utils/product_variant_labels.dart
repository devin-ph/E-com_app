import '../models/cart_item.dart';
import '../models/product.dart';

// ── ID sets (mirrors add_to_cart_bottom_sheet.dart) ──────────────────────────
const Set<int> _weightedGroceryIds = {
  16,
  17,
  18,
  19,
  21,
  22,
  24,
  25,
  26,
  30,
  31,
  33,
  35,
  37,
  38,
  40,
};
const Set<int> _liquidProductIds = {20, 27, 29, 32, 39, 42};
const Set<int> _eggProductIds = {23};
const Set<int> _quantityOnlyProductIds = {28, 34, 36, 41};

// ── Category helpers ──────────────────────────────────────────────────────────
bool _isJewelry(Product p) {
  final c = p.category.toLowerCase().trim();
  return c == 'womens-jewellery' ||
      c == 'mens-watches' ||
      c == 'womens-watches' ||
      c == 'sunglasses';
}

bool _isElectronics(Product p) {
  final c = p.category.toLowerCase().trim();
  return c == 'smartphones' ||
      c == 'laptops' ||
      c == 'tablets' ||
      c == 'mobile-accessories';
}

bool _isSmartphone(Product p) =>
    p.category.toLowerCase().trim() == 'smartphones';

bool _isFragrance(Product p) => p.category.toLowerCase().trim() == 'fragrances';

bool _isSkinCare(Product p) => p.category.toLowerCase().trim() == 'skin-care';

bool _isShoes(Product p) {
  final c = p.category.toLowerCase().trim();
  return c == 'mens-shoes' || c == 'womens-shoes';
}

bool _isQuantityOnly(Product p) {
  final c = p.category.toLowerCase().trim();
  return c == 'kitchen-accessories' ||
      c == 'sunglasses' ||
      c == 'vehicle' ||
      c == 'sports-accessories' ||
      c == 'home-decoration' ||
      c == 'furniture' ||
      c == 'beauty' ||
      c == 'mobile-accessories' ||
      _quantityOnlyProductIds.contains(p.id);
}

bool _hasNoColor(Product p) {
  return _isQuantityOnly(p) ||
      (_isElectronics(p) && !_isSmartphone(p)) ||
      _isFragrance(p) ||
      _isSkinCare(p) ||
      _weightedGroceryIds.contains(p.id) ||
      _liquidProductIds.contains(p.id) ||
      _eggProductIds.contains(p.id);
}

// ── Public API ────────────────────────────────────────────────────────────────

/// Returns the human-readable label for the size dimension of [item].
/// e.g. "Dung lượng: 256Gb", "Khối lượng: 2kg", "Kích cỡ: M", …
/// Returns null when the product has no size variant (quantity-only items).
String? sizeLabel(CartItem item) {
  final p = item.product;
  final size = item.size;
  if (size == 'none' || size.isEmpty) return null;

  if (_isQuantityOnly(p)) return null;

  if (_isElectronics(p)) return 'Dung lượng: $size';
  if (_isFragrance(p)) return 'Thể tích: $size';
  if (_isSkinCare(p)) return 'Dung tích: $size';
  if (_isShoes(p)) return 'Size: $size';
  if (_eggProductIds.contains(p.id)) return 'Số lượng: $size';
  if (_liquidProductIds.contains(p.id)) return 'Thể tích: $size';
  if (_weightedGroceryIds.contains(p.id)) return 'Khối lượng: $size';
  if (_isJewelry(p)) return 'Size: $size';
  return 'Kích cỡ: $size';
}

/// Returns the human-readable label for the color dimension of [item].
/// Returns null when the product type has no color variant.
String? colorLabel(CartItem item) {
  final p = item.product;
  final color = item.color;
  if (color == 'none' || color.isEmpty) return null;
  if (_hasNoColor(p)) return null;
  if (_isJewelry(p)) return 'Chất liệu: $color';
  return 'Màu: $color';
}
