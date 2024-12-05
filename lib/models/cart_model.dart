import 'package:product_management_system/models/product_model.dart';

class CartModel {
  ProductModel product;
  int quantity;
  int totalPrice;
  CartModel(
    this.product,
    this.quantity,
    this.totalPrice,
  );
}
