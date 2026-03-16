import 'package:flutter/material.dart';

class AppCategory {
  final String name;
  final IconData icon;
  final Color color;
  final String apiCategory;

  const AppCategory({
    required this.name,
    required this.icon,
    required this.color,
    this.apiCategory = '',
  });
}

const List<String> kDummyJsonCategorySlugs = [
  'beauty',
  'fragrances',
  'furniture',
  'groceries',
  'home-decoration',
  'kitchen-accessories',
  'laptops',
  'mens-shirts',
  'mens-shoes',
  'mens-watches',
  'mobile-accessories',
  'motorcycle',
  'skin-care',
  'smartphones',
  'sports-accessories',
  'sunglasses',
  'tablets',
  'tops',
  'vehicle',
  'womens-bags',
  'womens-dresses',
  'womens-jewellery',
  'womens-shoes',
  'womens-watches',
];

const List<AppCategory> kCategories = [
  AppCategory(
    name: 'Tất cả',
    icon: Icons.apps_rounded,
    color: Color(0xFFEE4D2D),
    apiCategory: '',
  ),
  AppCategory(
    name: 'Mỹ phẩm',
    icon: Icons.face_retouching_natural,
    color: Color(0xFFE91E63),
    apiCategory: 'beauty',
  ),
  AppCategory(
    name: 'Nước hoa',
    icon: Icons.spa_outlined,
    color: Color(0xFF8E24AA),
    apiCategory: 'fragrances',
  ),
  AppCategory(
    name: 'Nội thất',
    icon: Icons.chair_outlined,
    color: Color(0xFF6D4C41),
    apiCategory: 'furniture',
  ),
  AppCategory(
    name: 'Tạp hóa',
    icon: Icons.local_grocery_store_outlined,
    color: Color(0xFF43A047),
    apiCategory: 'groceries',
  ),
  AppCategory(
    name: 'Trang trí nhà',
    icon: Icons.home_outlined,
    color: Color(0xFF00897B),
    apiCategory: 'home-decoration',
  ),
  AppCategory(
    name: 'Phụ kiện bếp',
    icon: Icons.kitchen_outlined,
    color: Color(0xFF2E7D32),
    apiCategory: 'kitchen-accessories',
  ),
  AppCategory(
    name: 'Laptop',
    icon: Icons.laptop_mac_outlined,
    color: Color(0xFF3949AB),
    apiCategory: 'laptops',
  ),
  AppCategory(
    name: 'Áo nam',
    icon: Icons.checkroom_outlined,
    color: Color(0xFF1565C0),
    apiCategory: 'mens-shirts',
  ),
  AppCategory(
    name: 'Giày nam',
    icon: Icons.hiking_outlined,
    color: Color(0xFF5D4037),
    apiCategory: 'mens-shoes',
  ),
  AppCategory(
    name: 'Đồng hồ nam',
    icon: Icons.watch_outlined,
    color: Color(0xFF546E7A),
    apiCategory: 'mens-watches',
  ),
  AppCategory(
    name: 'Phụ kiện mobile',
    icon: Icons.cable_outlined,
    color: Color(0xFF00ACC1),
    apiCategory: 'mobile-accessories',
  ),
  AppCategory(
    name: 'Xe máy',
    icon: Icons.two_wheeler_outlined,
    color: Color(0xFFF4511E),
    apiCategory: 'motorcycle',
  ),
  AppCategory(
    name: 'Chăm sóc da',
    icon: Icons.sanitizer_outlined,
    color: Color(0xFFD81B60),
    apiCategory: 'skin-care',
  ),
  AppCategory(
    name: 'Điện thoại',
    icon: Icons.smartphone_outlined,
    color: Color(0xFF00838F),
    apiCategory: 'smartphones',
  ),
  AppCategory(
    name: 'Phụ kiện thể thao',
    icon: Icons.sports_basketball_outlined,
    color: Color(0xFFFF6F00),
    apiCategory: 'sports-accessories',
  ),
  AppCategory(
    name: 'Kính mát',
    icon: Icons.visibility_outlined,
    color: Color(0xFF6A1B9A),
    apiCategory: 'sunglasses',
  ),
  AppCategory(
    name: 'Máy tính bảng',
    icon: Icons.tablet_mac_outlined,
    color: Color(0xFF1E88E5),
    apiCategory: 'tablets',
  ),
  AppCategory(
    name: 'Áo nữ',
    icon: Icons.dry_cleaning_outlined,
    color: Color(0xFFEC407A),
    apiCategory: 'tops',
  ),
  AppCategory(
    name: 'Xe cộ',
    icon: Icons.directions_car_filled_outlined,
    color: Color(0xFF455A64),
    apiCategory: 'vehicle',
  ),
  AppCategory(
    name: 'Túi nữ',
    icon: Icons.shopping_bag_outlined,
    color: Color(0xFF8D6E63),
    apiCategory: 'womens-bags',
  ),
  AppCategory(
    name: 'Đầm nữ',
    icon: Icons.woman_outlined,
    color: Color(0xFFAD1457),
    apiCategory: 'womens-dresses',
  ),
  AppCategory(
    name: 'Trang sức nữ',
    icon: Icons.diamond_outlined,
    color: Color(0xFFF9A825),
    apiCategory: 'womens-jewellery',
  ),
  AppCategory(
    name: 'Giày nữ',
    icon: Icons.style_outlined,
    color: Color(0xFF7B1FA2),
    apiCategory: 'womens-shoes',
  ),
  AppCategory(
    name: 'Đồng hồ nữ',
    icon: Icons.watch_later_outlined,
    color: Color(0xFFC2185B),
    apiCategory: 'womens-watches',
  ),
];
