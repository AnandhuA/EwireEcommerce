import 'package:ewire_ecommerce/core/responsive/responsive.dart';
import 'package:ewire_ecommerce/core/themes/theme_extensions.dart';
import 'package:ewire_ecommerce/providers/product_provider.dart';
import 'package:ewire_ecommerce/widgets/app_error_widget.dart';
import 'package:ewire_ecommerce/widgets/home_banner_slider.dart';
import 'package:ewire_ecommerce/widgets/product_list_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/home_app_bar.dart';
import '../widgets/product_grid.dart';
import '../widgets/search_bar_widget.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().fetchProducts();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.background,
      appBar: const HomeAppBar(),
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          //=======LOADING ==========
          if (provider.isLoading) {
            return const ProductListShimmer();
          }

          ///======= ERROR ===========
          if (provider.errorMessage != null) {
            return AppErrorWidget(
              message: provider.errorMessage!,
              onRetry: () {
                context.read<ProductProvider>().fetchProducts();
              },
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              _searchController.clear();
              context.read<ProductProvider>().clearSearch();
              await context.read<ProductProvider>().fetchProducts();
            },
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SearchBarWidget(
                      controller: _searchController,
                      onChanged: (value) {
                        context.read<ProductProvider>().searchProducts(value);
                      },
                      onClear: () {
                        context.read<ProductProvider>().clearSearch();
                      },
                    ),

                    SizedBox(height: context.res.hsm),
                    const HomeBannerSlider(),

                    SizedBox(height: context.res.hsm),

                    Text(
                      'Featured Products',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: context.res.hsm),

                    ProductGrid(products: provider.filteredProducts),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
