import 'package:flutter/material.dart';
import 'package:product_management_system/models/product_model.dart';

import '../models/cart_model.dart';

class ProductController extends ChangeNotifier {
  List<ProductModel> products = [];
  List<CartModel> cart = [];

  bool addProduct(ProductModel value) {
    try {
      products.add(value);
      notifyListeners();
      return true;
    } catch (error) {
      return false;
    }
  }

  editProduct(int index, ProductModel value) {
    products[index].productName = value.productName;
    products[index].productDescription = value.productDescription;
    products[index].images = value.images;
    products[index].offerPrice = value.offerPrice;
    products[index].originalPrice = value.originalPrice;
    products[index].quantity = value.quantity;
    notifyListeners();
  }

  addToCart(CartModel value) {
    cart.add(value);
    notifyListeners();
  }

  increaseCount({required int index, required int value}) {
    if (cart[index].product.quantity < value) {
    } else {
      cart[index].quantity = value;
      cart[index].totalPrice = cart[index].product.offerPrice * value;
    }
    notifyListeners();
  }

  decreaseCount({required int index, required int value}) {
    if (value == 0) {
      cart.removeAt(index);
    } else {
      cart[index].quantity = value;
      cart[index].totalPrice = cart[index].product.offerPrice * value;
    }
    notifyListeners();
  }

  deleteProduct({required int index}) {
    products.removeAt(index);
    notifyListeners();
  }

  deleteFromCart({required CartModel value}) {
    cart.remove(value);
    notifyListeners();
  }
}
