import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../providers/cart_provider.dart';
import '../../models/cart_item.dart';
import '../../utils/formatters.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<CartProvider>(
          builder: (context, cart, _) => Text(
            'Giỏ hàng (${cart.itemCount})',
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Đơn mua',
            icon: const Icon(Icons.receipt_long_outlined),
            onPressed: () => Navigator.pushNamed(context, '/orders'),
          ),
        ],
        backgroundColor: const Color(0xFFEE4D2D),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          if (cart.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_cart_outlined,
                      size: 80, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'Giỏ hàng của bạn đang trống',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEE4D2D),
                    ),
                    child: const Text('Tiếp tục mua sắm',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final item = cart.items[index];
                    return _CartItemTile(item: item);
                  },
                ),
              ),
              _CartBottomBar(),
            ],
          );
        },
      ),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  final CartItem item;

  const _CartItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final cart = context.read<CartProvider>();

    return Dismissible(
      key: Key(item.key),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delete_outline, color: Colors.white, size: 28),
            Text('Xóa', style: TextStyle(color: Colors.white, fontSize: 12)),
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Xóa sản phẩm'),
            content: const Text('Bạn có muốn xóa sản phẩm này khỏi giỏ hàng không?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Hủy'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Xóa',
                    style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ) ?? false;
      },
      onDismissed: (_) => cart.removeItem(item.key),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Checkbox
            Padding(
              padding: const EdgeInsets.only(top: 12, left: 4),
              child: Checkbox(
                value: item.isChecked,
                activeColor: const Color(0xFFEE4D2D),
                onChanged: (value) =>
                    cart.toggleItem(item.key, value ?? false),
              ),
            ),
            // Product image
            Padding(
              padding: const EdgeInsets.all(8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: item.product.image,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  placeholder: (_, _) => Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey.shade200,
                  ),
                  errorWidget: (_, _, _) => const Icon(
                      Icons.broken_image_outlined,
                      size: 40,
                      color: Colors.grey),
                ),
              ),
            ),
            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 12, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.product.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 4),
                    // Variation tags
                    Row(
                      children: [
                        _Tag('Kích cỡ: ${item.size}'),
                        const SizedBox(width: 4),
                        _Tag('Màu: ${item.color}'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Price & Quantity
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          Formatters.currency(item.product.price),
                          style: const TextStyle(
                            color: Color(0xFFEE4D2D),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        _QuantityControl(item: item),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;

  const _Tag(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(label,
          style: const TextStyle(fontSize: 11, color: Colors.black54)),
    );
  }
}

class _QuantityControl extends StatelessWidget {
  final CartItem item;

  const _QuantityControl({required this.item});

  @override
  Widget build(BuildContext context) {
    final cart = context.read<CartProvider>();

    return Row(
      children: [
        _SmallBtn(
          icon: Icons.remove,
          onTap: () async {
            if (item.quantity <= 1) {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Xóa sản phẩm'),
                  content: const Text(
                      'Số lượng về 0. Bạn có muốn xóa sản phẩm không?'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text('Hủy')),
                    TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text('Xóa',
                            style: TextStyle(color: Colors.red))),
                  ],
                ),
              );
              if (confirmed == true) cart.removeItem(item.key);
            } else {
              cart.updateQuantity(item.key, -1);
            }
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text('${item.quantity}',
              style: const TextStyle(
                  fontSize: 14, fontWeight: FontWeight.bold)),
        ),
        _SmallBtn(
          icon: Icons.add,
          onTap: () => cart.updateQuantity(item.key, 1),
        ),
      ],
    );
  }
}

class _SmallBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _SmallBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Icon(icon, size: 16, color: Colors.black87),
      ),
    );
  }
}

class _CartBottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
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
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  // Select all checkbox
                  Checkbox(
                    value: cart.allChecked,
                    tristate: false,
                    activeColor: const Color(0xFFEE4D2D),
                    onChanged: (value) =>
                        cart.toggleSelectAll(value ?? false),
                  ),
                  const Text('Chọn tất cả',
                      style: TextStyle(fontSize: 13)),
                  const Spacer(),
                  // Total
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Tổng thanh toán:',
                          style: TextStyle(
                              fontSize: 11, color: Colors.grey)),
                      Text(
                        Formatters.currency(cart.totalPrice),
                        style: const TextStyle(
                          color: Color(0xFFEE4D2D),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  // Checkout button
                  ElevatedButton(
                    onPressed: cart.checkedItems.isEmpty
                        ? null
                        : () {
                            Navigator.pushNamed(
                              context,
                              '/checkout',
                              arguments: cart.checkedItems,
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEE4D2D),
                      disabledBackgroundColor: Colors.grey.shade300,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                    child: Text(
                      'Thanh toán (${cart.checkedItems.length})',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
