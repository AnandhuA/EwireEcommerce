import 'package:cached_network_image/cached_network_image.dart';
import 'package:ewire_ecommerce/core/responsive/responsive.dart';
import 'package:ewire_ecommerce/core/themes/app_colors.dart';
import 'package:ewire_ecommerce/core/themes/theme_extensions.dart';
import 'package:ewire_ecommerce/providers/cart_provider.dart';
import 'package:ewire_ecommerce/screens/cart_page.dart';
import 'package:ewire_ecommerce/screens/product_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../data/models/product_model.dart';

class ProductGrid extends StatelessWidget {
  final List<ProductModel> products;

  const ProductGrid({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: context.res.responsive(
          mobile: 2,
          tablet: 3,
          desktop: 4,
        ),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: .8,
      ),
      itemBuilder: (context, index) {
        return _ProductCard(
          product: products[index],
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductDetailPage(product: products[index]),
              ),
            );
          },
        );
      },
    );
  }
}

class _ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onTap;

  const _ProductCard({required this.product, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Card(
        color: context.card,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: Hero(
                  tag: 'product_${product.id}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: product.thumbnail,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(
                        child: SpinKitThreeBounce(
                          color: context.isDarkMode
                              ? Colors.white
                              : Colors.black,
                          size: 10,
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.image_not_supported),
                    ),
                  ),
                ),
              ),

              Text(
                product.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),

              SizedBox(height: context.res.hxs),

              Row(
                children: [
                  Icon(Icons.star, size: 16, color: AppColors.ratingStar),
                  const SizedBox(width: 4),
                  Text(
                    product.rating.toStringAsFixed(1),
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green.withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'In Stock',
                  style: TextStyle(color: Colors.green, fontSize: 10),
                ),
              ),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '₹${(product.price * 1.2).toStringAsFixed(0)}',
                          style: TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: context.hitText,
                            fontSize: 12,
                          ),
                        ),

                        Text(
                          '₹${product.price}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Consumer<CartProvider>(
                    builder: (context, cart, _) {
                      final isInCart = cart.isInCart(product.id);

                      return GestureDetector(
                        onTap: () async {
                          if (isInCart) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const CartPage(),
                              ),
                            );
                          } else {
                            await cart.addToCart(product);
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: context.primary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Text(
                                isInCart ? 'View' : 'Add',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: context.primary,
                                ),
                              ),
                              SizedBox(width: 5),
                              Icon(
                                isInCart
                                    ? Icons.open_in_new_rounded
                                    : Icons.add_shopping_cart,
                                color: context.primary,
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
