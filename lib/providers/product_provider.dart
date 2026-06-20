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

  void clearSearch() {
    _searchQuery = '';
    _filteredProducts = [];

    notifyListeners();
  }
}
