import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:product_management_system/controller/product_controller.dart';
import 'package:product_management_system/models/product_model.dart';
import 'package:provider/provider.dart';

import '../models/cart_model.dart';
import 'add_or_edit_product.dart';

class ProductDetails extends StatefulWidget {
  final ProductModel product;
  const ProductDetails({required this.product, super.key});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  @override
  Widget build(BuildContext context) {
    double maxHeight = MediaQuery.of(context).size.height;
    double maxWidth = MediaQuery.of(context).size.width;

    return Consumer<ProductController>(
        builder: (context, ProductController controller, _) {
      List<ProductModel> products = controller.products;
      List<CartModel> cart = controller.cart;
      CartModel? currentCart;
      if (cart.any((element) => element.product == widget.product)) {
        currentCart =
            cart.where((element) => element.product == widget.product).first;
      }
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.product.productName),
          actions: [
            IconButton(
                onPressed: () {
                  if (products.any((element) =>
                      element.productName == widget.product.productName)) {
                    int productIndex = products.indexWhere((element) =>
                        element.productName == widget.product.productName);

                    controller.deleteProduct(index: productIndex);
                    if (currentCart != null) {
                      controller.deleteFromCart(value: currentCart);
                      Navigator.of(context).pop();
                    }
                  }
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.white,
                )),
            IconButton(
                onPressed: () {
                  if (products.any((element) =>
                      element.productName == widget.product.productName)) {
                    int productIndex = products.indexWhere((element) =>
                        element.productName == widget.product.productName);

                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AddOrEditProduct(
                              isEdit: true,
                              product: widget.product,
                              index: productIndex,
                            )));
                  }
                },
                icon: const Icon(
                  Icons.edit,
                  color: Colors.white,
                )),
          ],
        ),
        body: Column(
          children: [
            Stack(
              children: [
                FlutterCarousel(
                  options: FlutterCarouselOptions(
                    aspectRatio: 3 / 3,
                    viewportFraction: 1,
                  ),
                  items: widget.product.images
                      .map(
                        (e) => Image.file(
                          e,
                          height: maxWidth,
                          width: maxWidth,
                          fit: BoxFit.fill,
                        ),
                      )
                      .toList(),
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: currentCart != null
                      ? widget.product.quantity - currentCart.quantity != 0
                          ? Container(
                              decoration: const BoxDecoration(
                                  color: Colors.black, shape: BoxShape.circle),
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                (widget.product.quantity - currentCart.quantity)
                                    .toString(),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          : const SizedBox()
                      : Container(
                          decoration: const BoxDecoration(
                              color: Colors.black, shape: BoxShape.circle),
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            (widget.product.quantity).toString(),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.product.productName,
                        style: const TextStyle(
                          fontSize: 24,
                        ),
                      ),
                      if (currentCart != null)
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  int cartIndex = cart.indexOf(currentCart!);
                                  controller.decreaseCount(
                                      index: cartIndex,
                                      value: currentCart.quantity - 1);
                                },
                                icon: const Icon(
                                  Icons.remove,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                currentCart.quantity.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              IconButton(
                                disabledColor: Colors.grey,
                                color: Colors.white,
                                onPressed: currentCart.quantity ==
                                        widget.product.quantity
                                    ? null
                                    : () {
                                        int cartIndex =
                                            cart.indexOf(currentCart!);
                                        controller.increaseCount(
                                            index: cartIndex,
                                            value: currentCart.quantity + 1);
                                      },
                                icon: const Icon(
                                  Icons.add,
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            CartModel tempCart = CartModel(widget.product, 1,
                                widget.product.offerPrice * 1);
                            controller.addToCart(tempCart);
                          },
                          child: const Text(
                            "Add to Cart",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.product.productDescription,
                  ),
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}
