
import 'package:hive_flutter/hive_flutter.dart';

part 'cart_item_model.g.dart';

@HiveType(typeId: 0)
class CartItemModel extends HiveObject {
  @HiveField(0)
  int productId;

  @HiveField(1)
  String title;

  @HiveField(2)
  String thumbnail;

  @HiveField(3)
  double price;

  @HiveField(4)
  int quantity;

  CartItemModel({
    required this.productId,
    required this.title,
    required this.thumbnail,
    required this.price,
    this.quantity = 1,
  });
}