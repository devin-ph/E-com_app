import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

const List<_BannerData> _banners = [
  _BannerData(
    imageUrl:
        'https://images.unsplash.com/photo-1523381210434-271e8be1f52b?auto=format&fit=crop&w=1200&q=80',
    title: 'Flash Sale 0H',
    subtitle: 'Deal thời trang giảm tới 50%',
  ),
  _BannerData(
    imageUrl:
        'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=1200&q=80',
    title: 'Công Nghệ Hot',
    subtitle: 'Điện thoại, tai nghe freeship toàn quốc',
  ),
  _BannerData(
    imageUrl:
        'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?auto=format&fit=crop&w=1200&q=80',
    title: 'Mall Voucher',
    subtitle: 'Săn mã hoàn xu cho đơn hàng hôm nay',
  ),
  _BannerData(
    imageUrl:
        'https://images.unsplash.com/photo-1483985988355-763728e1935b?auto=format&fit=crop&w=1200&q=80',
    title: 'Daily Discover',
    subtitle: 'Khám phá sản phẩm nổi bật mỗi ngày',
  ),
];

class _BannerData {
  final String imageUrl;
  final String title;
  final String subtitle;

  const _BannerData({
    required this.imageUrl,
    required this.title,
    required this.subtitle,
  });
}

class BannerCarousel extends StatefulWidget {
  const BannerCarousel({super.key});

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 176,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 750),
            enlargeCenterPage: true,
            enlargeStrategy: CenterPageEnlargeStrategy.zoom,
            viewportFraction: 0.9,
            onPageChanged: (index, _) {
              setState(() => _current = index);
            },
          ),
          items: _banners.map((banner) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: banner.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          Container(color: const Color(0xFFFFF1EB)),
                      errorWidget: (context, url, error) => Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFFFF8A65), Color(0xFFEE4D2D)],
                          ),
                        ),
                      ),
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.08),
                            Colors.black.withValues(alpha: 0.55),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.16),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: const Text(
                              'Ưu đãi hôm nay',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            banner.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              height: 1.1,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            banner.subtitle,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              height: 1.35,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        AnimatedSmoothIndicator(
          activeIndex: _current,
          count: _banners.length,
          effect: const WormEffect(
            dotWidth: 18,
            dotHeight: 8,
            activeDotColor: Color(0xFFEE4D2D),
            dotColor: Color(0xFFD7D7D7),
          ),
        ),
      ],
    );
  }
}
