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
                    final item = cart.cartItems[index];

                    return Dismissible(
                      key: ValueKey(item.product.id),

                      direction: DismissDirection.endToStart,

                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.delete_outline,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),

                      confirmDismiss: (_) async {
                        return await AppAlertDialog.show(
                          context: context,
                          title: 'Remove Item',
                          message:
                              'Are you sure you want to remove this item from cart?',
                          confirmText: 'Remove',
                        );
                      },

                      onDismissed: (_) async {
                        await context.read<CartProvider>().removeFromCart(
                          item.product.id,
                        );

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${item.product.title} removed'),
                            ),
                          );
                        }
                      },

                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ProductDetailPage(product: item.product),
                            ),
                          );
                        },
                        child: CartItemTile(item: item),
                      ),
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

                      SizedBox(height: context.res.hxs),

                      const _PriceRow(title: 'Shipping', value: 'Free'),

                      SizedBox(height: context.res.hxs),

                      _PriceRow(title: 'Items', value: '${cart.cartCount}'),

                      Divider(height: context.res.hsm),

                      _buildPriceRow(
                        'Total',
                        '₹${cart.totalPrice.toStringAsFixed(2)}',
                        isBold: true,
                      ),

                      SizedBox(height: context.res.hsm),

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
                SizedBox(height: context.res.hsm),
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
