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

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as Product;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // SliverAppBar with image carousel
          SliverAppBar(
            pinned: true,
            expandedHeight: 320,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87,
            actions: const [CartIconButton(iconColor: Colors.black87)],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  // Image slider
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 360,
                      viewportFraction: 1,
                      onPageChanged: (index, _) {
                        setState(() => _imageIndex = index);
                      },
                    ),
                    items: product.images.map((imgUrl) {
                      return Hero(
                        tag: 'product_${product.id}',
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
                  // Dot indicator
                  Positioned(
                    bottom: 12,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: AnimatedSmoothIndicator(
                        activeIndex: _imageIndex,
                        count: product.images.length,
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
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price block
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        Formatters.currency(product.price),
                        style: const TextStyle(
                          color: Color(0xFFEE4D2D),
                          fontSize: 24,
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
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEE4D2D),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          product.discountTag,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Title
                  Text(
                    product.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Rating & Sold
                  Row(
                    children: [
                      const Icon(Icons.star,
                          color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${product.rating.toStringAsFixed(1)} (${product.ratingCount} đánh giá)',
                        style: const TextStyle(
                            color: Colors.grey, fontSize: 13),
                      ),
                      const Spacer(),
                      Text(
                        product.soldDisplay,
                        style: const TextStyle(
                            color: Colors.grey, fontSize: 13),
                      ),
                    ],
                  ),
                  const Divider(height: 24),

                  // Variations section (tappable)
                  InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => AddToCartBottomSheet.show(context, product),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade200),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.palette_outlined,
                              color: Colors.grey, size: 20),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Text(
                              'Chọn Kích cỡ, Màu sắc',
                              style: TextStyle(
                                  fontSize: 14, color: Colors.black87),
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios,
                              color: Colors.grey.shade500, size: 14),
                        ],
                      ),
                    ),
                  ),
                  const Divider(height: 24),

                  // Description
                  const Text(
                    'Mô tả sản phẩm',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 8),
                  AnimatedCrossFade(
                    firstChild: Text(
                      product.description,
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.black87,
                          height: 1.6,
                          fontSize: 13),
                    ),
                    secondChild: Text(
                      product.description,
                      style: const TextStyle(
                          color: Colors.black87,
                          height: 1.6,
                          fontSize: 13),
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
                  const SizedBox(height: 100), // bottom bar clearance
                ],
              ),
            ),
          ),
        ],
      ),
      // Bottom navigation bar
      bottomNavigationBar: _BottomActionBar(product: product),
    );
  }
}

class _BottomActionBar extends StatelessWidget {
  final Product product;

  const _BottomActionBar({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Left side icons
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
                    onPressed: () =>
                        Navigator.pushNamed(context, '/cart'),
                    color: Colors.grey.shade700,
                  ),
                ],
              ),
            ),
            const VerticalDivider(width: 1),
            // Right: Add to cart + Buy now
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => AddToCartBottomSheet.show(
                          context, product),
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
                          context, product,
                          buyNow: true),
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
