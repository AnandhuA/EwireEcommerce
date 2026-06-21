import 'package:ewire_ecommerce/data/models/product_details_model.dart';
import 'package:flutter/material.dart';

import '../core/network/api_result.dart';
import '../data/models/product_model.dart';
import '../data/services/product_service.dart';

class ProductProvider extends ChangeNotifier {
  final ProductService _service = ProductService();

  bool _isLoading = false;
  String? _errorMessage;

  List<ProductModel> _products = [];
  List<ProductModel> _filteredProducts = [];

  String _searchQuery = '';

  bool get isLoading => _isLoading;

  bool _isProductDetailsLoading = false;

  bool get isProductDetailsLoading => _isProductDetailsLoading;

  String? get errorMessage => _errorMessage;

  List<ProductModel> get products => _products;

  List<ProductModel> get filteredProducts {
    if (_searchQuery.isEmpty) {
      return _products;
    }

    return _filteredProducts;
  }

  bool get hasNoSearchResults =>
      _searchQuery.isNotEmpty && _filteredProducts.isEmpty;

  ProductDetailsModel? _productDetails;

  ProductDetailsModel? get productDetails => _productDetails;

  //================ FETCH PRODUCTS =================

  Future<void> fetchProducts() async {
    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    final result = await _service.getProducts();

    if (result is Success<List<ProductModel>>) {
      _products = result.data;
      _filteredProducts = [];
      _searchQuery = '';
    }

    if (result is Failure<List<ProductModel>>) {
      _errorMessage = result.message;
    }

    _isLoading = false;

    notifyListeners();
  }

  //=====FETCH PRODUCT DETAILS ========

  Future<void> fetchProductDetails(int id) async {
    _productDetails = null;
    _isProductDetailsLoading = true;
    _errorMessage = null;

    notifyListeners();

    final result = await _service.getProductDetails(id);

    if (result is Success<ProductDetailsModel>) {
      _productDetails = result.data;
    }

    if (result is Failure<ProductDetailsModel>) {
      _errorMessage = result.message;
    }

    _isProductDetailsLoading = false;

    notifyListeners();
  }

  //================ SEARCH PRODUCTS =================

  void searchProducts(String query) {
    _searchQuery = query.trim();

    if (_searchQuery.isEmpty) {
      _filteredProducts = [];
    } else {
      _filteredProducts = _products.where((product) {
        return product.title.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    notifyListeners();
  }

  //================ CLEAR SEARCH =================

void clearProductDetails({
  bool notify = true,
}) {
  _productDetails = null;

  if (notify) {
    notifyListeners();
  }
}
  void clearSearch() {
    _searchQuery = '';
    _filteredProducts = [];

    notifyListeners();
  }
}
