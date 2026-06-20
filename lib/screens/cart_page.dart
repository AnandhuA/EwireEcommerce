import 'package:ewire_ecommerce/core/responsive/responsive.dart';
import 'package:ewire_ecommerce/core/themes/theme_extensions.dart';
import 'package:ewire_ecommerce/screens/product_detail_page.dart';
import 'package:ewire_ecommerce/widgets/app_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../widgets/cart_item_tile.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.background,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        title: Consumer<CartProvider>(
          builder: (_, cart, _) => Text('My Cart (${cart.uniqueProductCount})'),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final shouldDelete = await AppAlertDialog.show(
                context: context,
                title: 'Clear Cart',
                message:
                    'Are you sure you want to remove all items from your cart?',
                confirmText: 'Clear',
              );

              if (shouldDelete && context.mounted) {
                await context.read<CartProvider>().clearCart();
              }
            },
            child: const Text('Clear All'),
          ),
        ],
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          if (cart.cartItems.isEmpty) {
            return const Center(child: Text('Cart is Empty'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: cart.cartItems.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProductDetailPage(
                              product: cart.cartItems[index].product,
                            ),
                          ),
                        );
                      },
                      child: CartItemTile(item: cart.cartItems[index]),
                    );
                  },
                ),

                SizedBox(height: context.res.hsm),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Theme.of(context).cardColor,
                  ),
                  child: Column(
                    children: [
                      _buildPriceRow(
                        'Subtotal',
                        '₹${cart.totalPrice.toStringAsFixed(2)}',
                      ),

                      const SizedBox(height: 8),

                      const _PriceRow(title: 'Shipping', value: 'Free'),

                      const SizedBox(height: 8),

                      _PriceRow(title: 'Items', value: '${cart.cartCount}'),

                      const Divider(height: 24),

                      _buildPriceRow(
                        'Total',
                        '₹${cart.totalPrice.toStringAsFixed(2)}',
                        isBold: true,
                      ),

                      const SizedBox(height: 16),

                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Checkout feature coming soon'),
                              ),
                            );
                          },
                          icon: const Icon(Icons.shopping_bag_outlined),
                          label: const Text('Proceed to Checkout'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

Widget _buildPriceRow(String title, String value, {bool isBold = false}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: TextStyle(
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      Text(
        value,
        style: TextStyle(
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    ],
  );
}

class _PriceRow extends StatelessWidget {
  final String title;
  final String value;

  const _PriceRow({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Text(title), Text(value)],
    );
  }
}
