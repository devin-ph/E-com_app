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
  late final ScrollController _scrollController;
  bool _searchBarCollapsed = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_handleScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().loadProducts(refresh: true);
    });
  }

  void _handleScroll() {
    if (!_scrollController.hasClients) {
      return;
    }

    final collapsed = _scrollController.offset > 72;
    if (collapsed != _searchBarCollapsed && mounted) {
      setState(() => _searchBarCollapsed = collapsed);
    }

    final provider = context.read<ProductProvider>();
    if (_scrollController.position.extentAfter < 600 &&
        !provider.isLoading &&
        provider.hasMore) {
      provider.loadProducts();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController
      ..removeListener(_handleScroll)
      ..dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await context.read<ProductProvider>().loadProducts(refresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: RefreshIndicator(
        color: _primaryColor,
        onRefresh: _onRefresh,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: _primaryColor,
              expandedHeight: 132,
              elevation: 0,
              titleSpacing: 16,
              title: const Text(
                'TH4 - Nhóm 1',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
              actions: [
                const CartIconButton(),
                IconButton(
                  icon: const Icon(
                    Icons.notifications_none_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () {},
                ),
                const SizedBox(width: 6),
              ],
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFFFF784E), Color(0xFFEE4D2D)],
                        ),
                      ),
                    ),
                    Positioned(
                      top: -28,
                      right: -20,
                      child: Container(
                        width: 118,
                        height: 118,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -36,
                      left: -12,
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(62),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  color: _searchBarCollapsed ? _primaryColor : Colors.transparent,
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: _searchBarCollapsed ? 0.12 : 0.05,
                          ),
                          blurRadius: _searchBarCollapsed ? 16 : 10,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        hintText: 'Tìm ki?m s?n ph?m, thuong hi?u, uu dãi...',
                        hintStyle: const TextStyle(
                          color: Color(0xFF9A9A9A),
                          fontSize: 14,
                        ),
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: Color(0xFF666666),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.tune_rounded,
                            color: Color(0xFF666666),
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (_) {},
                    ),
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
                child: BannerCarousel(),
              ),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(12, 22, 12, 10),
                child: _SectionHeader(
                  title: 'Danh m?c s?n ph?m',
                  subtitle: 'Khám phá nhanh theo nhóm ngành',
                  icon: Icons.grid_view_rounded,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Consumer<ProductProvider>(
                builder: (context, provider, _) => CategoryRow(
                  selectedCategory: provider.selectedCategory,
                  onCategorySelected: provider.setCategory,
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(12, 18, 12, 10),
                child: _SectionHeader(
                  title: 'G?i ý hôm nay',
                  subtitle: 'Vu?t d? làm m?i, cu?n d? t?i thêm s?n ph?m',
                  icon: Icons.local_fire_department_rounded,
                ),
              ),
            ),
            const SliverFillRemaining(
              hasScrollBody: true,
              child: ProductGrid(),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _SectionHeader({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFFFFEFE9),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: const Color(0xFFEE4D2D)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF222222),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF777777),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
