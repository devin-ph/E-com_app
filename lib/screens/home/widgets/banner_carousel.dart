import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

const List<String> _bannerUrls = [
  'https://img.freepik.com/free-vector/flat-sale-banner-template_23-2149023625.jpg',
  'https://img.freepik.com/free-vector/flat-super-sale-banner_23-2149149817.jpg',
  'https://img.freepik.com/free-vector/online-shopping-banner-template_23-2149123610.jpg',
  'https://img.freepik.com/free-vector/gradient-sale-background-discount_23-2149123590.jpg',
];

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
            height: 160,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            enlargeCenterPage: true,
            viewportFraction: 0.92,
            onPageChanged: (index, _) {
              setState(() => _current = index);
            },
          ),
          items: _bannerUrls.map((url) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                url,
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stack) => Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.orange.shade400, Colors.red.shade400],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      'SALE ĐẬM\nGIẢM ĐẾN 70%',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        AnimatedSmoothIndicator(
          activeIndex: _current,
          count: _bannerUrls.length,
          effect: const WormEffect(
            dotWidth: 8,
            dotHeight: 8,
            activeDotColor: Color(0xFFEE4D2D),
            dotColor: Colors.grey,
          ),
        ),
      ],
    );
  }
}
