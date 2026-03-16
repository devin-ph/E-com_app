import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../models/product.dart';
import '../utils/formatters.dart';
import '../utils/product_localization.dart';
import '../utils/product_navigation_cache.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  final double imageHeight;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    required this.imageHeight,
  });

  List<_CardTag> _buildTags() {
    final tags = <_CardTag>[
      const _CardTag(
        label: 'Chính hãng',
        background: Color(0xFFEE4D2D),
        foreground: Colors.white,
      ),
      _CardTag(
        label: product.rating >= 4.5
            ? 'Yêu thích'
            : 'Giảm ${product.discountTag.replaceFirst('-', '')}',
        background: const Color(0xFFFFF0EC),
        foreground: const Color(0xFFEE4D2D),
      ),
    ];

    if (product.rating >= 4.7) {
      tags.add(
        const _CardTag(
          label: 'Nổi bật',
          background: Color(0xFFFFF7D6),
          foreground: Color(0xFF9C6B00),
        ),
      );
    }

    return tags;
  }

  @override
  Widget build(BuildContext context) {
    final tags = _buildTags();

    return GestureDetector(
      onTap: () {
        ProductNavigationCache.lastSelectedProduct = product;
        onTap();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(18),
              ),
              child: Stack(
                children: [
                  Hero(
                    tag: 'product_${product.id}',
                    child: CachedNetworkImage(
                      imageUrl: product.image,
                      height: imageHeight,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Container(
                          height: imageHeight,
                          color: Colors.white,
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        height: imageHeight,
                        color: Colors.grey.shade100,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.broken_image_outlined,
                          size: 40,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.58),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        'Giảm ${product.discountTag.replaceFirst('-', '')}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.92),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: Color(0xFFFFB300),
                            size: 14,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            product.rating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF333333),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: tags
                        .map(
                          (tag) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: tag.background,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              tag.label,
                              style: TextStyle(
                                color: tag.foreground,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    localizedProductTitle(product),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.35,
                      color: Color(0xFF222222),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    Formatters.currency(product.price),
                    style: const TextStyle(
                      color: Color(0xFFEE4D2D),
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          Formatters.currency(product.originalPrice),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 11,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ),
                      Text(
                        Formatters.usd(product.price),
                        style: const TextStyle(
                          color: Color(0xFF8A8A8A),
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.local_shipping_outlined,
                        size: 13,
                        color: Color(0xFF7A7A7A),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          product.soldDisplay,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF7A7A7A),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
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

class _CardTag {
  final String label;
  final Color background;
  final Color foreground;

  const _CardTag({
    required this.label,
    required this.background,
    required this.foreground,
  });
}
