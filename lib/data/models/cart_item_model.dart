import 'package:hive_flutter/hive_flutter.dart';

import 'product_model.dart';

part 'cart_item_model.g.dart';

@HiveType(typeId: 1)
class CartItemModel extends HiveObject {
  @HiveField(0)
  ProductModel product;

  @HiveField(1)
  int quantity;

  CartItemModel({
    required this.product,
    this.quantity = 1,
  });
}