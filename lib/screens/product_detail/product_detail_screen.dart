import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

import '../../../models/product.dart';
import '../../../utils/formatters.dart';
import '../../../utils/product_localization.dart';
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
    'beauty': 'Mỹ phẩm',
    'fragrances': 'Nước hoa',
    'furniture': 'Nội thất',
    'groceries': 'Tạp hóa',
    'home-decoration': 'Trang trí nhà',
    'kitchen-accessories': 'Phụ kiện bếp',
    'laptops': 'Laptop',
    'mens-shirts': 'Áo nam',
    'mens-shoes': 'Giày nam',
    'mens-watches': 'Đồng hồ nam',
    'mobile-accessories': 'Phụ kiện mobile',
    'motorcycle': 'Xe máy',
    'skin-care': 'Chăm sóc da',
    'smartphones': 'Điện thoại',
    'sports-accessories': 'Phụ kiện thể thao',
    'sunglasses': 'Kính mát',
    'tablets': 'Máy tính bảng',
    'tops': 'Áo nữ',
    'vehicle': 'Xe cộ',
    'womens-bags': 'Túi nữ',
    'womens-dresses': 'Đầm nữ',
    'womens-jewellery': 'Trang sức nữ',
    'womens-shoes': 'Giày nữ',
    'womens-watches': 'Đồng hồ nữ',
  };

  // Extensible category-based metadata templates (JSON-like map).
  static const Map<String, Map<String, String>> _categorySpecTemplates = {
    'beauty': {
      'Loại da': 'Mọi loại da',
      'Hạn sử dụng': '24 tháng',
      'Xuất xứ': 'Nhập khẩu',
    },
    'fragrances': {
      'Dung tích': '50–100 ml',
      'Hương thơm': 'Nhẹ nhàng, lưu hương lâu',
      'Đối tượng': 'Nam/Nữ',
    },
    'furniture': {
      'Chất liệu': 'Gỗ cao cấp',
      'Phong cách': 'Hiện đại',
      'Bảo hành': '12 tháng',
    },
    'groceries': {
      'Xuất xứ': 'Trong nước',
      'Bảo quản': 'Nơi khô ráo, thoáng mát',
      'Hạn sử dụng': 'Xem trên bao bì',
    },
    'home-decoration': {
      'Chất liệu': 'Hỗn hợp cao cấp',
      'Phong cách': 'Trang nhã',
      'Phù hợp': 'Mọi không gian',
    },
    'kitchen-accessories': {
      'Chất liệu': 'Inox/Nhựa cao cấp',
      'An toàn': 'Không chứa BPA',
      'Bảo hành': '6 tháng',
    },
    'laptops': {
      'Bảo hành': '12 tháng',
      'Hệ điều hành': 'Windows/macOS',
      'Tính năng': 'Hiệu năng cao',
    },
    'mens-shirts': {
      'Chất liệu': 'Vải mềm, thoáng',
      'Kiểu dáng': 'Cơ bản, dễ phối',
      'Mùa phù hợp': 'Quanh năm',
    },
    'mens-shoes': {
      'Chất liệu': 'Da/Vải cao cấp',
      'Đế giày': 'Đế cao su chống trượt',
      'Phong cách': 'Năng động',
    },
    'mens-watches': {
      'Chất liệu': 'Thép không gỉ',
      'Kính': 'Kính sapphire',
      'Chống nước': '30m',
    },
    'mobile-accessories': {
      'Tương thích': 'Đa dòng máy',
      'Bảo hành': '6 tháng',
      'Chất liệu': 'Cao cấp',
    },
    'motorcycle': {
      'Bảo hành': '24 tháng',
      'Nhiên liệu': 'Xăng',
      'Tiêu chuẩn khí thải': 'Euro 4',
    },
    'skin-care': {
      'Loại da': 'Mọi loại da',
      'Hạn sử dụng': '24 tháng',
      'Thành phần': 'Tự nhiên',
    },
    'smartphones': {
      'Bảo hành': '12 tháng',
      'Hệ điều hành': 'Android/iOS',
      'Kết nối': '5G/4G',
    },
    'sports-accessories': {
      'Chất liệu': 'Bền, nhẹ',
      'Phù hợp': 'Mọi hoạt động thể thao',
      'Bảo hành': '6 tháng',
    },
    'sunglasses': {
      'Chất liệu gọng': 'Kim loại/Nhựa',
      'Tròng kính': 'Chống tia UV400',
      'Phong cách': 'Thời trang',
    },
    'tablets': {
      'Bảo hành': '12 tháng',
      'Hệ điều hành': 'Android/iPadOS',
      'Kết nối': 'Wi-Fi/4G',
    },
    'tops': {
      'Chất liệu': 'Vải mềm nhẹ',
      'Kiểu dáng': 'Thanh lịch',
      'Mùa phù hợp': 'Xuân - Hè',
    },
    'vehicle': {
      'Bảo hành': '24 tháng',
      'Nhiên liệu': 'Xăng/Điện',
      'Tiêu chuẩn': 'Euro 4',
    },
    'womens-bags': {
      'Chất liệu': 'Da tổng hợp cao cấp',
      'Phong cách': 'Thời trang',
      'Màu sắc': 'Đa dạng',
    },
    'womens-dresses': {
      'Chất liệu': 'Vải mềm nhẹ',
      'Kiểu dáng': 'Thanh lịch',
      'Mùa phù hợp': 'Xuân - Hè',
    },
    'womens-jewellery': {
      'Chất liệu': 'Hợp kim cao cấp',
      'Phong cách': 'Tinh tế, sang trọng',
      'Đối tượng': 'Nữ',
    },
    'womens-shoes': {
      'Chất liệu': 'Da/Vải cao cấp',
      'Đế giày': 'Đế cao su chống trượt',
      'Phong cách': 'Thanh lịch',
    },
    'womens-watches': {
      'Chất liệu': 'Thép không gỉ',
      'Kính': 'Kính sapphire',
      'Chống nước': '30m',
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
                        height: 1.6,
                        fontSize: 13,
                      ),
                    ),
                    secondChild: Text(
                      _localizedDescription(product),
                      style: const TextStyle(
                        color: Colors.black87,
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
    return _titleViById[product.id] ?? _localizedCategory(product.category);
  }

  String _localizedDescription(Product product) {
    final key = product.category.toLowerCase().trim();
    return _categoryDescriptionVi[key] ??
        'Sản phẩm chất lượng tốt, thiết kế đẹp và phù hợp nhiều nhu cầu sử dụng khác nhau.';
  }

  static const Map<int, String> _titleViById = {
    // Mỹ phẩm (1-5)
    1: 'Mascara tạo mi Essence Lash Princess',
    2: 'Bảng phấn mắt 16 ô kèm gương',
    3: 'Phấn phủ dạng hộp tiện dụng',
    4: 'Son môi đỏ quyến rũ',
    5: 'Sơn móng tay màu đỏ',
    // Nước hoa (6-10)
    6: 'Nước hoa Calvin Klein CK One',
    7: 'Nước hoa Chanel Coco Noir',
    8: 'Nước hoa Dior J\'adore',
    9: 'Nước hoa Dolce Shine',
    10: 'Nước hoa Gucci Bloom',
    // Nội thất (11-15)
    11: 'Giường ngủ đôi Annibale Colombo cao cấp',
    12: 'Ghế sofa Annibale Colombo',
    13: 'Tủ đầu giường gỗ anh đào châu Phi',
    14: 'Ghế hội nghị điều hành Knoll Saarinen',
    15: 'Chậu rửa mặt gỗ có gương treo tường',
    // Tạp hóa (16-42)
    16: 'Táo tươi nhập khẩu',
    17: 'Thịt bò bít-tết tươi',
    18: 'Thức ăn cho mèo Cat Food',
    19: 'Thịt gà tươi sạch',
    20: 'Dầu ăn thực vật tinh luyện',
    21: 'Dưa chuột tươi',
    22: 'Thức ăn cho chó Pedigree',
    23: 'Trứng gà tươi sạch',
    24: 'Cá phi lê tươi',
    25: 'Ớt chuông xanh tươi',
    26: 'Ớt xanh tươi',
    27: 'Mật ong rừng nguyên chất',
    28: 'Kem que mát lạnh',
    29: 'Nước ép trái cây tươi',
    30: 'Kiwi tươi nhập khẩu',
    31: 'Chanh tươi',
    32: 'Sữa tươi tiệt trùng',
    33: 'Dâu tằm tươi',
    34: 'Cà phê Nescafé hòa tan',
    35: 'Khoai tây tươi',
    36: 'Bột Protein thể hình',
    37: 'Hành tây đỏ tươi',
    38: 'Gạo trắng hạt dài',
    39: 'Nước ngọt có ga',
    40: 'Dâu tây tươi',
    41: 'Hộp khăn giấy tiện dụng',
    42: 'Nước uống tinh khiết',
    // Trang trí nhà (43-47)
    43: 'Xích đu trang trí phòng khách',
    44: 'Khung ảnh cây gia đình',
    45: 'Cây trang trí để nhà',
    46: 'Chậu cây xanh trang trí',
    47: 'Đèn bàn trang trí nội thất',
    // Phụ kiện bếp (48-77)
    48: 'Thìa xới cơm gỗ tre tự nhiên',
    49: 'Cốc nhôm cao cấp màu đen',
    50: 'Dụng cụ đánh trứng màu đen',
    51: 'Máy xay sinh tố để bàn',
    52: 'Chảo thép carbon chịu nhiệt',
    53: 'Thớt cắt thực phẩm đa năng',
    54: 'Dụng cụ vắt cam chanh màu vàng',
    55: 'Dụng cụ thái trứng tiện dụng',
    56: 'Bếp điện gia đình đa năng',
    57: 'Rây lọc mịn nhuyễn',
    58: 'Nĩa dùng bữa đa năng',
    59: 'Ly thủy tinh cao cấp',
    60: 'Dụng cụ bào thực phẩm màu đen',
    61: 'Máy xay cầm tay đa tốc độ',
    62: 'Khay làm đá viên',
    63: 'Rây bếp đa năng',
    64: 'Dao bếp cao cấp chống gỉ',
    65: 'Hộp cơm giữ nhiệt tiện lợi',
    66: 'Lò vi sóng gia đình đa năng',
    67: 'Giá treo cốc gỗ',
    68: 'Chảo chiên chống dính',
    69: 'Đĩa ăn sứ cao cấp',
    70: 'Kẹp gắp thực phẩm màu đỏ',
    71: 'Nồi inox nắp kính trong suốt',
    72: 'Xẻng lật thức ăn',
    73: 'Kệ đựng gia vị bếp',
    74: 'Muỗng/Thìa ăn',
    75: 'Khay phục vụ đa năng',
    76: 'Cây cán bột gỗ',
    77: 'Dụng cụ gọt vỏ màu vàng',
    // Laptop (78-82)
    78: 'Laptop Apple MacBook Pro 14 inch',
    79: 'Laptop Asus Zenbook Pro hai màn hình',
    80: 'Laptop Huawei Matebook X Pro',
    81: 'Laptop Lenovo Yoga 920 dạng gập',
    82: 'Laptop Dell XPS 13 mỏng nhẹ cao cấp',
    // Áo nam (83-87)
    83: 'Áo sơ mi nam kẻ xanh đen',
    84: 'Áo thun nam Gigabyte Aorus gaming',
    85: 'Áo sơ mi nam kẻ caro',
    86: 'Áo sơ mi nam tay ngắn',
    87: 'Áo sơ mi nam kẻ ô vuông',
    // Giày nam (88-92)
    88: 'Giày Nike Air Jordan 1 đỏ đen',
    89: 'Giày bóng chày Nike nam',
    90: 'Giày thể thao Puma Future Rider',
    91: 'Giày sneaker trắng đỏ thời trang',
    92: 'Giày sneaker thể thao trắng đỏ',
    // Đồng hồ nam (93-98)
    93: 'Đồng hồ nam dây da nâu',
    94: 'Đồng hồ cơ Longines Master Collection',
    95: 'Đồng hồ Rolex Cellini mặt đen',
    96: 'Đồng hồ Rolex Cellini Moonphase',
    97: 'Đồng hồ Rolex Datejust cao cấp',
    98: 'Đồng hồ lặn Rolex Submariner',
    // Phụ kiện mobile (99-112)
    99: 'Loa thông minh Amazon Echo Plus',
    100: 'Tai nghe không dây Apple AirPods',
    101: 'Tai nghe chụp tai Apple AirPods Max',
    102: 'Sạc không dây Apple Airpower',
    103: 'Loa thông minh Apple HomePod Mini',
    104: 'Cáp sạc iPhone chính hãng',
    105: 'Pin dự phòng không dây Apple MagSafe',
    106: 'Đồng hồ Apple Watch Series 4 vàng',
    107: 'Tai nghe không dây Beats Flex',
    108: 'Ốp lưng silicone iPhone 12 màu tím',
    109: 'Gậy chụp ảnh Monopod',
    110: 'Đèn selfie kẹp điện thoại',
    111: 'Gậy selfie đa năng',
    112: 'Chân đế camera studio chuyên dụng',
    // Xe máy (113-117)
    113: 'Xe máy đa năng tiện dụng',
    114: 'Xe mô tô Kawasaki Z800',
    115: 'Xe mô tô thể thao MotoGP',
    116: 'Xe tay ga tiện dụng',
    117: 'Xe mô tô thể thao',
    // Chăm sóc da (118-120)
    118: 'Xà phòng rửa tay Attitude Super Leaves',
    119: 'Sữa tắm dưỡng ẩm Olay Shea Butter',
    120: 'Kem dưỡng thể và mặt Vaseline Men',
    // Điện thoại (121-136)
    121: 'Điện thoại iPhone 5s',
    122: 'Điện thoại iPhone 6',
    123: 'Điện thoại iPhone 13 Pro',
    124: 'Điện thoại iPhone X',
    125: 'Điện thoại Oppo A57',
    126: 'Điện thoại Oppo F19 Pro Plus',
    127: 'Điện thoại Oppo K1',
    128: 'Điện thoại Realme C35',
    129: 'Điện thoại Realme X',
    130: 'Điện thoại Realme XT',
    131: 'Điện thoại Samsung Galaxy S7',
    132: 'Điện thoại Samsung Galaxy S8',
    133: 'Điện thoại Samsung Galaxy S10',
    134: 'Điện thoại Vivo S1',
    135: 'Điện thoại Vivo V9',
    136: 'Điện thoại Vivo X21',
    // Phụ kiện thể thao (137-153)
    137: 'Bóng bầu dục Mỹ',
    138: 'Bóng chày',
    139: 'Găng tay bóng chày',
    140: 'Bóng rổ cao cấp',
    141: 'Vành rổ bóng rổ',
    142: 'Bóng cricket',
    143: 'Gậy đánh bóng cricket',
    144: 'Mũ bảo hiểm cricket',
    145: 'Khung cổng cricket',
    146: 'Cầu lông vũ',
    147: 'Bóng đá chính hãng',
    148: 'Bóng golf',
    149: 'Gậy golf sắt',
    150: 'Gậy bóng chày kim loại',
    151: 'Bóng tennis',
    152: 'Vợt tennis cao cấp',
    153: 'Bóng chuyền cao cấp',
    // Kính mát (154-158)
    154: 'Kính mát đen phong cách',
    155: 'Kính mát cổ điển thời trang',
    156: 'Kính mát xanh đen nổi bật',
    157: 'Kính mát dự tiệc',
    158: 'Kính mát phong cách đường phố',
    // Máy tính bảng (159-161)
    159: 'Máy tính bảng iPad Mini 2021',
    160: 'Máy tính bảng Samsung Galaxy Tab S8 Plus',
    161: 'Máy tính bảng Samsung Galaxy Tab trắng',
    // Áo nữ / Đầm ngắn (162-166)
    162: 'Đầm tay ngắn màu xanh',
    163: 'Đầm mùa hè nữ',
    164: 'Đầm màu xám thời trang',
    165: 'Đầm ngắn dễ thương',
    166: 'Đầm kẻ caro thời trang',
    // Xe cộ (167-171)
    167: 'Xe Chrysler 300 Touring',
    168: 'Xe Dodge Charger SXT',
    169: 'Xe SUV Dodge Hornet GT Plus',
    170: 'Xe SUV Dodge Durango SXT',
    171: 'Xe MPV Chrysler Pacifica Touring',
    // Túi nữ (172-176)
    172: 'Túi xách nữ màu xanh da trời',
    173: 'Túi da nữ Heshe cao cấp',
    174: 'Túi xách nữ Prada',
    175: 'Balo nữ da PU màu trắng',
    176: 'Túi xách nữ màu đen thanh lịch',
    // Đầm nữ (177-181)
    177: 'Đầm dạ hội nữ màu đen',
    178: 'Áo corset da kèm chân váy',
    179: 'Áo corset kèm chân váy đen',
    180: 'Đầm nữ họa tiết hạt đậu',
    181: 'Bộ vest đỏ đen Marni',
    // Trang sức nữ (182-184)
    182: 'Khuyên tai đá pha lê xanh',
    183: 'Bông tai elip xanh thời trang',
    184: 'Bông tai chủ đề nhiệt đới',
    // Giày nữ (185-189)
    185: 'Dép nữ đen nâu thoải mái',
    186: 'Giày cao gót Calvin Klein',
    187: 'Giày nữ màu vàng thời trang',
    188: 'Giày nữ Pampi phong cách',
    189: 'Giày nữ màu đỏ quyến rũ',
    // Đồng hồ nữ (190-194)
    190: 'Đồng hồ nữ IWC Ingenieur tự động thép',
    191: 'Đồng hồ nữ Rolex Cellini Moonphase',
    192: 'Đồng hồ nữ Rolex Datejust',
    193: 'Đồng hồ nữ mạ vàng sang trọng',
    194: 'Đồng hồ đeo tay nữ thời trang',
  };

  static const Map<String, String> _categoryDescriptionVi = {
    'beauty':
        'Sản phẩm làm đẹp chất lượng cao giúp tôn lên vẻ đẹp tự nhiên, an toàn cho da, phù hợp sử dụng hằng ngày.',
    'fragrances':
        'Nước hoa hương thơm lưu lâu, quyến rũ và sang trọng, phù hợp cho mọi dịp.',
    'furniture':
        'Nội thất cao cấp với thiết kế sang trọng, chất liệu bền bỉ, mang lại không gian sống đẳng cấp.',
    'groceries':
        'Thực phẩm tươi sạch, đảm bảo vệ sinh an toàn thực phẩm, được chọn lọc kỹ lưỡng cho sức khỏe cả gia đình.',
    'home-decoration':
        'Vật trang trí nội thất đẹp mắt, giúp không gian sống thêm ấm cúng và cá tính.',
    'kitchen-accessories':
        'Dụng cụ nhà bếp tiện dụng, chất liệu an toàn, giúp việc nấu ăn trở nên dễ dàng và thú vị hơn.',
    'laptops':
        'Laptop hiệu năng cao, thiết kế mỏng nhẹ, đáp ứng tốt nhu cầu làm việc, học tập và giải trí.',
    'mens-shirts':
        'Áo nam chất liệu mềm mại, thoáng khí, kiểu dáng hiện đại và dễ phối đồ.',
    'mens-shoes':
        'Giày nam thiết kế thời trang, đế êm ái, phù hợp cho nhiều hoạt động khác nhau.',
    'mens-watches':
        'Đồng hồ nam thiết kế tinh tế, chính xác cao, tôn lên phong cách sang trọng.',
    'mobile-accessories':
        'Phụ kiện điện thoại chất lượng cao, bảo vệ thiết bị và nâng cao trải nghiệm sử dụng.',
    'motorcycle':
        'Xe/phụ kiện xe máy cao cấp, bền bỉ, đảm bảo an toàn khi lái xe.',
    'skin-care':
        'Sản phẩm chăm sóc da từ thiên nhiên, dưỡng ẩm và bảo vệ da hiệu quả, an toàn cho mọi loại da.',
    'smartphones':
        'Điện thoại thông minh cấu hình mạnh, camera sắc nét, pin bền, màn hình đẹp.',
    'sports-accessories':
        'Dụng cụ thể thao chất lượng cao, bền chắc, phù hợp cho nhiều môn thể thao.',
    'sunglasses':
        'Kính mát thời trang, chống tia UV400, bảo vệ mắt và tôn lên phong cách.',
    'tablets':
        'Máy tính bảng hiển thị sắc nét, hiệu năng mượt mà, phù hợp học tập và giải trí.',
    'tops':
        'Áo/đầm nữ thiết kế thời trang, chất liệu mềm nhẹ, phù hợp nhiều dịp khác nhau.',
    'vehicle':
        'Xe hơi thiết kế hiện đại, nội thất tiện nghi, vận hành êm ái và an toàn.',
    'womens-bags':
        'Túi nữ thiết kế sang trọng, chất liệu cao cấp, phù hợp nhiều phong cách thời trang.',
    'womens-dresses':
        'Váy/đầm nữ thiết kế thanh lịch, chất vải mềm nhẹ, tôn dáng và phù hợp nhiều dịp.',
    'womens-jewellery':
        'Trang sức nữ thiết kế tinh xảo, sang trọng, phù hợp sử dụng hằng ngày và dịp đặc biệt.',
    'womens-shoes':
        'Giày nữ thiết kế thời trang, êm ái, tôn dáng và phù hợp nhiều phong cách.',
    'womens-watches':
        'Đồng hồ nữ thiết kế nữ tính, sang trọng, phù hợp với phong cách hiện đại.',
  };

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

  void _openChatSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ProductChatSheet(product: product),
    );
  }

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
              width: 84,
              child: Center(
                child: IconButton(
                  icon: const Icon(Icons.chat_bubble_outline),
                  onPressed: () => _openChatSheet(context),
                  color: Colors.grey.shade700,
                  tooltip: 'Chat với shop',
                ),
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

class _ProductChatSheet extends StatefulWidget {
  final Product product;

  const _ProductChatSheet({required this.product});

  @override
  State<_ProductChatSheet> createState() => _ProductChatSheetState();
}

class _ProductChatSheetState extends State<_ProductChatSheet> {
  static const List<String> _quickQuestions = [
    'Sản phẩm có còn hàng?',
    'Sản phẩm có giá bao nhiêu?',
    'Sản phẩm có giao nhanh không?',
    'Sản phẩm có được kiểm hàng không?',
  ];

  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFocusNode = FocusNode();
  final List<_ChatMessage> _messages = [
    _ChatMessage(
      sender: _ChatSender.shop,
      text: 'Xin chào, shop có thể hỗ trợ gì cho bạn về sản phẩm này?',
    ),
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _messageFocusNode.dispose();
    super.dispose();
  }

  void _prefillMessage(String text) {
    _messageController
      ..text = text
      ..selection = TextSelection.collapsed(offset: text.length);
    _messageFocusNode.requestFocus();
  }

  void _sendMessage(String text) {
    final message = text.trim();
    if (message.isEmpty) return;

    setState(() {
      _messages.add(_ChatMessage(sender: _ChatSender.user, text: message));
      _messages.add(
        _ChatMessage(sender: _ChatSender.shop, text: _buildAutoReply(message)),
      );
    });

    _messageController.clear();
  }

  String _buildAutoReply(String message) {
    final normalized = message.toLowerCase();
    if (normalized.contains('còn hàng')) {
      return 'Dạ còn bạn nhé. Shop hiện vẫn đang có sẵn sản phẩm này.';
    }
    if (normalized.contains('giá')) {
      return 'Dạ giá hiện tại của sản phẩm là ${Formatters.currency(widget.product.price)}.';
    }
    if (normalized.contains('giao nhanh')) {
      return 'Dạ shop có hỗ trợ giao nhanh tùy khu vực. Bạn đặt hàng sớm để shop xử lý ngay.';
    }
    if (normalized.contains('kiểm hàng')) {
      return 'Dạ bạn có thể kiểm tra ngoại quan sản phẩm theo chính sách của đơn vị vận chuyển.';
    }
    return 'Dạ shop đã nhận được tin nhắn. Shop sẽ phản hồi chi tiết cho bạn sớm nhất.';
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(16, 14, 16, bottomInset + 16),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: const Color(0xFFFFF0EC),
                  child: Icon(
                    Icons.storefront_outlined,
                    color: Colors.orange.shade700,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Chat với shop',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Hỏi nhanh về: ${localizedProductTitle(widget.product)}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _quickQuestions
                    .map(
                      (question) => ActionChip(
                        label: Text(question),
                        onPressed: () => _prefillMessage(question),
                        backgroundColor: const Color(0xFFFFF0EC),
                        labelStyle: const TextStyle(
                          color: Color(0xFFEE4D2D),
                          fontWeight: FontWeight.w600,
                        ),
                        side: BorderSide.none,
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 280),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: _messages.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    final isUser = message.sender == _ChatSender.user;
                    return Align(
                      alignment: isUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.72,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isUser
                              ? const Color(0xFFEE4D2D)
                              : const Color(0xFFF6F6F6),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          message.text,
                          style: TextStyle(
                            color: isUser ? Colors.white : Colors.black87,
                            height: 1.4,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    focusNode: _messageFocusNode,
                    textInputAction: TextInputAction.send,
                    onSubmitted: _sendMessage,
                    decoration: InputDecoration(
                      hintText: 'Nhập tin nhắn cho shop',
                      filled: true,
                      fillColor: const Color(0xFFF7F7F7),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  height: 48,
                  width: 48,
                  child: ElevatedButton(
                    onPressed: () => _sendMessage(_messageController.text),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEE4D2D),
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Icon(Icons.send_rounded, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

enum _ChatSender { shop, user }

class _ChatMessage {
  final _ChatSender sender;
  final String text;

  const _ChatMessage({required this.sender, required this.text});
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
