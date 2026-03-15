import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import '../../../providers/product_provider.dart';
import '../../../widgets/product_card.dart';
import '../../../widgets/product_grid_shimmer.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.products.isEmpty) {
          return const SliverToBoxAdapter(child: ProductGridShimmer());
        }

        if (provider.error != null && provider.products.isEmpty) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.wifi_off, size: 48, color: Colors.grey),
                    const SizedBox(height: 12),
                    Text(
                      'Không thể tải sản phẩm\n${provider.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => provider.loadProducts(refresh: true),
                      child: const Text('Thử lại'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        if (provider.products.isEmpty) {
          return const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Text(
                'Chưa có sản phẩm phù hợp',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          );
        }

        final itemCount =
            provider.products.length +
            ((provider.isLoading && provider.products.isNotEmpty) ? 1 : 0);

        return SliverPadding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 96),
          sliver: SliverMasonryGrid.count(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childCount: itemCount,
            itemBuilder: (context, index) {
              if (index >= provider.products.length) {
                return Container(
                  height: 110,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const CircularProgressIndicator(
                    color: Color(0xFFEE4D2D),
                  ),
                );
              }

              final product = provider.products[index];
              final imageHeight = switch (index % 4) {
                0 => 188.0,
                1 => 228.0,
                2 => 204.0,
                _ => 244.0,
              };

              return ProductCard(
                product: product,
                imageHeight: imageHeight,
                onTap: () => Navigator.pushNamed(
                  context,
                  '/product-detail',
                  arguments: product,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
