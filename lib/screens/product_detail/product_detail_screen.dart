import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
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
  int _imageIndex = 0;
  bool _expanded = false;

  // Category metadata map for scalable rendering across many product types.
  static const Map<String, Map<String, String>> _categoryMeta = {
    "electronics": {
      "Bảo hành": "12 tháng chính hãng",
      "Loại kết nối": "Tùy mẫu sản phẩm",
      "Nguồn điện": "Theo tiêu chuẩn nhà sản xuất",
      "Tương thích": "PC, laptop và thiết bị liên quan",
      "Phụ kiện đi kèm": "Cáp/adapter cơ bản (nếu có)",
      "Xuất xứ": "Nhập khẩu",
      "Vận chuyển": "Giao nhanh toàn quốc",
    },
    "jewelery": {
      "Chất liệu": "Theo mô tả nhà bán",
      "Màu sắc": "Vàng/Vàng trắng/Bạc",
      "Phong cách": "Thanh lịch, sang trọng",
      "Dịp sử dụng": "Đi làm, dự tiệc, quà tặng",
      "Kích thước": "Nhiều cỡ, xem khi chọn phân loại",
      "Xuất xứ": "Nhập khẩu",
      "Bảo quản": "Tránh hóa chất mạnh",
    },
    "men's clothing": {
      "Chất liệu": "Vải cao cấp",
      "Kiểu dáng": "Form nam hiện đại",
      "Độ co giãn": "Co giãn nhẹ",
      "Mùa phù hợp": "Quanh năm",
      "Hướng dẫn chọn size": "Nên chọn theo bảng size",
      "Xuất xứ": "Việt Nam/Nhập khẩu",
      "Giặt ủi": "Giặt nhẹ, tránh nhiệt cao",
    },
    "women's clothing": {
      "Chất liệu": "Vải mềm, thoáng",
      "Kiểu dáng": "Nữ tính, dễ phối đồ",
      "Độ co giãn": "Co giãn nhẹ",
      "Mùa phù hợp": "Quanh năm",
      "Hướng dẫn chọn size": "Nên chọn theo bảng size",
      "Xuất xứ": "Việt Nam/Nhập khẩu",
      "Giặt ủi": "Giặt tay hoặc túi giặt",
    },
    "cosmetics": {
      "Loại da phù hợp": "Da thường đến da hỗn hợp",
      "Kết cấu": "Mỏng nhẹ, dễ thẩm thấu",
      "Cách dùng": "Sử dụng theo hướng dẫn trên bao bì",
      "Dung tích": "Theo thông tin nhà bán",
      "Xuất xứ": "Nhập khẩu",
      "Hạn sử dụng": "Xem trên bao bì",
      "Bảo quản": "Nơi khô ráo, thoáng mát",
    },
  };

  static const Map<String, String> _categoryVi = {
    'electronics': 'Đồ điện tử',
    'jewelery': 'Trang sức',
    "men's clothing": 'Thời trang nam',
    "women's clothing": 'Thời trang nữ',
    'cosmetics': 'Mỹ phẩm',
  };

  static const Map<int, Map<String, String>> _productViCopy = {
    1: {
      'title': 'Balo Fjallraven Foldsack số 1 cho laptop 15 inch',
      'description':
          'Mẫu balo tiện dụng cho nhu cầu hằng ngày và các chuyến đi bộ nhẹ. Ngăn chính có lớp đệm bảo vệ laptop đến 15 inch, chất liệu bền và thoải mái khi đeo lâu.',
    },
    2: {
      'title': 'Áo thun nam dáng ôm cao cấp tay raglan',
      'description':
          'Áo thun nam phong cách thường ngày với tay raglan tương phản và cổ henley 3 nút. Chất vải mềm, thoáng khí, phù hợp mặc hằng ngày.',
    },
    3: {
      'title': 'Áo khoác nam cotton chính hãng',
      'description':
          'Áo khoác nam cotton dày dặn, giữ ấm tốt, hoàn thiện chỉn chu. Thiết kế gọn gàng, dễ phối đồ cho nhiều hoàn cảnh sử dụng.',
    },
    4: {
      'title': 'Áo sơ mi nam casual slim fit',
      'description':
          'Áo sơ mi nam form slim fit phù hợp đi làm và đi chơi. Chất vải nhẹ, mặc thoải mái, dễ kết hợp với quần jean hoặc kaki.',
    },
    5: {
      'title': 'Vòng tay rồng bạc và vàng nguyên khối',
      'description':
          'Mẫu vòng tay phong cách cổ điển, họa tiết đầu rồng nổi bật. Hoàn thiện tinh xảo, phù hợp làm quà tặng hoặc sử dụng trong dịp đặc biệt.',
    },
    6: {
      'title': 'Nhẫn vàng nguyên khối Petite Micropave',
      'description':
          'Nhẫn vàng thiết kế thanh lịch với điểm nhấn đá nhỏ tinh tế. Phù hợp đeo hằng ngày hoặc kết hợp cùng các phụ kiện trang sức khác.',
    },
    7: {
      'title': 'Nhẫn công chúa vàng trắng',
      'description':
          'Thiết kế nữ tính với tông vàng trắng sang trọng, điểm nhấn mặt nhẫn nổi bật. Phù hợp cho các dịp trang trọng.',
    },
    8: {
      'title': 'Khuyên tai mạ vàng hồng',
      'description':
          'Khuyên tai mạ vàng hồng nhẹ nhàng, tôn nét thanh lịch. Kích thước vừa phải, dễ phối cùng nhiều phong cách trang phục.',
    },
    9: {
      'title': 'Ổ cứng di động WD 2TB USB 3.0',
      'description':
          'Ổ cứng di động dung lượng lớn, kết nối USB 3.0 cho tốc độ truyền tải ổn định. Thiết kế gọn nhẹ, tiện mang theo.',
    },
    10: {
      'title': 'Ổ cứng SSD SanDisk 1TB',
      'description':
          'SSD tốc độ cao giúp tăng hiệu năng khởi động và sao chép dữ liệu. Phù hợp nâng cấp cho máy tính cá nhân và laptop.',
    },
    11: {
      'title': 'SSD Silicon Power 256GB 3D NAND',
      'description':
          'Ổ SSD 3D NAND tối ưu độ bền và tốc độ đọc ghi, giúp hệ thống vận hành mượt mà hơn khi làm việc và giải trí.',
    },
    12: {
      'title': 'SSD WD 4TB tương thích PlayStation 5',
      'description':
          'Giải pháp mở rộng lưu trữ dung lượng lớn cho game và dữ liệu nặng. Hiệu năng ổn định, phù hợp nhu cầu giải trí cao.',
    },
    13: {
      'title': 'Màn hình gaming Acer 21.5 inch Full HD',
      'description':
          'Màn hình Full HD 21.5 inch hiển thị rõ nét, phù hợp học tập, làm việc và chơi game cơ bản. Thiết kế gọn cho bàn làm việc.',
    },
    14: {
      'title': 'Màn hình cong Samsung 49 inch siêu rộng',
      'description':
          'Màn hình cong kích thước lớn cho không gian hiển thị rộng rãi, phù hợp đa nhiệm và giải trí cao cấp.',
    },
    15: {
      'title': 'Áo khoác nữ 3-trong-1 chống gió',
      'description':
          'Áo khoác nữ thiết kế linh hoạt, có thể mặc nhiều kiểu theo thời tiết. Chất liệu nhẹ, giữ ấm và cản gió tốt.',
    },
    16: {
      'title': 'Áo khoác mô tô nữ giả da',
      'description':
          'Áo khoác phong cách cá tính với chất liệu giả da mềm, tôn dáng và dễ phối cùng quần jean, chân váy.',
    },
    17: {
      'title': 'Áo mưa nữ chống gió đi xe đạp',
      'description':
          'Thiết kế tiện dụng cho hoạt động ngoài trời, chống gió và chống bắn nước nhẹ. Form áo thoải mái khi vận động.',
    },
    18: {
      'title': 'Áo thun nữ tay ngắn cổ tròn',
      'description':
          'Áo thun nữ đơn giản, chất vải mềm và co giãn tốt. Dễ mặc hằng ngày, phù hợp nhiều hoàn cảnh.',
    },
    19: {
      'title': 'Áo thun nữ cotton cổ tim',
      'description':
          'Mẫu áo nữ basic cổ tim, chất liệu cotton thoáng mát. Tạo cảm giác dễ chịu khi mặc trong thời gian dài.',
    },
    20: {
      'title': 'Áo blouse nữ form rộng',
      'description':
          'Áo blouse nữ nhẹ nhàng, form rộng thoải mái, phù hợp đi làm hoặc dạo phố. Dễ phối với nhiều kiểu quần váy.',
    },
  };

  String _translateCategory(String category) {
    final key = category.trim().toLowerCase();
    return _categoryVi[key] ?? category;
  }

  String _fallbackTitle(Product product) {
    final category = _translateCategory(product.category);
    return 'Sản phẩm $category cao cấp';
  }

  String _fallbackDescription(Product product) {
    final category = _translateCategory(product.category);
    return 'Sản phẩm thuộc nhóm $category, thiết kế hiện đại, chất lượng tốt và phù hợp sử dụng hằng ngày.';
  }

  String _resolveTitle(Product product) {
    final manual = _productViCopy[product.id]?['title'];
    if (manual != null && manual.isNotEmpty) return manual;
    return _fallbackTitle(product);
  }

  String _resolveDescription(Product product) {
    final manual = _productViCopy[product.id]?['description'];
    if (manual != null && manual.isNotEmpty) return manual;
    return _fallbackDescription(product);
  }

  Map<String, dynamic> _buildProductPayload(Product product) {
    final normalizedCategory = product.category.toLowerCase();
    final categoryLabel = _translateCategory(product.category);
    final commonMeta = <String, String>{
      "Mã sản phẩm": "SP-${product.id.toString().padLeft(4, '0')}",
      "Danh mục": categoryLabel,
      "Giá bán": Formatters.vnd(product.price),
      "Giá niêm yết": Formatters.vnd(product.originalPrice),
      "Giảm giá": 'Giảm ${product.discountTag.replaceAll('-', '')}',
      "Đánh giá":
          '${product.rating.toStringAsFixed(1)}/5 (${product.ratingCount} lượt)',
      "Đã bán": product.soldDisplay.replaceFirst('Đã bán ', ''),
      "Tình trạng": "Còn hàng",
      "Đổi trả": "Hỗ trợ đổi trả trong 7 ngày",
      "Giao hàng": "Toàn quốc",
    };

    final fallbackCategoryMeta = <String, String>{
      "Nhóm": _translateCategory(product.category),
      "Vận chuyển": "Giao hàng toàn quốc",
      "Chính sách": "Hỗ trợ đổi trả theo điều kiện",
      "Xuất xứ": "Theo nhà cung cấp",
      "Thông tin khác": "Liên hệ shop để được tư vấn chi tiết",
    };

    final additionalInfo = <String, String>{
      ...commonMeta,
      ...(_categoryMeta[normalizedCategory] ?? fallbackCategoryMeta),
    };

    return {
      "id": product.id,
      "title": _resolveTitle(product),
      "price": product.price,
      "originalPrice": product.originalPrice,
      "priceLabel": Formatters.vnd(product.price),
      "originalPriceLabel": Formatters.vnd(product.originalPrice),
      "discountTag": 'Giảm ${product.discountTag.replaceAll('-', '')}',
      "rating": product.rating,
      "ratingCount": product.ratingCount,
      "soldDisplay": product.soldDisplay,
      "description": _resolveDescription(product),
      "category": _translateCategory(product.category),
      "images": product.images,
      "additionalInfo": additionalInfo,
    };
  }

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as Product;
    final productData = _buildProductPayload(product);
    final images = productData['images'] as List<String>;
    final additionalInfo = productData['additionalInfo'] as Map<String, String>;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: const [CartIconButton(iconColor: Colors.black87)],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image area above action buttons
            SizedBox(
              height: 320,
              child: Stack(
                children: [
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 320,
                      viewportFraction: 1,
                      onPageChanged: (index, _) {
                        setState(() => _imageIndex = index);
                      },
                    ),
                    items: images.map((imgUrl) {
                      return Hero(
                        tag: 'product_${productData['id']}',
                        child: CachedNetworkImage(
                          imageUrl: imgUrl,
                          fit: BoxFit.contain,
                          width: double.infinity,
                          placeholder: (context, url) => Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade100,
                            child: Container(color: Colors.white),
                          ),
                          errorWidget: (context, url, error) => const Icon(
                            Icons.broken_image_outlined,
                            size: 64,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  Positioned(
                    bottom: 12,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: AnimatedSmoothIndicator(
                        activeIndex: _imageIndex,
                        count: images.length,
                        effect: const WormEffect(
                          dotWidth: 8,
                          dotHeight: 8,
                          activeDotColor: Color(0xFFEE4D2D),
                          dotColor: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Action buttons directly below image
            _InlineActionButtons(product: product),

            // Product detail content directly below action buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        productData['priceLabel'] as String,
                        style: const TextStyle(
                          color: Color(0xFFEE4D2D),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        productData['originalPriceLabel'] as String,
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
                          productData['discountTag'] as String,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    productData['title'] as String,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${(productData['rating'] as double).toStringAsFixed(1)} (${productData['ratingCount']} đánh giá)',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        productData['soldDisplay'] as String,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Chip(
                    label: Text('Danh mục: ${productData['category']}'),
                    backgroundColor: Colors.orange.shade50,
                    labelStyle: const TextStyle(color: Color(0xFFEE4D2D)),
                    side: BorderSide(color: Colors.orange.shade100),
                  ),
                  const Divider(height: 28),
                  const Text(
                    'Mô tả sản phẩm',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 8),
                  AnimatedCrossFade(
                    firstChild: Text(
                      productData['description'] as String,
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.black87,
                        height: 1.6,
                        fontSize: 13,
                      ),
                    ),
                    secondChild: Text(
                      productData['description'] as String,
                      style: const TextStyle(
                        color: Colors.black87,
                        height: 1.6,
                        fontSize: 13,
                      ),
                    ),
                    crossFadeState: _expanded
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 300),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => _expanded = !_expanded),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        _expanded ? 'Thu gọn' : 'Xem thêm',
                        style: const TextStyle(
                          color: Color(0xFFEE4D2D),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const Divider(height: 28),
                  const Text(
                    'Thông tin bổ sung',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 8),
                  ...additionalInfo.entries.map(
                    (entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 110,
                            child: Text(
                              entry.key,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              entry.value,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
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

class _InlineActionButtons extends StatelessWidget {
  final Product product;

  const _InlineActionButtons({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 10, 12, 4),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SizedBox(
        height: 52,
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => AddToCartBottomSheet.show(context, product),
                      child: Container(
                        height: 52,
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
                  Container(width: 1, color: Colors.white),
                  Expanded(
                    child: InkWell(
                      onTap: () => AddToCartBottomSheet.show(
                        context,
                        product,
                        buyNow: true,
                      ),
                      child: Container(
                        height: 52,
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
