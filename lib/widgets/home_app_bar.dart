import 'package:ewire_ecommerce/core/responsive/responsive.dart';
import 'package:ewire_ecommerce/core/themes/theme_extensions.dart';
import 'package:ewire_ecommerce/providers/theme_provider.dart';
import 'package:ewire_ecommerce/providers/cart_provider.dart';
import 'package:ewire_ecommerce/screens/cart_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      titleSpacing: 16,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_getGreeting(), style: const TextStyle(fontSize: 12)),
          Text("Today's Deals", style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
      actions: [
        Consumer<ThemeProvider>(
          builder: (context, themeProvider, _) {
            return IconButton(
              onPressed: () {
                themeProvider.toggleTheme();
              },
              icon: Icon(
                themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                color: context.primary,
              ),
            );
          },
        ),
        Consumer<CartProvider>(
          builder: (context, cart, _) {
            return Badge.count(
              isLabelVisible: cart.cartCount > 0,
              count: cart.cartCount,
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartPage()),
                  );
                },
                icon: Icon(
                  Icons.shopping_cart_outlined,
                  color: context.primary,
                ),
              ),
            );
          },
        ),
        SizedBox(width: context.res.wsm),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

String _getGreeting() {
  final hour = DateTime.now().hour;

  if (hour < 12) {
    return 'Good Morning 👋';
  } else if (hour < 17) {
    return 'Good Afternoon ☀️';
  } else if (hour < 21) {
    return 'Good Evening 🌇';
  } else {
    return 'Good Night 🌙';
  }
}
