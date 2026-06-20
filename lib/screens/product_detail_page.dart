import 'package:cached_network_image/cached_network_image.dart';
import 'package:ewire_ecommerce/core/responsive/responsive.dart';
import 'package:ewire_ecommerce/core/themes/theme_extensions.dart';
import 'package:ewire_ecommerce/data/models/product_model.dart';
import 'package:ewire_ecommerce/providers/cart_provider.dart';
import 'package:ewire_ecommerce/screens/cart_page.dart';
import 'package:ewire_ecommerce/widgets/rating_stars.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailPage extends StatelessWidget {
  final ProductModel product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.background,

      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            backgroundColor: context.card,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'product_${product.id}',
                child: CachedNetworkImage(
                  imageUrl: product.thumbnail,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: context.res.hsm),

                  Row(
                    children: [
                      RatingStars(rating: product.rating),

                      const SizedBox(width: 8),

                      Text(
                        product.rating.toStringAsFixed(1),
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  SizedBox(height: context.res.hsm),

                  Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Text(
                        '₹${product.price}',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: 16,
                              color: Colors.green,
                            ),

                            const SizedBox(width: 6),

                            Text(
                              'In Stock',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: context.res.hsm),

                  SizedBox(height: context.res.hsm),

                  SizedBox(height: context.res.hsm),

                  const Text(
                    'Description',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),

                  SizedBox(height: context.res.hsm),

                  Text(
                    product.description,
                    style: const TextStyle(height: 1.5),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: SafeArea(
        child: Consumer<CartProvider>(
          builder: (context, cart, _) {
            final isInCart = cart.isInCart(product.id);

            return Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                height: 55,
                child: isInCart
                    ? ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const CartPage()),
                          );
                        },
                        icon: const Icon(Icons.shopping_cart_checkout),
                        label: const Text('Go To Cart'),
                      )
                    : ElevatedButton.icon(
                        onPressed: () async {
                          await cart.addToCart(product);

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${product.title} added to cart'),
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.shopping_cart_outlined),
                        label: const Text('Add To Cart'),
                      ),
              ),
            );
          },
        ),
      ),
    );
  }
}
