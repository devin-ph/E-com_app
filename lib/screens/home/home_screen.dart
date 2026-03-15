import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import '../../widgets/cart_icon_button.dart';
import 'widgets/banner_carousel.dart';
import 'widgets/category_row.dart';
import 'widgets/product_grid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const Color _primaryColor = Color(0xFFEE4D2D);

  final TextEditingController _searchController = TextEditingController();
  late ScrollController _outerScrollController;
  bool _searchBarCollapsed = false;

  @override
  void initState() {
    super.initState();
    _outerScrollController = ScrollController();
    _outerScrollController.addListener(() {
      final collapsed = _outerScrollController.offset > 80;
      if (collapsed != _searchBarCollapsed) {
        setState(() => _searchBarCollapsed = collapsed);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().loadProducts(refresh: true);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _outerScrollController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await context.read<ProductProvider>().loadProducts(refresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: NestedScrollView(
        controller: _outerScrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: true,
              floating: true,
              snap: true,
              backgroundColor: _primaryColor,
              expandedHeight: 120,
              forceElevated: innerBoxIsScrolled,
              title: const Text(
                'TH4 - Nhóm 1',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              actions: [
                const CartIconButton(),
                IconButton(
                  icon: const Icon(Icons.notifications_outlined,
                      color: Colors.white),
                  onPressed: () {},
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: Container(
                  color: _primaryColor,
                  alignment: Alignment.bottomCenter,
                  padding:
                      const EdgeInsets.fromLTRB(12, 0, 12, 8),
                  child: const SizedBox.shrink(),
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(48),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  color: _searchBarCollapsed
                      ? _primaryColor
                      : Colors.transparent,
                  padding:
                      const EdgeInsets.fromLTRB(12, 4, 12, 8),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Tìm kiếm sản phẩm...',
                      prefixIcon: const Icon(Icons.search,
                          color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (value) {
                      // Search filtering is a bonus feature
                    },
                  ),
                ),
              ),
            ),
          ];
        },
        body: RefreshIndicator(
          color: _primaryColor,
          onRefresh: _onRefresh,
          child: CustomScrollView(
            slivers: [
              // Banner carousel
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: BannerCarousel(),
                ),
              ),
              // Section title: Categories
              const SliverToBoxAdapter(
                child: Padding(
                  padding:
                      EdgeInsets.fromLTRB(12, 16, 12, 8),
                  child: Text(
                    'Danh mục sản phẩm',
                    style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              // Category filter row
              SliverToBoxAdapter(
                child: Consumer<ProductProvider>(
                  builder: (context, provider, _) => CategoryRow(
                    selectedCategory: provider.selectedCategory,
                    onCategorySelected: (cat) =>
                        provider.setCategory(cat),
                  ),
                ),
              ),
              // Section title: Daily Discover
              const SliverToBoxAdapter(
                child: Padding(
                  padding:
                      EdgeInsets.fromLTRB(12, 16, 12, 10),
                  child: Row(
                    children: [
                      Icon(Icons.local_fire_department,
                          color: Color(0xFFEE4D2D)),
                      SizedBox(width: 6),
                      Text(
                        'Gợi ý hôm nay',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              // Product grid
              const SliverFillRemaining(
                hasScrollBody: true,
                child: ProductGrid(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
