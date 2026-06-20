
import 'package:hive_flutter/hive_flutter.dart';

import '../models/cart_item_model.dart';

class CartStorageService {
  final Box<CartItemModel> _cartBox =
      Hive.box<CartItemModel>('cart');

  List<CartItemModel> getCartItems() {
    return _cartBox.values.toList();
  }

  Future<void> addItem(CartItemModel item) async {
    await _cartBox.add(item);
  }

  Future<void> deleteItem(int index) async {
    await _cartBox.deleteAt(index);
  }

  Future<void> clearCart() async {
    await _cartBox.clear();
  }

  Future<void> saveItem(CartItemModel item) async {
    await item.save();
  }
}