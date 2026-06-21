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
            scrolledUnderElevation: 0,
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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: _AnimatedCartButton(product: product),
        ),
      ),
    );
  }
}

class _AnimatedCartButton extends StatefulWidget {
  final ProductModel product;
  const _AnimatedCartButton({required this.product});

  @override
  State<_AnimatedCartButton> createState() => _AnimatedCartButtonState();
}

class _AnimatedCartButtonState extends State<_AnimatedCartButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideOut;
  late Animation<Offset> _slideIn;
  late Animation<double> _fadeOut;
  late Animation<double> _fadeIn;
  bool _isAdding = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cart = context.read<CartProvider>();
      if (cart.isInCart(widget.product.id)) {
        _controller.value = 1.0; // jump to end state instantly
      }
    });
    // "Add to Cart" slides OUT to the right and fades out
    _slideOut = Tween<Offset>(begin: Offset.zero, end: const Offset(1.5, 0))
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
          ),
        );

    _fadeOut = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.45, curve: Curves.easeIn),
      ),
    );

    // "Go to Cart" slides IN from the left and fades in
    _slideIn = Tween<Offset>(begin: const Offset(-1.5, 0), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
          ),
        );

    _fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleAddToCart(CartProvider cart) async {
    if (_isAdding) return;
    setState(() => _isAdding = true);

    // Start slide-out animation
    await _controller.animateTo(0.5);

    // Add to cart at the midpoint (button is empty)
    await cart.addToCart(widget.product);

    // Slide-in "Go to Cart"
    await _controller.animateTo(1.0);

    // if (mounted) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text('${widget.product.title} added to cart!'),
    //       behavior: SnackBarBehavior.floating,
    //     ),
    //   );
    // }

    setState(() => _isAdding = false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, _) {
        final isInCart = cart.isInCart(widget.product.id);

        return SizedBox(
          height: 55,
          child: ElevatedButton(
            onPressed: _isAdding
                ? null
                : isInCart
                ? () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartPage()),
                  )
                : () => _handleAddToCart(cart),
            style: ElevatedButton.styleFrom(
              disabledBackgroundColor: context.primary,
              disabledForegroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                return ClipRect(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // ── "Add To Cart" slides OUT to the right ──
                      if (!isInCart || _controller.value < 0.5)
                        SlideTransition(
                          position: _slideOut,
                          child: FadeTransition(
                            opacity: _fadeOut,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.shopping_cart_outlined),
                                SizedBox(width: 8),
                                Text(
                                  'Add To Cart',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      // ── "Go To Cart" slides IN from the left ──
                      if (isInCart || _controller.value >= 0.5)
                        SlideTransition(
                          position: _slideIn,
                          child: FadeTransition(
                            opacity: _fadeIn,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.shopping_cart_checkout),
                                SizedBox(width: 8),
                                Text(
                                  'Go To Cart',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
