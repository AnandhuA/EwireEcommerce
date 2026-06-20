import 'package:ewire_ecommerce/screens/cart_page.dart';
import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      titleSpacing: 16,
      title: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Deliver to', style: TextStyle(fontSize: 12)),
          Text('Bangalore', style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
      actions: [
        // IconButton(
        //   onPressed: () {},
        //   icon: const Icon(Icons.notifications_none),
        // ),
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CartPage()),
            );
          },
          icon: const Icon(Icons.shopping_cart_outlined),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
