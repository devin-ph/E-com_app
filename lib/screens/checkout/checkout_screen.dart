import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/cart_item.dart';
import '../../providers/cart_provider.dart';
import '../../providers/order_provider.dart';
import '../../utils/formatters.dart';
import '../../utils/product_localization.dart';
import '../../utils/product_variant_labels.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  String _paymentMethod = 'COD';
  bool _isPlacing = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = ModalRoute.of(context)!.settings.arguments as List<CartItem>;
    final totalAmount = items.fold<double>(
      0,
      (sum, item) => sum + item.subtotal,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Thanh toán',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFEE4D2D),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Delivery address card
            _SectionCard(
              title: 'Địa chỉ nhận hàng',
              icon: Icons.location_on_outlined,
              child: Column(
                children: [
                  _FormField(
                    controller: _nameController,
                    label: 'Họ tên người nhận',
                    icon: Icons.person_outline,
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Vui lòng nhập họ tên' : null,
                  ),
                  const SizedBox(height: 12),
                  _FormField(
                    controller: _phoneController,
                    label: 'Số điện thoại',
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    validator: (v) => v == null || v.length < 9
                        ? 'Số điện thoại không hợp lệ'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  _FormField(
                    controller: _addressController,
                    label: 'Địa chỉ chi tiết',
                    icon: Icons.home_outlined,
                    maxLines: 1,
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Vui lòng nhập địa chỉ' : null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Payment method card
            _SectionCard(
              title: 'Phương thức thanh toán',
              icon: Icons.payment_outlined,
              child: Column(
                children: [
                  _PaymentOption(
                    value: 'COD',
                    groupValue: _paymentMethod,
                    label: 'Thanh toán khi nhận hàng (COD)',
                    icon: Icons.local_shipping_outlined,
                    onChanged: (v) =>
                        setState(() => _paymentMethod = v ?? 'COD'),
                  ),
                  const Divider(height: 1),
                  _PaymentOption(
                    value: 'MoMo',
                    groupValue: _paymentMethod,
                    label: 'Ví MoMo',
                    icon: Icons.account_balance_wallet_outlined,
                    iconColor: Colors.pink,
                    onChanged: (v) =>
                        setState(() => _paymentMethod = v ?? 'COD'),
                  ),
                  const Divider(height: 1),
                  _PaymentOption(
                    value: 'Banking',
                    groupValue: _paymentMethod,
                    label: 'Chuyển khoản ngân hàng',
                    icon: Icons.account_balance_outlined,
                    iconColor: Colors.blue,
                    onChanged: (v) =>
                        setState(() => _paymentMethod = v ?? 'COD'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Order summary
            _SectionCard(
              title: 'Sản phẩm đặt mua',
              icon: Icons.shopping_bag_outlined,
              child: Column(
                children: [
                  ...items.map(
                    (item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  localizedProductTitle(item.product),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 13),
                                ),
                                Text(
                                  [
                                    if (sizeLabel(item) != null) sizeLabel(item)!,
                                    if (colorLabel(item) != null) colorLabel(item)!,
                                    'x${item.quantity}',
                                  ].join(' · '),
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            Formatters.currency(item.subtotal),
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFEE4D2D),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Tổng cộng:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        Formatters.currency(totalAmount),
                        style: const TextStyle(
                          color: Color(0xFFEE4D2D),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: _buildPlaceOrderButton(context, items, totalAmount),
    );
  }

  Widget _buildPlaceOrderButton(
    BuildContext context,
    List<CartItem> items,
    double total,
  ) {
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
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tổng tiền',
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                  Text(
                    Formatters.currency(total),
                    style: const TextStyle(
                      color: Color(0xFFEE4D2D),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _isPlacing
                      ? null
                      : () => _placeOrder(context, items),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEE4D2D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: _isPlacing
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'ĐẶT HÀNG',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _placeOrder(BuildContext context, List<CartItem> items) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isPlacing = true);

    // Save providers before async gap
    final orderProvider = context.read<OrderProvider>();
    final cartProvider = context.read<CartProvider>();
    final navigator = Navigator.of(context);

    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;

    final address =
        '${_nameController.text} - ${_phoneController.text}\n${_addressController.text}';

    orderProvider.placeOrder(
      items: items,
      address: address,
      paymentMethod: _paymentMethod,
    );
    cartProvider.removeCheckedItems();

    setState(() => _isPlacing = false);

    await showDialog<void>(
      context: navigator.context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: Color(0xFF2E7D32),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 40),
            ),
            const SizedBox(height: 16),
            const Text(
              'Đặt hàng thành công!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Đơn hàng của bạn đã được tiếp nhận.\nCảm ơn bạn đã mua sắm!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              navigator.popUntil((route) => route.settings.name == '/');
            },
            child: const Text(
              'Về trang chủ',
              style: TextStyle(color: Color(0xFFEE4D2D)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              navigator.popUntil((route) => route.settings.name == '/');
              navigator.pushNamed('/orders');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEE4D2D),
            ),
            child: const Text(
              'Xem đơn hàng',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: const Color(0xFFEE4D2D), size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _FormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType keyboardType;
  final int maxLines;
  final String? Function(String?)? validator;

  const _FormField({
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFEE4D2D)),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 12,
        ),
      ),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final String value;
  final String groupValue;
  final String label;
  final IconData icon;
  final Color? iconColor;
  final ValueChanged<String?> onChanged;

  const _PaymentOption({
    required this.value,
    required this.groupValue,
    required this.label,
    required this.icon,
    this.iconColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;
    return InkWell(
      onTap: () => onChanged(value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            // Custom radio circle (avoids deprecated Radio API)
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFFEE4D2D)
                      : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFEE4D2D),
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 10),
            Icon(icon, size: 20, color: iconColor ?? Colors.grey),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
