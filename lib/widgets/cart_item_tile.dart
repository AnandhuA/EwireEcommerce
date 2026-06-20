import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/models/cart_item_model.dart';
import '../providers/cart_provider.dart';

class CartItemTile extends StatelessWidget {
  final CartItemModel item;

  const CartItemTile({
    super.key,
    required this.item,
  });

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
                borderRadius:
                    BorderRadius.circular(12),
              ),
              child: CachedNetworkImage(
                imageUrl: item.thumbnail,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 2,
                    overflow:
                        TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    '₹${item.price}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            Column(
              children: [
                IconButton(
                  onPressed: () {
                    context
                        .read<CartProvider>()
                        .removeFromCart(
                          item.productId,
                        );
                  },
                  icon: const Icon(
                    Icons.delete_outline,
                  ),
                ),

                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        context
                            .read<CartProvider>()
                            .decreaseQuantity(
                              item.productId,
                            );
                      },
                      icon:
                          const Icon(Icons.remove),
                    ),

                    Text(
                      item.quantity.toString(),
                    ),

                    IconButton(
                      onPressed: () {
                        context
                            .read<CartProvider>()
                            .increaseQuantity(
                              item.productId,
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