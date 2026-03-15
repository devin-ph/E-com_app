import 'package:flutter/material.dart';

class AppCategory {
  final String name;
  final IconData icon;
  final Color color;
  final String apiCategory; // matches FakeStore API category or empty for all

  const AppCategory({
    required this.name,
    required this.icon,
    required this.color,
    this.apiCategory = '',
  });
}

const List<AppCategory> kCategories = [
  AppCategory(
    name: 'Tất cả',
    icon: Icons.apps_rounded,
    color: Color(0xFFEE4D2D),
    apiCategory: '',
  ),
  AppCategory(
    name: 'Thời trang nam',
    icon: Icons.checkroom_outlined,
    color: Color(0xFF1565C0),
    apiCategory: "men's clothing",
  ),
  AppCategory(
    name: 'Thời trang nữ',
    icon: Icons.woman_outlined,
    color: Color(0xFFAD1457),
    apiCategory: "women's clothing",
  ),
  AppCategory(
    name: 'Điện tử',
    icon: Icons.devices_outlined,
    color: Color(0xFF00838F),
    apiCategory: 'electronics',
  ),
  AppCategory(
    name: 'Trang sức',
    icon: Icons.diamond_outlined,
    color: Color(0xFFF9A825),
    apiCategory: 'jewelery',
  ),
  AppCategory(
    name: 'Mỹ phẩm',
    icon: Icons.face_retouching_natural,
    color: Color(0xFFE91E63),
    apiCategory: '',
  ),
  AppCategory(
    name: 'Gia dụng',
    icon: Icons.kitchen_outlined,
    color: Color(0xFF2E7D32),
    apiCategory: '',
  ),
  AppCategory(
    name: 'Thể thao',
    icon: Icons.sports_basketball_outlined,
    color: Color(0xFFFF6F00),
    apiCategory: '',
  ),
];
