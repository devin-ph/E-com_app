import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;
import '../providers/cart_provider.dart';

class CartIconButton extends StatelessWidget {
  final Color? iconColor;

  const CartIconButton({super.key, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        return badges.Badge(
          position: badges.BadgePosition.topEnd(top: 0, end: 3),
          showBadge: cart.itemCount > 0,
          badgeContent: Text(
            '${cart.itemCount}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          badgeStyle: const badges.BadgeStyle(
            badgeColor: Color(0xFFEE4D2D),
            padding: EdgeInsets.all(4),
          ),
          child: IconButton(
            icon: Icon(
              Icons.shopping_cart_outlined,
              color: iconColor ?? Colors.white,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
          ),
        );
      },
    );
  }
}
