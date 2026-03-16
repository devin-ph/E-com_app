import 'package:flutter/material.dart';
import '../../../models/category.dart';

class CategoryRow extends StatefulWidget {
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  const CategoryRow({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  State<CategoryRow> createState() => _CategoryRowState();
}

class _CategoryRowState extends State<CategoryRow> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    const double itemsPerRow = 3.6;
    const double horizontalPadding = 24;
    const double spacing = 12;

    final double itemWidth =
        (screenWidth - horizontalPadding - (spacing * (itemsPerRow - 1))) /
        itemsPerRow;

    const double gridHeight = 216;
    const double verticalPadding = 8;

    const double itemHeight = (gridHeight - verticalPadding - spacing) / 2;

    final double responsiveAspectRatio = itemHeight / itemWidth;

    return SizedBox(
      height: gridHeight,
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: GridView.builder(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(12, 4, 12, 14),
          itemCount: kCategories.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: spacing,
            crossAxisSpacing: spacing,
            childAspectRatio: responsiveAspectRatio,
          ),
          itemBuilder: (context, index) {
            final cat = kCategories[index];
            final isSelected = widget.selectedCategory == cat.apiCategory;
            return Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(22),
                onTap: () => widget.onCategorySelected(cat.apiCategory),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: isSelected ? cat.color : Colors.grey.shade200,
                      width: isSelected ? 1.8 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: cat.color.withValues(
                          alpha: isSelected ? 0.18 : 0.06,
                        ),
                        blurRadius: 18,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? cat.color
                              : cat.color.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          cat.icon,
                          color: isSelected ? Colors.white : cat.color,
                          size: 22,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Expanded(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            cat.name,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 10,
                              height: 1.1,
                              color: isSelected
                                  ? cat.color
                                  : const Color(0xFF333333),
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
