import 'package:cached_network_image/cached_network_image.dart';
import 'package:ewire_ecommerce/widgets/app_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/models/cart_item_model.dart';
import '../providers/cart_provider.dart';

class CartItemTile extends StatelessWidget {
  final CartItemModel item;

  const CartItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Hero(
                tag: 'product_${item.product.id}',
                child: CachedNetworkImage(
                  imageUrl: item.product.thumbnail,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    '₹${item.product.price}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            Column(
              children: [
                IconButton(
                  onPressed: () async {
                    final shouldDelete = await AppAlertDialog.show(
                      context: context,
                      title: 'Remove Item',
                      message:
                          'Are you sure you want to remove this item from cart?',
                      confirmText: 'Remove',
                    );

                    if (shouldDelete && context.mounted) {
                      context.read<CartProvider>().removeFromCart(
                        item.product.id,
                      );
                    }
                  },
                  icon: const Icon(Icons.delete_outline),
                ),

                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        context.read<CartProvider>().decreaseQuantity(
                          item.product.id,
                        );
                      },
                      icon: const Icon(Icons.remove),
                    ),

                    Text(item.quantity.toString()),

                    IconButton(
                      onPressed: () {
                        context.read<CartProvider>().increaseQuantity(
                          item.product.id,
                        );
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
