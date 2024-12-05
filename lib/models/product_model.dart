import 'dart:io';

class ProductModel {
  ProductModel(
    this.productName,
    this.productDescription,
    this.originalPrice,
    this.offerPrice,
    this.images,
    this.quantity,
  );
  String productName;
  String productDescription;
  int originalPrice;
  int offerPrice;
  List<File> images;
  int quantity;
}
