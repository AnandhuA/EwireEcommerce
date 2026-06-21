import 'package:cached_network_image/cached_network_image.dart';
import 'package:ewire_ecommerce/core/responsive/responsive.dart';
import 'package:ewire_ecommerce/core/themes/app_colors.dart';
import 'package:ewire_ecommerce/core/themes/theme_extensions.dart';
import 'package:ewire_ecommerce/data/models/product_model.dart';
import 'package:ewire_ecommerce/providers/cart_provider.dart';
import 'package:ewire_ecommerce/providers/product_provider.dart';
import 'package:ewire_ecommerce/screens/cart_page.dart';
import 'package:ewire_ecommerce/widgets/rating_stars.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailPage extends StatefulWidget {
  final ProductModel product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late ProductProvider _productProvider;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final provider = context.read<ProductProvider>();

      provider.clearProductDetails();

      await provider.fetchProductDetails(widget.product.id);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _productProvider = context.read<ProductProvider>();
  }

  @override
  void dispose() {
    _productProvider.clearProductDetails(notify: false);
    super.dispose();
  }

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
              background: Consumer<ProductProvider>(
                builder: (context, provider, _) {
                  final details = provider.productDetails;

                  return Hero(
                    tag: 'product_${widget.product.id}',
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      child: CachedNetworkImage(
                        key: ValueKey(
                          details?.thumbnail ?? widget.product.thumbnail,
                        ),
                        imageUrl:
                            details?.thumbnail ?? widget.product.thumbnail,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
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
                    widget.product.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: context.res.hsm),

                  Row(
                    children: [
                      RatingStars(rating: widget.product.rating),

                      const SizedBox(width: 8),

                      Text(
                        widget.product.rating.toStringAsFixed(1),
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  SizedBox(height: context.res.hsm),

                  Consumer<ProductProvider>(
                    builder: (context, provider, _) {
                      final details = provider.productDetails;

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '₹${widget.product.price}',
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  if (details != null) ...[
                                    const SizedBox(width: 8),

                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.red.withValues(alpha: .1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        '${details.discountPercentage.toStringAsFixed(0)}% OFF',
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),

                              if (details != null)
                                Text(
                                  '₹${(widget.product.price / (1 - details.discountPercentage / 100)).toStringAsFixed(0)}',
                                  style: TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    color: context.hitText,
                                  ),
                                ),
                            ],
                          ),
                          if (details != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${details.stock} Stock',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),

                  SizedBox(height: context.res.hmd),

                  const Text(
                    'Description',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: context.res.hsm),

                  Text(
                    widget.product.description,
                    style: const TextStyle(height: 1.5),
                  ),
                  Consumer<ProductProvider>(
                    builder: (context, provider, _) {
                      final details = provider.productDetails;

                      if (details == null) {
                        return const SizedBox.shrink();
                      }

                      return AnimatedOpacity(
                        opacity: 1,
                        duration: const Duration(milliseconds: 400),
                        child: Column(
                          children: [
                            SizedBox(height: context.res.hsm),

                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: context.card,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                children: [
                                  _infoRow('Brand', details.brand),
                                  _infoRow('Category', details.category),
                                  _infoRow('Stock', '${details.stock}'),
                                  _infoRow(
                                    'Warranty',
                                    details.warrantyInformation,
                                  ),
                                  _infoRow(
                                    'Shipping',
                                    details.shippingInformation,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(height: context.res.hsm),
                  Consumer<ProductProvider>(
                    builder: (context, provider, _) {
                      final details = provider.productDetails;

                      if (details == null || details.reviews.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: context.card,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  details.rating.toStringAsFixed(1),
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(width: 12),

                                RatingStars(rating: details.rating),

                                const Spacer(),

                                Text('${details.reviews.length} Reviews'),
                              ],
                            ),
                          ),
                          SizedBox(height: context.res.hsm),

                          const Text(
                            'Customer Reviews',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: context.res.hsm),

                          ...details.reviews.map(
                            (review) => Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: context.card,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 18,
                                        child: Text(review.reviewerName[0]),
                                      ),

                                      const SizedBox(width: 10),

                                      Expanded(
                                        child: Text(
                                          review.reviewerName,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),

                                      Row(
                                        children: List.generate(
                                          5,
                                          (index) => Icon(
                                            index < review.rating
                                                ? Icons.star
                                                : Icons.star_border,
                                            size: 16,
                                            color: AppColors.ratingStar,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 10),

                                  Text(
                                    review.comment,
                                    style: TextStyle(color: context.hitText),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
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
          child: _AnimatedCartButton(product: widget.product),
        ),
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),

          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
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
