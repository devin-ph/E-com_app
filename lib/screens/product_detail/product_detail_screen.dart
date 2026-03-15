import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

import '../../../models/product.dart';
import '../../../utils/formatters.dart';
import '../../../widgets/cart_icon_button.dart';
import 'widgets/add_to_cart_bottom_sheet.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final PageController _pageController = PageController();
  int _imageIndex = 0;
  bool _expandedDescription = false;

  static const Map<String, String> _categoryLabelsVi = {
    'jewelery': 'Trang sức',
    "men's clothing": 'Quần áo nam',
    "women's clothing": 'Quần áo nữ',
    'electronics': 'Đồ điện tử',
    'beauty': 'Mỹ phẩm',
  };

  static const Map<int, String> _titleViById = {
    1: 'Ba lô du lịch thời trang',
    2: 'Áo thun nam cao cấp',
    3: 'Áo khoác nam Urban Fit',
    4: 'Áo sơ mi nam kiểu dáng thanh lịch',
    5: 'Vòng tay nữ tinh tế',
    6: 'Nhẫn kim cương thanh lịch',
    7: 'Nhẫn vàng đính đá cao cấp',
    8: 'Khuyên tai nữ thời trang',
    9: 'Ổ cứng di động dung lượng lớn',
    10: 'Ổ SSD hiệu năng cao',
    11: 'Loa Bluetooth mini tiện dụng',
    12: 'Màn hình gaming chất lượng cao',
    13: 'Áo khoác nữ dáng ngắn',
    14: 'Áo khoác nữ chống gió',
    15: 'Áo khoác nữ mùa đông',
    16: 'Áo thun nữ basic',
    17: 'Áo thun nữ phong cách trẻ',
    18: 'Áo thun nữ năng động',
    19: 'Áo khoác nữ thời trang',
    20: 'Áo khoác nữ cao cấp',
  };

  static const Map<int, String> _descriptionViById = {
    1: 'Ba lô đa năng phù hợp cho đi học, đi làm và du lịch ngắn ngày. Thiết kế gọn nhẹ, ngăn chứa rộng rãi và đệm lưng êm ái.',
    2: 'Áo thun nam chất liệu mềm mại, thoáng mát, phù hợp mặc hằng ngày. Kiểu dáng đơn giản, dễ phối đồ.',
    3: 'Áo khoác nam Urban Fit giữ ấm vừa phải, thiết kế hiện đại và dễ phối cùng quần jean hoặc kaki.',
    4: 'Áo sơ mi nam thanh lịch, chất vải mềm, đứng form tốt. Phù hợp mặc đi làm hoặc dự sự kiện.',
    5: 'Vòng tay nữ thiết kế tinh tế, nhẹ tay và dễ kết hợp cùng nhiều phong cách thời trang.',
    6: 'Nhẫn đính đá thiết kế tối giản, tôn vẻ thanh lịch và sang trọng khi sử dụng hằng ngày hoặc dự tiệc.',
    7: 'Nhẫn vàng cao cấp với đường nét tinh xảo, phù hợp làm quà tặng hoặc sử dụng trong các dịp đặc biệt.',
    8: 'Khuyên tai nữ phong cách hiện đại, mang lại điểm nhấn nổi bật cho tổng thể trang phục.',
    9: 'Ổ cứng di động dung lượng lớn, truyền dữ liệu ổn định và tiện lợi cho nhu cầu sao lưu hằng ngày.',
    10: 'Ổ SSD tốc độ cao giúp khởi động máy nhanh, tăng hiệu suất làm việc và xử lý dữ liệu mượt mà.',
    11: 'Loa Bluetooth nhỏ gọn, kết nối nhanh, âm thanh rõ ràng, phù hợp mang theo khi di chuyển.',
    12: 'Màn hình gaming hiển thị sắc nét, tần số quét cao, mang lại trải nghiệm chơi game mượt mà.',
    13: 'Áo khoác nữ dáng ngắn trẻ trung, chất liệu mềm nhẹ, phù hợp sử dụng trong thời tiết mát lạnh.',
    14: 'Áo khoác nữ chống gió, thiết kế tiện dụng và thoải mái, thích hợp cho hoạt động ngoài trời.',
    15: 'Áo khoác nữ mùa đông giữ ấm tốt, form dáng đẹp và dễ phối với nhiều loại trang phục.',
    16: 'Áo thun nữ basic với chất vải co giãn nhẹ, mềm mại và thoáng khí cho cảm giác dễ chịu cả ngày.',
    17: 'Áo thun nữ phong cách trẻ, đường may chắc chắn, phù hợp đi học, đi chơi hoặc dạo phố.',
    18: 'Áo thun nữ năng động, màu sắc hài hòa, phù hợp phối cùng quần jean hoặc chân váy.',
    19: 'Áo khoác nữ thời trang với thiết kế hiện đại, giúp giữ ấm nhẹ và tôn dáng khi mặc.',
    20: 'Áo khoác nữ cao cấp, chất liệu bền đẹp, mang lại cảm giác thoải mái và sang trọng.',
  };

  // Extensible category-based metadata templates (JSON-like map).
  static const Map<String, Map<String, String>> _categorySpecTemplates = {
    'jewelery': {
      'Chất liệu': 'Hợp kim cao cấp',
      'Phong cách': 'Tinh tế, sang trọng',
      'Đối tượng': 'Nam/Nữ',
    },
    "men's clothing": {
      'Chất liệu': 'Vải mềm, thoáng',
      'Kiểu dáng': 'Cơ bản, dễ phối',
      'Mùa phù hợp': 'Quanh năm',
    },
    "women's clothing": {
      'Chất liệu': 'Vải mềm nhẹ',
      'Kiểu dáng': 'Thanh lịch',
      'Mùa phù hợp': 'Xuân - Hè',
    },
    'electronics': {
      'Bảo hành': '12 tháng',
      'Nguồn điện': 'AC 220V',
      'Tính năng': 'Hiệu năng ổn định',
    },
    'beauty': {
      'Loại da': 'Mọi loại da',
      'Hạn sử dụng': '24 tháng',
      'Xuất xứ': 'Nhập khẩu',
    },
  };

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is! Product) {
      return Scaffold(
        appBar: AppBar(title: const Text('Chi tiết sản phẩm')),
        body: const Center(
          child: Text(
            'Không tìm thấy dữ liệu sản phẩm.\nVui lòng quay lại và chọn sản phẩm khác.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final product = args;
    final images = product.images;
    final specs = _buildSpecs(product);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        title: const Text(
          'Chi tiết sản phẩm',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        actions: const [CartIconButton(iconColor: Colors.black87)],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1) Product image area (above action buttons)
            _ImageCarousel(
              images: images,
              productId: product.id,
              imageIndex: _imageIndex,
              pageController: _pageController,
              onPageChanged: (index) => setState(() => _imageIndex = index),
            ),

            // 2) Action buttons right below images
            _InlineActionBar(product: product),

            // 3) Product detail info below action buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        Formatters.currency(product.price),
                        style: const TextStyle(
                          color: Color(0xFFEE4D2D),
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        Formatters.currency(product.originalPrice),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEE4D2D),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          product.discountTag,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _localizedTitle(product),
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: Text(
                          _localizedCategory(product.category),
                          style: TextStyle(
                            color: Colors.blue.shade700,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${product.rating.toStringAsFixed(1)} (${product.ratingCount})',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    product.soldDisplay,
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const Divider(height: 28),

                  const Text(
                    'Mô tả sản phẩm',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 8),
                  AnimatedCrossFade(
                    firstChild: Text(
                      _localizedDescription(product),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 13,
                        height: 1.6,
                      ),
                    ),
                    secondChild: Text(
                      _localizedDescription(product),
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 13,
                        height: 1.6,
                      ),
                    ),
                    crossFadeState: _expandedDescription
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 250),
                  ),
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: () => setState(
                      () => _expandedDescription = !_expandedDescription,
                    ),
                    child: Text(
                      _expandedDescription ? 'Thu gọn' : 'Xem thêm',
                      style: const TextStyle(
                        color: Color(0xFFEE4D2D),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const Divider(height: 28),
                  const Text(
                    'Thông tin bổ sung',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 10),
                  _SpecTable(specs: specs),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, String> _buildSpecs(Product product) {
    final categoryKey = product.category.toLowerCase().trim();
    final categoryTemplate =
        _categorySpecTemplates[categoryKey] ??
        {
          'Nhóm sản phẩm': _localizedCategory(product.category),
          'Chất lượng': 'Chính hãng',
          'Phân loại': 'Đa dạng tùy chọn',
        };

    return {
      'Mã sản phẩm': '#${product.id}',
      'Danh mục': _localizedCategory(product.category),
      'Giá hiện tại': Formatters.currency(product.price),
      ...categoryTemplate,
      'Đánh giá': '${product.rating.toStringAsFixed(1)}/5',
      'Số lượt đánh giá': '${product.ratingCount}',
    };
  }

  String _localizedCategory(String category) {
    final key = category.toLowerCase().trim();
    return _categoryLabelsVi[key] ?? _capitalizeWords(category);
  }

  String _localizedTitle(Product product) {
    final mapped = _titleViById[product.id];
    if (mapped != null) return mapped;
    return _capitalizeWords(product.title);
  }

  String _localizedDescription(Product product) {
    final mapped = _descriptionViById[product.id];
    if (mapped != null) return mapped;
    return _defaultDescriptionByCategory(product.category);
  }

  String _defaultDescriptionByCategory(String category) {
    final key = category.toLowerCase().trim();
    switch (key) {
      case 'jewelery':
        return 'Sản phẩm trang sức thiết kế tinh tế, phù hợp sử dụng hằng ngày hoặc trong các dịp đặc biệt.';
      case "men's clothing":
      case "women's clothing":
        return 'Sản phẩm thời trang có chất liệu thoải mái, kiểu dáng hiện đại và dễ phối với nhiều trang phục.';
      case 'electronics':
        return 'Sản phẩm điện tử có hiệu năng ổn định, đáp ứng tốt nhu cầu sử dụng hằng ngày.';
      case 'beauty':
        return 'Sản phẩm mỹ phẩm an toàn, phù hợp nhiều loại da và thuận tiện cho chu trình chăm sóc hằng ngày.';
      default:
        return 'Sản phẩm chất lượng tốt, thiết kế đẹp và phù hợp với nhiều nhu cầu sử dụng khác nhau.';
    }
  }

  String _capitalizeWords(String value) {
    return value
        .split(' ')
        .map((word) {
          if (word.isEmpty) return word;
          return '${word[0].toUpperCase()}${word.substring(1)}';
        })
        .join(' ');
  }
}

class _ImageCarousel extends StatelessWidget {
  final List<String> images;
  final int productId;
  final int imageIndex;
  final PageController pageController;
  final ValueChanged<int> onPageChanged;

  const _ImageCarousel({
    required this.images,
    required this.productId,
    required this.imageIndex,
    required this.pageController,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 320,
          child: PageView.builder(
            controller: pageController,
            itemCount: images.length,
            onPageChanged: onPageChanged,
            itemBuilder: (context, index) {
              return Hero(
                tag: index == 0
                    ? 'product_$productId'
                    : 'product_${productId}_$index',
                child: CachedNetworkImage(
                  imageUrl: images[index],
                  fit: BoxFit.contain,
                  width: double.infinity,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(color: Colors.white),
                  ),
                  errorWidget: (context, url, error) => const Center(
                    child: Icon(
                      Icons.broken_image_outlined,
                      size: 72,
                      color: Colors.grey,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        if (images.length > 1)
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(images.length, (i) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: imageIndex == i ? 18 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: imageIndex == i
                        ? const Color(0xFFEE4D2D)
                        : Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }
}

class _InlineActionBar extends StatelessWidget {
  final Product product;

  const _InlineActionBar({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            SizedBox(
              width: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chat_bubble_outline),
                    onPressed: () {},
                    color: Colors.grey.shade700,
                  ),
                  IconButton(
                    icon: const Icon(Icons.shopping_cart_outlined),
                    onPressed: () => Navigator.pushNamed(context, '/cart'),
                    color: Colors.grey.shade700,
                  ),
                ],
              ),
            ),
            const VerticalDivider(width: 1),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => AddToCartBottomSheet.show(context, product),
                      child: Container(
                        height: 48,
                        color: Colors.orange.shade400,
                        alignment: Alignment.center,
                        child: const Text(
                          'Thêm vào\ngiỏ hàng',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () => AddToCartBottomSheet.show(
                        context,
                        product,
                        buyNow: true,
                      ),
                      child: Container(
                        height: 48,
                        color: const Color(0xFFEE4D2D),
                        alignment: Alignment.center,
                        child: const Text(
                          'Mua ngay',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SpecTable extends StatelessWidget {
  final Map<String, String> specs;

  const _SpecTable({required this.specs});

  @override
  Widget build(BuildContext context) {
    final rows = specs.entries.toList();

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Table(
        border: TableBorder.all(
          color: const Color(0xFFEEEEEE),
          borderRadius: BorderRadius.circular(8),
        ),
        columnWidths: const {0: FixedColumnWidth(140), 1: FlexColumnWidth()},
        children: rows.asMap().entries.map((entry) {
          final isOdd = entry.key.isOdd;
          final item = entry.value;
          return TableRow(
            decoration: BoxDecoration(
              color: isOdd ? const Color(0xFFF9F9F9) : Colors.white,
            ),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: Text(
                  item.key,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: Text(
                  item.value,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
