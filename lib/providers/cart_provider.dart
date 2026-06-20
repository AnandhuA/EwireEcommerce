import 'package:ewire_ecommerce/data/services/cart_storage_service.dart';
import 'package:flutter/material.dart';

import '../data/models/cart_item_model.dart';
import '../data/models/product_model.dart';

class CartProvider extends ChangeNotifier {
  final CartStorageService _cartService = CartStorageService();

  List<CartItemModel> get cartItems => _cartService.getCartItems();

  bool _isCartLoading = false;

  bool get isCartLoading => _isCartLoading;

  // ===== ADD TO CART =====

  Future<void> addToCart(ProductModel product) async {
    _isCartLoading = true;
    notifyListeners();

    final index = cartItems.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (index != -1) {
      final item = cartItems[index];

      item.quantity++;

      await _cartService.saveItem(item);
    } else {
      await _cartService.addItem(
        CartItemModel(
          product: product,
          quantity: 1,
        ),
      );
    }

    _isCartLoading = false;
    notifyListeners();
  }

  // ===== REMOVE ITEM =====

  Future<void> removeFromCart(int productId) async {
    _isCartLoading = true;
    notifyListeners();

    final index = cartItems.indexWhere(
      (item) => item.product.id == productId,
    );

    if (index != -1) {
      await _cartService.deleteItem(index);
    }

    _isCartLoading = false;
    notifyListeners();
  }

  // ===== INCREASE =====

  Future<void> increaseQuantity(int productId) async {
    _isCartLoading = true;
    notifyListeners();

    final item = cartItems.firstWhere(
      (item) => item.product.id == productId,
    );

    item.quantity++;

    await _cartService.saveItem(item);

    _isCartLoading = false;
    notifyListeners();
  }

  // ===== DECREASE =====

  Future<void> decreaseQuantity(int productId) async {
    _isCartLoading = true;
    notifyListeners();

    final index = cartItems.indexWhere(
      (item) => item.product.id == productId,
    );

    if (index == -1) {
      _isCartLoading = false;
      notifyListeners();
      return;
    }

    final item = cartItems[index];

    if (item.quantity > 1) {
      item.quantity--;

      await _cartService.saveItem(item);
    } else {
      await _cartService.deleteItem(index);
    }

    _isCartLoading = false;
    notifyListeners();
  }

  // ===== CLEAR CART =====

  Future<void> clearCart() async {
    _isCartLoading = true;
    notifyListeners();

    await _cartService.clearCart();

    _isCartLoading = false;
    notifyListeners();
  }

  // ===== HELPERS =====

  bool isInCart(int productId) {
    return cartItems.any(
      (item) => item.product.id == productId,
    );
  }

  int getQuantity(int productId) {
    try {
      return cartItems
          .firstWhere(
            (item) => item.product.id == productId,
          )
          .quantity;
    } catch (_) {
      return 0;
    }
  }

  double get totalPrice {
    return cartItems.fold(
      0,
      (sum, item) =>
          sum + (item.product.price * item.quantity),
    );
  }

  int get cartCount {
    return cartItems.fold(
      0,
      (sum, item) => sum + item.quantity,
    );
  }

  int get uniqueProductCount {
    return cartItems.length;
  }
}